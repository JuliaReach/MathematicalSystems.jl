using MathematicalSystems, LazySets, Test

# ========
# Setup
# ========

n = 3; m = 2; l = 3
A = A1 = rand(n,n)
b = b1 = rand(n)
B = B1 = rand(n,m)
c = c1 = rand(n)
D = D1 = rand(n,l)
E = E1 = rand(l,l)
X = X1 = BallInf(zeros(n), 100.)
U = U1 = BallInf(zeros(m), 100.)
W = W1 = BallInf(zeros(l), 100.)

f1(x) = x'*x
f1(x, u) = x'*x + u'*u
f1(x, u, w) = x'*x + u'*u + w'*w

x = rand(n)
u = rand(m)
w = rand(l)

using MacroTools

# ===================
# DEBUGGING
# ===================
lhs = [:(E*x'=x), :(x'=x), :(x⁺=x), :(E*u⁺=u)]
MathematicalSystems.extract_dynamic_equation.(lhs)
lhs = [:(E1*abdf=x), :(ab=ab), :(abc=abc), :(E*x=x)]
lhs = [:(E1*x=a*x + b*u + c*w), :(ab=ab), :(abc=abc), :(E*x=x)]
state = [:x, :ab, :abc, :x]
noise = [:w, :w, :w, :w]
dim = [2, 1, 3, 4]
MathematicalSystems.extract_parameters.(lhs, state, noise, dim)

MathematicalSystems.extract_parameters.(lhs)
sys = [ [:(x' = A*x)],
        [:(x' = Ax + Bu), :(x ∈ X), :(u ∈ U1), :(dims = (2, 2))],
        [:(E*x' = Ax + Bu), :(x ∈ X), :(u ∈ U1)],
        [:(E1*x⁺ = Ax + Bu), :(x ∈ X), :(u ∈ U1), :(dim=2)],
        [:(x⁺ = A23x + Bu), :(x ∈ X), :(u ∈ U1), :(noise = a)],
        [:(zv⁺ = A1*zv + B1u), :(zv ∈ X), :(u ∈ U1), :(noise : df)] ]
# sys5 =  [:(E*x' = Ax + Bu), :(y = Ax + Bu), :(x ∈ X), :(u ∈ U1)]
# e5 = MathematicalSystems.parse_system(sys5)
MathematicalSystems.parse_system.(sys)

sys = [ [:(x' = A*x)],
        [:(x' = Ax + Bu), :(x ∈ X), :(u ∈ U1)],
        [:(E*x' = Ax)],
        [:(x⁺ = Ax + Bu), :(x ∈ X), :(u ∈ U1)] ]
MathematicalSystems.system.(sys)
MathematicalSystems.@system3(x' = A*x)
MathematicalSystems.@system2(x' = A*x, x∈X)
MathematicalSystems.@system2(E*x' = A*x, x∈X)
MathematicalSystems.@system2(x' = A*x + Bu, x∈X, u∈U)

# ===================
# Continuous systems
# ===================
MS = MathematicalSystems
# ContinuousIdentitySystem
@test MS.@system(x' = x, dim: 2) == ContinuousIdentitySystem(2)
@test MS.@system(x' = x, dim=2) == ContinuousIdentitySystem(2)
@test MS.@system(h' = h, dim: 2) == ContinuousIdentitySystem(2)
@test MS.@system(h' = h, dim=2) == ContinuousIdentitySystem(2)

# ConstrainedContinuousIdentitySystem
@test MS.@system(x' = x, dim: 2, x ∈ X) == ConstrainedContinuousIdentitySystem(2, X)
@test MS.@system(u' = u, dim: 3, u ∈ U) == ConstrainedContinuousIdentitySystem(3, U)
@test MS.@system(x' = x, dim=2, x ∈ X) == ConstrainedContinuousIdentitySystem(2, X)
@test MS.@system(u' = u, dim = 3, u ∈ U) == ConstrainedContinuousIdentitySystem(3, U)

# LinearContinuousSystem
@test MS.@system(x' = A*x) == LinearContinuousSystem(A)
@test MS.@system(x' = Ax) == LinearContinuousSystem(A)
@test MS.@system(z' = A*z) == LinearContinuousSystem(A)
@test MS.@system(z' = Az) == LinearContinuousSystem(A)
@test_throws ArgumentError @system(z⁺ = Ax)
@test_throws ArgumentError @system(x⁺ = Az)

# (For later)
# @test @system x' = x, dim=3 # << recognise as a linear system?
# @test @system x' = 2x, dim=3 # << recognise as a linear system?

# AffineContinuousSystem
@test @system(x' = A*x  + b) == AffineContinuousSystem(A, b)
@test @system(:(x' = Ax + b)) == AffineContinuousSystem(A, b)

# LinearControlContinuousSystem
@test @system(x' = A*x + B1*u) == @system(x' = A1*x + Bu)
@test @system(x' = A*x + B1*u) == LinearControlContinuousSystem(A, B1)
@test @system(x' = Ax + Bu) == LinearControlContinuousSystem(A, B)

# ConstrainedLinearContinuousSystem
# . . .

#=
@test @system(x' = Ax + Bu, x ∈ X, u ∈ U1) == ConstrainedLinearControlContinuousSystem(A, B, X, U1) # pass
@test @system(x' = Ax + Bu + c, x ∈ X, u ∈ U1) == ConstrainedAffineControlContinuousSystem(A, B, c, X, U1) # pass
@test @system(x' = Ax + Bu + Dw, x ∈ X, u ∈ U1, w ∈ W1, w:noise) == NoisyConstrainedLinearControlContinuousSystem(A, B, D, X, U1, W1) # pass
@test @system(x' = Ax + Bu + c + Dw, x ∈ X, u ∈ U1, w ∈ W1, w:noise) == NoisyConstrainedAffineControlContinuousSystem(A, B, c, D, X, U1, W1) # pass


@test_throws ArgumentError @system(x' = Ax + Bu + c) # not a system type

#=

# algebraic
@test @system(Ex' = A*x) == LinearAlgebraicContinuousSystem(A, E)
sys_equal = @system(Ex' = A*x) == @system(E1*x' = A*x)
@test sys_equal # pass
@test @system(Ex' = A*x,x∈X) == ConstrainedLinearAlgebraicContinuousSystem(A, E, X)
@test @system(x' = A1x, x ∈ X1) == ConstrainedLinearContinuousSystem(A1, X1)
@test @system(x' = A1x + Dw, x ∈ X1, w ∈ W, w: noise) == NoisyConstrainedLinearContinuousSystem(A1, D, X1, W1)

# nonlinear
@test_throws ArgumentError @system(x' = f1(x)) # fail
@test @system(x' = f1(x), x ∈ X) == ConstrainedBlackBoxContinuousSystem(f1, 2, X) # fail
@test @system(x' = f1(x, u), x ∈ X, u ∈ U) == ConstrainedBlackBoxControlContinuousSystem(f1, 2, 2, X, U) # fail
@test_throws ArgumentError @system(x' = f1(x, u)) # fail
@test @system(x' = f1(x, u, w), x ∈ X, u ∈ U, w ∈ W) == NoisyConstrainedBlackBoxControlContinuousSystem(f1, 2, 2, 2, X, U, W) # fail


# ==================
# Discrete systems
# ==================

# linear
@test @system(x⁺ = A*x) == LinearDiscreteSystem(A)
@test @system(x⁺ = Ax) == LinearDiscreteSystem(A)
@test @system(z⁺ = A*z) == LinearDiscreteSystem(A)
@test @system(z⁺ = Az) == LinearDiscreteSystem(A)
@test_throws ArgumentError @system(z⁺ = Ax)
@test_throws ArgumentError @system(x⁺ = Az)

# affine
@test @system(x⁺ = A1*x + c) == AffineDiscreteSystem(A1, c)
@test_throws ArgumentError @system(x⁺ = Ax + Bu + c)

# algebraic
@test @system(Ex⁺ = Ax) == LinearAlgebraicDiscreteSystem(A, E)
sys_equal = @system(Ex⁺ = Ax) == @system(E1*x⁺ = A1*x)
@test sys_equal # pass
@test @system(Ex⁺ = A*x, x ∈ X) == ConstrainedLinearAlgebraicDiscreteSystem(A, E, X)
@test @system(x⁺ = A1x, x ∈ X1) == ConstrainedLinearDiscreteSystem(A1, X1)
@test @system(x⁺ = A1x + Dw, x ∈ X1, w ∈ W) == NoisyConstrainedLinearDiscreteSystem(A1, D, X1, W1)
@test @system(x⁺ = A*x + B1*u) == LinearControlDiscreteSystem(A, B)
@test @system(x⁺ = A*x + B1*u) == @system(x⁺ = A1*x + Bu)

# control

# u or other symbols are used for inputs

# here u is interpreted as input
@test @system(x⁺ = Ax + Bu, x ∈ X, u ∈ U1) == ConstrainedLinearControlDiscreteSystem(A, B, X, U1)

# here w is interpreted as input
@test @system(x⁺ = A1x + Dw, x ∈ X1, w ∈ W) == ConstrainedLinearControlDiscreteSystem(A1, D, X1, W)

# if you want u to be interpreted as noise, use u: noise
@test @system(x⁺ = Ax + Bu, x ∈ X, u ∈ U1, u: noise) == ConstrainedLinearControlDiscreteSystem(A, B, X, U1)

# if you want w to be interpreted as noise, use w: noise
@test @system(x⁺ = A1x + Dw, x ∈ X1, w ∈ W, w: noise) == NoisyConstrainedLinearControlDiscreteSystem(A1, D, X1, W)

@test @system(x⁺ = Ax + Bu + c, x ∈ X, u ∈ U1) == ConstrainedAffineControlDiscreteSystem(A, B, c, X, U1)

# more noisy cases
@test @system(x⁺ = A1x + Dw, x ∈ X1, w ∈ W, w:noise) == ConstrainedLinearControlDiscreteSystem(A1, D, X1, W1)
@test @system(x⁺ = Ax + Bu + Dw, x ∈ X, u ∈ U1, w ∈ W1, w:noise, u:input) == NoisyConstrainedLinearControlDiscreteSystem(A, B, D, X, U1, W)
@test @system(x⁺ = Ax + Bu + c + Dw, x ∈ X, u ∈ U1, w ∈ W1, w:noise, u:input) == NoisyConstrainedAffineControlDiscreteSystem(A, B, c, D, X, U1, W1)

# nonlinear
@test @system(x⁺ = f1(x), dim=2) == BlackBoxDiscreteSystem(f1, 2)
@test @system(x⁺ = f1(x), dim: 2, x ∈ X) == ConstrainedBlackBoxDiscreteSystem(f1, 2, X)
@test @system(x⁺ = f1(x, u), x ∈ X, u ∈ U, dims = (2, 2)) == ConstrainedBlackBoxControlDiscreteSystem(f1, 2, 2, X, U)
@test @system(x⁺ = f1(x, u, w), x ∈ X, u ∈ U, w ∈ W) == NoisyConstrainedBlackBoxControlDiscreteSystem(f1, 2, 2, 2, X, U, W)

# Notes:
# In the nonlinear case, ATM the constructor needs the dimension, but there is no such information
# in x⁺ = f1(x). So we propose to require @system x⁺ = f1(x), dim=4, i.e. it should passed explicitly.
# Otherwise, we could let the dimension field optional in the constructor.

=#
