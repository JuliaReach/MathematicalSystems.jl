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

# ===================
# Continuous systems
# ===================

# Peculiarities
# if the state should be named `w`
@test @system(w' = Aw + Bu) == LinearControlContinuousSystem(A,B)
# but if the input should be named `w`
@test_throws @system(x' = Ax + Bw)
@test @system(x' = Ax + Bw, noise:w1) == LinearControlContinuousSystem(A,B)
# if the input has more than one letter
@test_throws @system(x' = Ax + Bu_1)
@test @system(x' = Ax + B*u_1) == LinearControlContinuousSystem(A,B)
# emoij support 😉
🚈 = X
@test @system(👨⁺ = 👨, dim: 2, 👨∈🚈) == ConstrainedDiscreteIdentitySystem(2,X)
# lhs needs a *
@testthrows @system(Ex' = Ax) == LinearAlgebraicContinuousSystem(A, E)
@test@system(E*x' = Ax) == LinearAlgebraicContinuousSystem(A, E)


# IdentitySystem
@test @system(x' = 0, dim: 2) == ContinuousIdentitySystem(2)
@test @system(x_1' = 0, dim=2) == ContinuousIdentitySystem(2)
@test @system(x⁺ = x, dim=2) == DiscreteIdentitySystem(2)
@test @system(x_1⁺ = x_1, dim: 2) == DiscreteIdentitySystem(2)

# ConstrainedIdentitySystem
@test @system(x' = 0, dim: 2, x ∈ X) == ConstrainedContinuousIdentitySystem(2, X)
@test @system(x' = 0, dim=2, x ∈ X1) == ConstrainedContinuousIdentitySystem(2, X)
@test @system(u⁺ = u, dim: 3, u ∈ U) == ConstrainedDiscreteIdentitySystem(3, U)
@test @system(x1⁺ = x1, dim = 3, x1 ∈ U1) == ConstrainedDiscreteIdentitySystem(3, U)

# LinearSystem
@test @system(x' = A*x) == LinearContinuousSystem(A)
@test @system(x1' = A1x1) == LinearContinuousSystem(A)
@test @system(x1⁺ = A*x1) == LinearDiscreteSystem(A)
@test @system(x1⁺ = Ax1) == LinearDiscreteSystem(A)
@test_throws ArgumentError @system(z⁺ = Ax)
@test_throws ArgumentError @system(x⁺ = Az)

# (For later)
@test @system(x' = x, dim=3) == LinearContinuousSystem(Matrix{Int}(I, 3, 3))
@test @system(x' = 2x, dim=3) == LinearContinuousSystem(2.0*Matrix{Int}(I, 3, 3))
@test @system(x⁺ = 2x, dim=3) == LinearDiscreteSystem(2.0*Matrix{Int}(I, 3, 3))

# AffineSystem
# Needs AffineContinuousSystem to have fields :A, :c
@test @system(x' = A*x  + b) == AffineContinuousSystem(A, b)
@test @system(x⁺ = Ax + b) == AffineDiscreteSystem(A, b)

# LinearControlSystem
@test @system(x' = A1x + B1u) == LinearControlContinuousSystem(A1, B1)
@test @system(z_1' = A*z_1 + B*u_1) == LinearControlContinuousSystem(A, B)

@test @system(x⁺ = A1x + B1u) == LinearControlDiscreteSystem(A1, B1)
@test @system(z_1⁺ = A*z_1 + B*v_1) == LinearControlDiscreteSystem(A, B)

# Constrained affine Systems
@test @system(x' = Ax + Bu, x ∈ X, u ∈ U) == ConstrainedLinearControlContinuousSystem(A, B, X, U1) # pass
@test @system(z_1' = A*z_1 + B*v_1 + c, z_1 ∈ X, v_1 ∈ U1) == ConstrainedAffineControlContinuousSystem(A, B, c, X, U1) # pass
@test @system(x' = Ax + Bu + Dw, x ∈ X, u ∈ U1, w ∈ W1) == NoisyConstrainedLinearControlContinuousSystem(A, B, D, X, U1, W1) # pass
@test @system(z_1' = Az_1 + B*v_1 + c + Dd_1, z_1 ∈ X, v_1 ∈ U1, d_1 ∈ W1, d_1:noise) == NoisyConstrainedAffineControlContinuousSystem(A, B, c, D, X, U1, W1) # pass

@test_throws ArgumentError @system(x' = Ax + Bu + c) # not a system type

# algebraic systems
@test @system(E*x' = A*x) == LinearAlgebraicContinuousSystem(A, E)
@test @system(E*x' = A*x,x∈X) == ConstrainedLinearAlgebraicContinuousSystem(A, E, X)

# nonlinear
@test_throws ArgumentError @system(x' = f1(x)) # fail
@test @system(x' = f1(x), x ∈ X, dim:2) == ConstrainedBlackBoxContinuousSystem(f1, 2, X) # fail
@test @system(x' = f1(x, u), x ∈ X, u ∈ U, dims=(1, 2)) == ConstrainedBlackBoxControlContinuousSystem(f1, 1, 2, X, U) # fail
@test_throws ArgumentError @system(x' = f1(x, u)) # fail
@test @system(x' = f1(x, u, w), x ∈ X, u ∈ U, w ∈ W, dims=(1, 2,3)) == NoisyConstrainedBlackBoxControlContinuousSystem(f1, 1, 2, 3, X, U, W) # fail

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
@test @system(E*x⁺ = Ax) == LinearAlgebraicDiscreteSystem(A, E)
sys_equal = @system(E*x⁺ = Ax) == @system(E1*x⁺ = A1*x)
@test sys_equal # pass
@test @system(E*x⁺ = A*x, x ∈ X) == ConstrainedLinearAlgebraicDiscreteSystem(A, E, X)
@test @system(x⁺ = A1x, x ∈ X1) == ConstrainedLinearDiscreteSystem(A1, X1)
@test @system(x⁺ = A1x + Dw, x ∈ X1, w ∈ W) == NoisyConstrainedLinearDiscreteSystem(A1, D, X1, W1)
@test @system(x⁺ = A*x + B1*u) == LinearControlDiscreteSystem(A, B)
@test @system(x⁺ = A*x + B1*u) == @system(x⁺ = A1*x + Bu)

# control

# u or other symbols are used for inputs

# here u is interpreted as input
@test @system(x⁺ = Ax + Bu, x ∈ X, u ∈ U1) == ConstrainedLinearControlDiscreteSystem(A, B, X, U1)
# here v is interpreted as input (if the input has more than one letter, use a *)
@test @system(x⁺ = Ax + B*u123, x ∈ X, u123 ∈ U1) == ConstrainedLinearControlDiscreteSystem(A, B, X, U1)
@test_throws ArgumentError @system(x⁺ = Ax + Bu123, x ∈ X, u123 ∈ U1) == ConstrainedLinearControlDiscreteSystem(A, B, X, U1)

# by default w is reserved for nosie
# here w is interpreted as noise
@test @system(x⁺ = A1x + Dw, x ∈ X1, w ∈ W) == NoisyConstrainedLinearDiscreteSystem(A1, D, X1, W)

# if you want w to be interpreted as input, overwritte that w is noise by using e.g. w1: noise
@test @system(x⁺ = Ax + Bw, x ∈ X, w ∈ U1, w1: noise) == ConstrainedLinearControlDiscreteSystem(A, B, X, U1)
# if u does not correspond to the constraint, throw exception
@test_throw ArgumentError @system(x⁺ = Ax + Bw, x ∈ X, u1 ∈ U1, w1: noise) == ConstrainedLinearControlDiscreteSystem(A, B, X, U1)

@test @system(x⁺ = Ax + Bu + c, x ∈ X, u ∈ U1) == ConstrainedAffineControlDiscreteSystem(A, B, c, X, U1)

# more noisy cases
@test @system(x⁺ = A1x + Dw, x ∈ X1, w ∈ W, w:noise) == NoisyConstrainedLinearDiscreteSystem(A1, D, X1, W1)
# @test @system(x⁺ = Ax + Bu + Dw, x ∈ X, u ∈ U1, w ∈ W1, w:noise, u:input) == NoisyConstrainedLinearControlDiscreteSystem(A, B, D, X, U1, W)
# @test @system(x⁺ = Ax + Bu + c + Dw, x ∈ X, u ∈ U1, w ∈ W1, w:noise, u:input) == NoisyConstrainedAffineControlDiscreteSystem(A, B, c, D, X, U1, W1)

# nonlinear
@test @system(x⁺ = f1(x), dim=2) == BlackBoxDiscreteSystem(f1, 2)
@test @system(x⁺ = f1(x), dim: 2, x ∈ X) == ConstrainedBlackBoxDiscreteSystem(f1, 2, X)
@test @system(x⁺ = f1(x, u), x ∈ X, u ∈ U, dims = (2, 2)) == ConstrainedBlackBoxControlDiscreteSystem(f1, 2, 2, X, U)
@test @system(x⁺ = f1(x, u, w), x ∈ X, u ∈ U, w ∈ W, dims = (2, 2, 2)) == NoisyConstrainedBlackBoxControlDiscreteSystem(f1, 2, 2, 2, X, U, W)

# Notes:
# In the nonlinear case, ATM the constructor needs the dimension, but there is no such information
# in x⁺ = f1(x). So we propose to require @system x⁺ = f1(x), dim=4, i.e. it should passed explicitly.
# Otherwise, we could let the dimension field optional in the constructor.

=#



## @system utility functions
