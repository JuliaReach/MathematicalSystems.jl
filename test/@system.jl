@testset "_corresponding_type" begin
    for AS in [AbstractContinuousSystem, AbstractDiscreteSystem]
        for S in subtypes(AS)
            @test MathematicalSystems._corresponding_type(AS, fieldnames.(S)) == S
        end
    end
end

# ========
# Setup
# ========

n = 3;
m = 2;
l = 3;
A = A1 = rand(n, n)
B = B1 = rand(n, m)
c = c1 = rand(n)
D = D1 = rand(n, l)
E = E1 = rand(l, l)
X = X1 = BallInf(zeros(n), 50.0)
U = U1 = BallInf(zeros(m), 70.0)
W = W1 = BallInf(zeros(l), 100.0)

f1(x) = x' * x
f1(x, u) = x' * x + u' * u
f1(x, u, w) = x' * x + u' * u + w' * w

# ===================
# Error Handling
# ===================
@testset "@system miscellaneous" begin
    @testset "@system for arbitrary order of set specification" begin
        sys = @system(x' = Ax + Bu, u ∈ U, x ∈ X)
        @test sys == ConstrainedLinearControlContinuousSystem(A, B, X, U)
        sys = @system(x' = Ax + Bu + Dw, u ∈ U, w ∈ W, x ∈ X)
        @test sys == NoisyConstrainedLinearControlContinuousSystem(A, B, D, X, U, W)
    end
    @testset "@system for arbitrary order of rhs terms" begin
        sys = @system(x' = Bu + Ax, u ∈ U, x ∈ X)
        @test sys == ConstrainedLinearControlContinuousSystem(A, B, X, U)
        sys = @system(x' = Dw + Ax + Bu, u ∈ U, w ∈ W, x ∈ X)
        @test sys == NoisyConstrainedLinearControlContinuousSystem(A, B, D, X, U, W)
        sys = @system(x' = c + Ax + Bu, u ∈ U, x ∈ X)
        @test sys == ConstrainedAffineControlContinuousSystem(A, B, c, X, U)
    end

    @testset "@system for incorrect variable handling" begin
        @test_throws ArgumentError("state and input variables have the same name `a`") @system(a⁺ = Aa +
                                                                                                    Bw,
                                                                                               input:a)
        @test_throws ArgumentError("state and input variables have the same name `x`") @system(x⁺ = Ax +
                                                                                                    Bx,
                                                                                               input:x)
        @test_throws ArgumentError("input and noise variables have the same name `u`") @system(x⁺ = Ax +
                                                                                                    Bu +
                                                                                                    Bw,
                                                                                               input:u,
                                                                                               noise:u)
        @test_throws ArgumentError("there is more than one input term `w`") @system(x⁺ = Ax + Bw +
                                                                                         Dw,
                                                                                    input:w)
        @test_throws ArgumentError("there is more than one input term `u`") @system(x⁺ = Ax + Bu +
                                                                                         Bu,
                                                                                    noise:u)
        @test_throws ArgumentError("there is more than one state term `x`") @system(x⁺ = Ax + Bx)
        @test_throws ArgumentError("there is more than one constant term") @system(x⁺ = Ax + c + c)
        # @test_throws ArgumentError("input and noise variables have the same name `u`") @system(x⁺= Ax + Bu + Bw,  noise:u)
        # @test_throws ArgumentError("input and noise variables have the same name `w`") @system(x⁺= Ax + Bu + Bw,  input:w)
    end
end

# ===================
# Continuous systems
# ===================
@testset "@system for continuous identity systems" begin
    @test @system(x' = 0, dim:2) == ContinuousIdentitySystem(2)
    sys = @system x' = 0 dim:2
    @test sys == ContinuousIdentitySystem(2)

    @test @system(x₁' = 0, dim = 2) == ContinuousIdentitySystem(2)

    @test @system(x' = 0, dim:2, x ∈ X) == ConstrainedContinuousIdentitySystem(2, X)
    @test @system(x' = 0, dim = 2, x ∈ X1) == ConstrainedContinuousIdentitySystem(2, X)
    sys = @system x' = 0 dim = 2 x ∈ X1
    @test sys == ConstrainedContinuousIdentitySystem(2, X)
end

@testset "@system for linear continuous systems" begin
    @test @system(x' = A * x) == LinearContinuousSystem(A)
    @test @system(x1' = A1x1) == LinearContinuousSystem(A1)
    sys = @system x1' = A1x1
    @test sys == LinearContinuousSystem(A1)

    # automatic identification of rhs linearity
    @test @system(x' = -x) == LinearContinuousSystem(-1.0 * IdentityMultiple(I, 1))
    @test @system(x' = x, dim = 3) == LinearContinuousSystem(1.0 * IdentityMultiple(I, 3))
    @test @system(x' = 2x, dim = 3) == LinearContinuousSystem(2.0 * IdentityMultiple(I, 3))

    @test @system(x' = A * x, x ∈ X) == ConstrainedLinearContinuousSystem(A, X)
    @test @system(x1' = A1x1, x1 ∈ X1) == ConstrainedLinearContinuousSystem(A1, X1)
    sys = @system x1' = A1x1 x1 ∈ X1
    @test sys == ConstrainedLinearContinuousSystem(A1, X1)
end

@testset "@system for linear control continuous systems" begin
    # if the state should be named `w`
    @test @system(w' = Aw + Bu) == LinearControlContinuousSystem(A, B)
    # but if the input should be named `w`
    # without specification, a noisy system is returned
    @test @system(x' = Ax + Bw, x ∈ X, w ∈ W) == NoisyConstrainedLinearContinuousSystem(A, B, X, W)
    # but if we use the `input:w`, a controlled system is returned
    @test @system(x' = Ax + Bw, input:w) == LinearControlContinuousSystem(A, B)
    # and in general, if the input name is different from `u`
    @test @system(x' = Ax + Bu_1, input:u_1) == LinearControlContinuousSystem(A, B)
    @test @system(x' = Ax + B * u_1, input:u_1) == LinearControlContinuousSystem(A, B)

    @test @system(x' = A1x + B1u) == LinearControlContinuousSystem(A1, B1)
    @test @system(z_1' = A * z_1 + B * u_1, input:u_1) == LinearControlContinuousSystem(A, B)

    @test @system(x' = Ax + Bu, x ∈ X, u ∈ U) ==
          ConstrainedLinearControlContinuousSystem(A, B, X, U)

    # if variable in front of input is omitted add identity matrix
    @system(x' = Ax + u) == LinearControlContinuousSystem(A, IdentityMultiple(1.0 * I, n))

    # if * are used x_ = A_*x_ + B_*u_, u_ is interpreted as input variable,
    # independent of the name used for u_
    @test @system(w' = A * w + B * u_1) == LinearControlContinuousSystem(A, B)
    # similarly for x_ = A_*x_ + B_*u_ + c_
    @test @system(w' = A * w + B * u_1 + c, w ∈ X, u_1 ∈ U) ==
          ConstrainedAffineControlContinuousSystem(A, B, c, X, U)

    # scalar cases
    @test @system(x' = 0.5x + u) == LinearControlContinuousSystem(hcat(0.5), Id(1, 1.0))
    @test @system(x' = 0.5x + 1.0) == AffineContinuousSystem(hcat(0.5), vcat(1.0))
    @test @system(x' = x + u) == LinearControlContinuousSystem(Id(1, 1.0), Id(1, 1.0))
    @test @system(x' = x + 0.1u) == LinearControlContinuousSystem(Id(1, 1.0), hcat(0.1))
    @test @system(x' = x + 0.1 * u) == LinearControlContinuousSystem(Id(1, 1.0), hcat(0.1))
    sys = @system(x' = 0.3x + 0.1u + 0.2, x ∈ X, u ∈ U)
    @test sys == ConstrainedAffineControlContinuousSystem(hcat(0.3), hcat(0.1), vcat(0.2), X, U)
end

@testset "@system for linear descriptor continuous systems" begin
    # lhs needs a *
    @test_throws ArgumentError @system(Ex' = Ax)
    @test@system(E * x' = Ax) == LinearDescriptorContinuousSystem(A, E)

    @test @system(E * x' = A * x) == LinearDescriptorContinuousSystem(A, E)
    @test @system(E * x' = A * x, x ∈ X) == ConstrainedLinearDescriptorContinuousSystem(A, E, X)
end

@testset "@system for affine continuous systems" begin
    b = [1.0]
    @test @system(x' = x + b) == AffineContinuousSystem(Id(1), b)
    @test @system(x' = A * x + c) == AffineContinuousSystem(A, c)
    sys = @system(z_1' = A * z_1 + B * v_1 + c1, z_1 ∈ X, v_1 ∈ U1, input:v_1)
    @test sys == ConstrainedAffineControlContinuousSystem(A, B, c1, X, U1)
    sys = @system(x' = Ax + Bu + c)
    @test sys == AffineControlContinuousSystem(A, B, c)
end

@testset "@system for noisy continuous systems" begin
    sys = @system(x' = f1(x, u, w), x ∈ X, u ∈ U, w ∈ W, dims = (1, 2, 3))
    @test sys == NoisyConstrainedBlackBoxControlContinuousSystem(f1, 1, 2, 3, X, U, W)

    sys = @system(x' = Ax + Bu + Dw, x ∈ X, u ∈ U1, w ∈ W1)
    @test sys == NoisyConstrainedLinearControlContinuousSystem(A, B, D, X, U1, W1)
    sys = @system(z_1' = Az_1 + B * v_1 + c + Dd_1, z_1 ∈ X, v_1 ∈ U1, d_1 ∈ W1, input:v_1,
                  d_1:noise)
    @test sys == NoisyConstrainedAffineControlContinuousSystem(A, B, c, D, X, U1, W1)

    # if variable in front of input or noise  is omitted, add identity matrix
    sys = @system(x' = Ax + u + c + w, x ∈ X, u ∈ U, w ∈ W)
    sys == NoisyConstrainedAffineControlContinuousSystem(A, IdentityMultiple(1.0 * I, n), c,
                                                         IdentityMultiple(1.0 * I, n), X, U, W)
end

@testset "@system for black-box continuous systems" begin
    @test_throws ArgumentError @system(x' = f1(x))
    @test_throws ArgumentError @system(x' = f1(x, u))
    sys = @system(x' = f1(x), dim:3)
    @test sys == BlackBoxContinuousSystem(f1, 3)
    sys = @system(x' = f1(x), x ∈ X, dim:2)
    @test sys == ConstrainedBlackBoxContinuousSystem(f1, 2, X)
    sys = @system(x' = f1(x, u), x ∈ X, u ∈ U, dims = (1, 2))
    @test sys == ConstrainedBlackBoxControlContinuousSystem(f1, 1, 2, X, U)
    # allow for arbitrary input with definition for rhs of the form f_(x_, u_)
    sys = @system(x' = f1(x, u123), x ∈ X, u123 ∈ U, dims = (2, 3))
    @test sys == ConstrainedBlackBoxControlContinuousSystem(f1, 2, 3, X, U)
    # parametric dimension
    n = 3
    sys = @system(x' = f1(x), dim:n)
    @test sys == BlackBoxContinuousSystem(f1, 3)
end

@testset "@system for parametric continuous systems" begin
    @static if isdefined(@__MODULE__, :LazySets)
        AS = rand(MatrixZonotope)
        sys = @system(x' = A * x, A ∈ AS)
        @test sys == LinearParametricContinuousSystem(AS)

        BS = AS
        sys = @system(x' = A * x + B * u, A ∈ AS, B ∈ BS)
        @test sys == LinearControlParametricContinuousSystem(AS, BS)

        sys = @system(x' = A * x + B * u, x ∈ X, u ∈ U, A ∈ AS, B ∈ BS)
        @test sys == ConstrainedLinearControlParametricContinuousSystem(AS, BS, X, U)
    end
end

# ==================
# Discrete systems
# ==================

@testset "@system for discrete identity systems" begin
    @test @system(x⁺ = x, dim = 2) == DiscreteIdentitySystem(2)
    @test @system(x₁⁺ = x₁, dim:2) == DiscreteIdentitySystem(2)

    @test @system(u⁺ = u, dim:3, u ∈ U) == ConstrainedDiscreteIdentitySystem(3, U)
    @test @system(x1⁺ = x1, dim = 3, x1 ∈ X1) == ConstrainedDiscreteIdentitySystem(3, X1)

    # emoji support 😉
    🚈 = X
    sys = @system(👨⁺ = 👨, dim:2, 👨 ∈ 🚈)
    @test sys == ConstrainedDiscreteIdentitySystem(2, X)
end

@testset "@system for linear discrete systems" begin
    @test @system(x⁺ = A * x) == LinearDiscreteSystem(A)
    @test @system(x⁺ = Ax) == LinearDiscreteSystem(A)
    @test @system(z⁺ = A * z) == LinearDiscreteSystem(A)
    @test @system(z⁺ = Az) == LinearDiscreteSystem(A)
    @test_throws ArgumentError @system(z⁺ = Ax)
    @test_throws ArgumentError @system(x⁺ = Az)
    @test @system(x1⁺ = A * x1) == LinearDiscreteSystem(A)
    @test @system(x1⁺ = Ax1) == LinearDiscreteSystem(A)

    @test @system(x⁺ = 2x, dim = 3) == LinearDiscreteSystem(2.0 * IdentityMultiple(I, 3))

    @test @system(x⁺ = A1x, x ∈ X1) == ConstrainedLinearDiscreteSystem(A1, X1)
end

@testset "@system for affine discrete systems" begin
    @test @system(x⁺ = A * x + c) == AffineDiscreteSystem(A, c)
    @test @system(x⁺ = A1 * x + c1) == AffineDiscreteSystem(A1, c1)
end

@testset "@system for linear descriptor discrete systems" begin
    sys = @system(E * x⁺ = Ax)
    @test sys == LinearDescriptorDiscreteSystem(A, E)
    @test sys == @system(E1 * x⁺ = A1 * x)

    sys = @system(E * x⁺ = A * x, x ∈ X)
    @test sys == ConstrainedLinearDescriptorDiscreteSystem(A, E, X)
end

@testset "@system for linear control discrete systems" begin
    sys = @system(x⁺ = A * x + B1 * u)
    @test sys == LinearControlDiscreteSystem(A, B)
    @test sys == @system(x⁺ = A1 * x + Bu)

    @test @system(x⁺ = A1x + B1u) == LinearControlDiscreteSystem(A1, B1)
    @test @system(z_1⁺ = A * z_1 + B * v_1, input:v_1) == LinearControlDiscreteSystem(A, B)

    # u or other symbols are used for inputs; here u is interpreted as input
    sys = @system(x⁺ = Ax + Bu, x ∈ X, u ∈ U1)
    @test sys == ConstrainedLinearControlDiscreteSystem(A, B, X, U1)

    # here v is interpreted as input (if the input has more than one letter, use a *)
    @system(x⁺ = Ax + B * u123, x ∈ X, u123 ∈ U1, input:u123)
    @test sys == ConstrainedLinearControlDiscreteSystem(A, B, X, U1)

    # if variable in front of input is omitted, add identity matrix
    @system(x⁺ = Ax + u) == LinearControlDiscreteSystem(A, IdentityMultiple(1.0 * I, n))

    sys = @system(x⁺ = Ax + Bu123, x ∈ X, u123 ∈ U1, input:u123)
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

    # check error handling for repeated variable names
    @test_throws ArgumentError @system(x⁺ = Ax + Bw + Dw, x ∈ X, w ∈ U1, w ∈ W1, noise = w,
                                       input = w)
end

@testset "@system for black-box discrete systems" begin
    sys = @system(x⁺ = f1(x), dim = 2)
    @test sys == BlackBoxDiscreteSystem(f1, 2)

    sys = @system(x⁺ = f1(x), dim:2, x ∈ X)
    @test sys == ConstrainedBlackBoxDiscreteSystem(f1, 2, X)

    sys = @system(x⁺ = f1(x, u), x ∈ X, u ∈ U, dims = (2, 2))
    @test sys == ConstrainedBlackBoxControlDiscreteSystem(f1, 2, 2, X, U)

    sys = @system(x⁺ = f1(x, u, w), x ∈ X, u ∈ U, w ∈ W, dims = (2, 2, 2))
    @test sys == NoisyConstrainedBlackBoxControlDiscreteSystem(f1, 2, 2, 2, X, U, W)
end

@testset "@system for parametric discrete systems" begin
    @static if isdefined(@__MODULE__, :LazySets)
        AS = rand(MatrixZonotope)
        sys = @system(x⁺ = A * x, A ∈ AS)
        @test sys == LinearParametricDiscreteSystem(AS)

        BS = AS
        sys = @system(x⁺ = A * x + B * u, A ∈ AS, B ∈ BS)
        @test sys == LinearControlParametricDiscreteSystem(AS, BS)

        sys = @system(x⁺ = A * x + B * u, x ∈ X, u ∈ U, A ∈ AS, B ∈ BS)
        @test sys == ConstrainedLinearControlParametricDiscreteSystem(AS, BS, X, U)
    end
end

# =======================
# Initial value problems
# =======================
@testset "@system with for an initial-value problem" begin
    # continuous ivp in floating-point
    ivp = @system(x' = -1.0x, x(0) ∈ Interval(-1, 1))
    @test ivp == IVP(LinearContinuousSystem(Id(1, -1.0)), Interval(-1, 1)) &&
          eltype(ivp.s.A) == Float64

    # discrete ivp in floating-point
    ivp = @system(x⁺ = -x, x(0) ∈ [1])
    @test ivp == IVP(LinearDiscreteSystem(Id(1, -1.0)), [1]) &&
          eltype(ivp.s.A) == Float64

    # initial state assignment doesn't match state variable
    @test_throws ArgumentError @system(x' = -x, t(0) ∈ Interval(-1.0, 1.0))

    # the initial-state constraint can equivalently be given with `=`
    # (singleton case)
    ivp = @system(x' = -1.0x, x(0) = [1.0])
    @test ivp == IVP(LinearContinuousSystem(Id(1, -1.0)), [1.0])

    ivp = @system(x⁺ = -x, x(0) = [1])
    @test ivp == IVP(LinearDiscreteSystem(Id(1, -1.0)), [1])

    # initial state assignment doesn't match state variable (equality form)
    @test_throws ArgumentError @system(x' = -x, t(0) = Interval(-1.0, 1.0))
end
