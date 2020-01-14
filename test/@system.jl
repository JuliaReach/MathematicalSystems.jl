# ========
# Setup
# ========

n = 3; m = 2; l = 3
A = A1 = rand(n, n)
B = B1 = rand(n, m)
c = c1 = rand(n)
D = D1 = rand(n, l)
E = E1 = rand(l, l)
X = X1 = BallInf(zeros(n), 50.)
U = U1 = BallInf(zeros(m), 70.)
W = W1 = BallInf(zeros(l), 100.)

f1(x) = x'*x
f1(x, u) = x'*x + u'*u
f1(x, u, w) = x'*x + u'*u + w'*w


# ===================
# Playground Tests
# ===================

sys = @system(x' = Ax + Bu + w, x∈X, u∈U, w∈W)
sys2 = @system(x' = Ax + Bu + w, x∈X, w∈W, u∈U)
sys == NoisyConstrainedLinearControlContinuousSystem(A,B, Diagonal(ones(n)), X, U, W)
# Caveat: (aka BUG)
sys2 == NoisyConstrainedLinearControlContinuousSystem(A,B, Diagonal(ones(n)), X, U, W)
sys = @system(x' = Ax + u + w, x∈X, u∈U, w∈W)
sys == NoisyConstrainedLinearControlContinuousSystem(A,Diagonal(ones(n)), Diagonal(ones(n)), X, U, W)
@system(x' = Ax + u) == LinearControlContinuousSystem(A, Diagonal(ones(n)))
@system(x' = Ax + w, x∈X, w∈W) == NoisyConstrainedLinearContinuousSystem(A, Diagonal(ones(n)), X, W)



# ===================
# Continuous systems
# ===================

@testset "@system for continous identity systems" begin
    @test @system(x' = 0, dim: 2) == ContinuousIdentitySystem(2)
    @test @system(x₁' = 0, dim=2) == ContinuousIdentitySystem(2)

    @test @system(x' = 0, dim: 2, x ∈ X) == ConstrainedContinuousIdentitySystem(2, X)
    @test @system(x' = 0, dim=2, x ∈ X1) == ConstrainedContinuousIdentitySystem(2, X)
end

@testset "@system for linear continous systems" begin
    @test @system(x' = A*x) == LinearContinuousSystem(A)
    @test @system(x1' = A1x1) == LinearContinuousSystem(A1)

    # automatic identification of rhs linearity
    @test @system(x' = -x) == LinearContinuousSystem(-1.0*Diagonal(ones(1)))
    @test @system(x' = x, dim=3) == LinearContinuousSystem(Diagonal(ones(3)))
    @test @system(x' = 2x, dim=3) == LinearContinuousSystem(2.0*Diagonal(ones(3)))

    @test @system(x' = A*x, x ∈ X) == ConstrainedLinearContinuousSystem(A,X)
    @test @system(x1' = A1x1, x1 ∈ X1) == ConstrainedLinearContinuousSystem(A1,X1)
end

@testset "@system for linear control continuous systems" begin
    # if the state should be named `w`
    @test @system(w' = Aw + Bu) == LinearControlContinuousSystem(A, B)
    # but if the input should be named `w`
    # without specification, a noisy system is returned
    @test  @system(x' = Ax + Bw, x∈X, w∈W) == NoisyConstrainedLinearContinuousSystem(A, B, X, W)
    # but if we use the `input:w`, a controlled system is returned
    @test @system(x' = Ax + Bw, input:w) == LinearControlContinuousSystem(A, B)
    # and in general, if the input name is different from `u`
    @test @system(x' = Ax + Bu_1, input:u_1) == LinearControlContinuousSystem(A, B)
    @test @system(x' = Ax + B*u_1, input:u_1) == LinearControlContinuousSystem(A, B)

    @test @system(x' = A1x + B1u) == LinearControlContinuousSystem(A1, B1)
    @test @system(z_1' = A*z_1 + B*u_1, input:u_1) == LinearControlContinuousSystem(A, B)

    @test @system(x' = Ax + Bu, x ∈ X, u ∈ U) == ConstrainedLinearControlContinuousSystem(A, B, X, U)

    # if * are used x_ =A_*x_ + B_*u_, u_ is interpreted as input variable,
    # independent of the name used for u_
    @test @system(w' = A*w + B*u_1) == LinearControlContinuousSystem(A, B)
    # similarily for x_ =A_*x_ + B_*u_ + c_
    @test @system(w' = A*w + B*u_1 + c, w∈X, u_1∈U) == ConstrainedAffineControlContinuousSystem(A, B, c, X, U)
end

@testset "@system for linear algebraic continous systems" begin
    # lhs needs a *
    @test_throws ArgumentError @system(Ex' = Ax)
    @test@system(E*x' = Ax) == LinearAlgebraicContinuousSystem(A, E)

    @test @system(E*x' = A*x) == LinearAlgebraicContinuousSystem(A, E)
    @test @system(E*x' = A*x, x∈X) == ConstrainedLinearAlgebraicContinuousSystem(A, E, X)
end

@testset "@system for affine continuous systems" begin
    @test @system(x' = A*x  + c) == AffineContinuousSystem(A, c)
    sys =  @system(z_1' = A*z_1 + B*v_1 + c1, z_1 ∈ X, v_1 ∈ U1, input:v_1)
    @test sys == ConstrainedAffineControlContinuousSystem(A, B, c1, X, U1)
    @test_throws ArgumentError @system(x' = Ax + Bu + c) # not a system type
end

@testset "@system for noisy continous systems" begin
    sys = @system(x' = f1(x, u, w), x ∈ X, u ∈ U, w ∈ W, dims=(1, 2,3))
    @test sys == NoisyConstrainedBlackBoxControlContinuousSystem(f1, 1, 2, 3, X, U, W)

    sys = @system(x' = Ax + Bu + Dw, x ∈ X, u ∈ U1, w ∈ W1)
    @test sys == NoisyConstrainedLinearControlContinuousSystem(A, B, D, X, U1, W1)
    sys = @system(z_1' = Az_1 + B*v_1 + c + Dd_1, z_1 ∈ X, v_1 ∈ U1, d_1 ∈ W1, input:v_1, d_1:noise)
    @test sys == NoisyConstrainedAffineControlContinuousSystem(A, B, c, D, X, U1, W1)
end

@testset "@system for black-box continous systems" begin
    @test_throws ArgumentError @system(x' = f1(x))
    @test_throws ArgumentError @system(x' = f1(x, u))
    sys =  @system(x' = f1(x), dim:3)
    @test sys == BlackBoxContinuousSystem(f1, 3)
    sys =  @system(x' = f1(x), x ∈ X, dim:2)
    @test sys == ConstrainedBlackBoxContinuousSystem(f1, 2, X)
    sys = @system(x' = f1(x, u), x ∈ X, u ∈ U, dims=(1, 2))
    @test sys == ConstrainedBlackBoxControlContinuousSystem(f1, 1, 2, X, U)
end

# ==================
# Discrete systems
# ==================

@testset "@system for discrete identity systems" begin
    @test @system(x⁺ = x, dim=2) == DiscreteIdentitySystem(2)
    @test @system(x₁⁺ = x₁, dim: 2) == DiscreteIdentitySystem(2)

    @test @system(u⁺ = u, dim: 3, u ∈ U) == ConstrainedDiscreteIdentitySystem(3, U)
    @test @system(x1⁺ = x1, dim = 3, x1 ∈ X1) == ConstrainedDiscreteIdentitySystem(3, X1)

    # emoij support 😉
    🚈 = X
    sys = @system(👨⁺ = 👨, dim: 2, 👨∈🚈)
    @test sys == ConstrainedDiscreteIdentitySystem(2, X)
end

@testset "@system for linear discrete systems" begin
    @test @system(x⁺ = A*x) == LinearDiscreteSystem(A)
    @test @system(x⁺ = Ax) == LinearDiscreteSystem(A)
    @test @system(z⁺ = A*z) == LinearDiscreteSystem(A)
    @test @system(z⁺ = Az) == LinearDiscreteSystem(A)
    @test_throws ArgumentError @system(z⁺ = Ax)
    @test_throws ArgumentError @system(x⁺ = Az)
    @test @system(x1⁺ = A*x1) == LinearDiscreteSystem(A)
    @test @system(x1⁺ = Ax1) == LinearDiscreteSystem(A)

    @test @system(x⁺ = 2x, dim=3) == LinearDiscreteSystem(2.0*Diagonal(ones(3)))

    @test @system(x⁺ = A1x, x ∈ X1) == ConstrainedLinearDiscreteSystem(A1, X1)
end

@testset "@system for affine discrete systems" begin
    @test @system(x⁺ = A*x + c) == AffineDiscreteSystem(A, c)
    @test @system(x⁺ = A1*x + c1) == AffineDiscreteSystem(A1, c1)
    @test_throws ArgumentError @system(x⁺ = Ax + Bu + c) # not a system type
end

@testset "@system for linear algebraic discrete systems" begin
    sys = @system(E*x⁺ = Ax)
    @test sys == LinearAlgebraicDiscreteSystem(A, E)
    @test sys == @system(E1*x⁺ = A1*x)

    sys = @system(E*x⁺ = A*x, x ∈ X)
    @test sys == ConstrainedLinearAlgebraicDiscreteSystem(A, E, X)
end

@testset "@system for linear control discrete systems" begin
    sys = @system(x⁺ = A*x + B1*u)
    @test sys == LinearControlDiscreteSystem(A, B)
    @test sys == @system(x⁺ = A1*x + Bu)

    @test @system(x⁺ = A1x + B1u) == LinearControlDiscreteSystem(A1, B1)
    @test @system(z_1⁺ = A*z_1 + B*v_1, input:v_1) == LinearControlDiscreteSystem(A, B)

    # u or other symbols are used for inputs; here u is interpreted as input
    sys = @system(x⁺ = Ax + Bu, x ∈ X, u ∈ U1)
    @test sys == ConstrainedLinearControlDiscreteSystem(A, B, X, U1)

    # here v is interpreted as input (if the input has more than one letter, use a *)
    @system(x⁺ = Ax + B*u123, x ∈ X, u123 ∈ U1, input: u123)
    @test sys == ConstrainedLinearControlDiscreteSystem(A, B, X, U1)

    sys = @system(x⁺ = Ax + Bu123, x ∈ X, u123 ∈ U1, input: u123)
    @test sys == ConstrainedLinearControlDiscreteSystem(A, B, X, U1)
end

@testset "@system for noisy discrete systems" begin
    sys = @system(x⁺ = A1x + Dw, x ∈ X1, w ∈ W)
    @test sys == NoisyConstrainedLinearDiscreteSystem(A1, D, X1, W1)

    # by default w is reserved for noise; here w is interpreted as noise
    sys = @system(x⁺ = A1x + Dw, x ∈ X1, w ∈ W)
    @test sys == NoisyConstrainedLinearDiscreteSystem(A1, D, X1, W)

    sys = @system(x⁺ = A1x + Dw, x ∈ X1, w ∈ W, w:noise)
    @test sys == NoisyConstrainedLinearDiscreteSystem(A1, D, X1, W1)

    sys = @system(x⁺ = Ax + Bu + Dw, x ∈ X, u ∈ U1, w ∈ W1, w:noise, u:input)
    @test sys == NoisyConstrainedLinearControlDiscreteSystem(A, B, D, X, U1, W)

    sys = @system(x⁺ = Ax + Bu + c + Dw, x ∈ X, u ∈ U1, w ∈ W1, w:noise, u:input)
    @test sys == NoisyConstrainedAffineControlDiscreteSystem(A, B, c, D, X, U1, W1)
end

@testset "@system for black-box discrete systems" begin
    sys = @system(x⁺ = f1(x), dim=2)
    @test sys == BlackBoxDiscreteSystem(f1, 2)

    sys = @system(x⁺ = f1(x), dim: 2, x ∈ X)
    @test sys == ConstrainedBlackBoxDiscreteSystem(f1, 2, X)

    sys = @system(x⁺ = f1(x, u), x ∈ X, u ∈ U, dims = (2, 2))
    @test sys == ConstrainedBlackBoxControlDiscreteSystem(f1, 2, 2, X, U)

    sys = @system(x⁺ = f1(x, u, w), x ∈ X, u ∈ U, w ∈ W, dims = (2, 2, 2))
    @test sys == NoisyConstrainedBlackBoxControlDiscreteSystem(f1, 2, 2, 2, X, U, W)
end
