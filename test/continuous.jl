using MathematicalSystems: mapping

# linear systems
E = [0.0 1; 1 0]
A = [1.0 1; 1 -1]
B = Matrix([0.5 1.5]')
C = [1.0; 1.0]
D = [1.0 2; 0 1]
X = Line([1.0, -1], 0.0) # line x = y
U = Interval(0.9, 1.1)
W = BallInf(zeros(2), 2.0)
sd = 2
id = 1
nd = 2

# polynomial system
@polyvar x y
p = 2x^2 - 3x + y
sdp = 2

# blackbox system
state = [1.0; 2.0]
input = 1
noise = [3.0; 1.0]
statePlusOne = add_one(state)
stateInputPlusOne = add_one(state, input)
stateInputNoisePlusOne = add_one(state, input, noise)

# Scalar System
a = 1.0;
b = 2.0;
c = 0.1;
d = 3.0;
Xs = 1;
Us = 2;
Ws = 3;
e = 2.0;
As = [a][:, :];
Bs = [b][:, :];
Cs = [c];
Ds = [d][:, :];
Es = [e][:, :];

@testset "Continuous identity system" begin
    s = ContinuousIdentitySystem(sd)
    @test state_matrix(s) == Id(sd)
    @test isnothing(input_matrix(s))
    @test isnothing(affine_term(s))
    @test isnothing(noise_matrix(s))
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test isnothing(stateset(s))
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    for s in [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s) && !isparametric(s)
    end
end

@testset "Continuous constrained identity system" begin
    s = ConstrainedContinuousIdentitySystem(sd, X)
    @test state_matrix(s) == Id(sd)
    @test isnothing(input_matrix(s))
    @test isnothing(affine_term(s))
    @test isnothing(noise_matrix(s))
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    for s in [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s) && !isparametric(s)
    end
end

@testset "Continuous linear system" begin
    s = LinearContinuousSystem(A)
    @test state_matrix(s) == A
    @test isnothing(input_matrix(s))
    @test isnothing(affine_term(s))
    @test isnothing(noise_matrix(s))
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test isnothing(stateset(s))
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    for s in [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s) && !isparametric(s)
    end
    # Scalar System
    scalar_sys = LinearContinuousSystem(a)
    @test scalar_sys == LinearContinuousSystem(As)
end

@testset "Continuous affine system" begin
    s = AffineContinuousSystem(A, C)
    @test state_matrix(s) == A
    @test isnothing(input_matrix(s))
    @test affine_term(s) == C
    @test isnothing(noise_matrix(s))
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test isnothing(stateset(s))
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    for s in [s, typeof(s)]
        @test !islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s) && !isparametric(s)
    end
    # Scalar System
    scalar_sys = AffineContinuousSystem(a, c)
    @test scalar_sys == AffineContinuousSystem(As, Cs)
end

@testset "Continuous linear control system" begin
    s = LinearControlContinuousSystem(A, B)
    @test state_matrix(s) == A
    @test input_matrix(s) == B
    @test isnothing(affine_term(s))
    @test isnothing(noise_matrix(s))
    @test statedim(s) == sd
    @test inputdim(s) == id
    @test noisedim(s) == 0
    @test isnothing(stateset(s))
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    for s in [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && iscontrolled(s) && !isconstrained(s) && !isparametric(s)
    end
    # Scalar System
    scalar_sys = LinearControlContinuousSystem(a, b)
    @test scalar_sys == LinearControlContinuousSystem(As, Bs)
end

@testset "Continuous constrained linear system" begin
    s = ConstrainedLinearContinuousSystem(A, X)
    @test state_matrix(s) == A
    @test isnothing(input_matrix(s))
    @test isnothing(affine_term(s))
    @test isnothing(noise_matrix(s))
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    for s in [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s) && !isparametric(s)
    end
    # Scalar System
    scalar_sys = ConstrainedLinearContinuousSystem(a, Xs)
    @test scalar_sys == ConstrainedLinearContinuousSystem(As, Xs)
end

@testset "Continuous constrained affine system" begin
    s = ConstrainedAffineContinuousSystem(A, C, X)
    @test state_matrix(s) == A
    @test isnothing(input_matrix(s))
    @test affine_term(s) == C
    @test isnothing(noise_matrix(s))
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    for s in [s, typeof(s)]
        @test !islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s) && !isparametric(s)
    end
    # Scalar System
    scalar_sys = ConstrainedAffineContinuousSystem(a, c, Xs)
    @test scalar_sys == ConstrainedAffineContinuousSystem(As, Cs, Xs)
end

@testset "Continuous affine control system with state constraints" begin
    s = ConstrainedAffineControlContinuousSystem(A, B, C, X, U)
    @test state_matrix(s) == A
    @test input_matrix(s) == B
    @test affine_term(s) == C
    @test isnothing(noise_matrix(s))
    @test statedim(s) == sd
    @test inputdim(s) == id
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test inputset(s) == U
    @test isnothing(noiseset(s))
    for s in [s, typeof(s)]
        @test !islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && iscontrolled(s) && isconstrained(s) && !isparametric(s)
    end
    # Scalar System
    scalar_sys = ConstrainedAffineControlContinuousSystem(a, b, c, Xs, Us)
    @test scalar_sys == ConstrainedAffineControlContinuousSystem(As, Bs, Cs, Xs, Us)
end

@testset "Continuous affine control system with state constraints" begin
    A = zeros(2, 2)
    B = Matrix([0.5 1.5]')
    c = [0.0, 1.0]
    s = AffineControlContinuousSystem(A, B, c)
    @test statedim(s) == 2
    @test inputdim(s) == 1
    @test noisedim(s) == 0
    @test state_matrix(s) == A
    @test input_matrix(s) == B
    @test affine_term(s) == c
    for s in [s, typeof(s)]
        @test !islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && iscontrolled(s) && !isconstrained(s) && !isparametric(s)
    end
    # Scalar System
    a = 1.0
    b = 2.0
    c = 0.1
    A = [a][:, :]
    B = [b][:, :]
    C = [c]
    scalar_sys = AffineControlContinuousSystem(a, b, c)
    @test scalar_sys == AffineControlContinuousSystem(A, B, C)
end

@testset "Continuous constrained linear control system" begin
    s = ConstrainedLinearControlContinuousSystem(A, B, X, U)
    @test state_matrix(s) == A
    @test input_matrix(s) == B
    @test isnothing(affine_term(s))
    @test isnothing(noise_matrix(s))
    @test statedim(s) == sd
    @test inputdim(s) == id
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test inputset(s) == U
    @test isnothing(noiseset(s))
    for s in [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && iscontrolled(s) && isconstrained(s) && !isparametric(s)
    end

    @testset "initial value problem composite type" begin
        x0 = Singleton([1.5, 2.0])
        ivp = InitialValueProblem(s, x0)
        @test initial_state(ivp) == x0
        @test system(ivp) == s
        @test inputset(ivp) == U
        @test statedim(ivp) == 2
        @test inputdim(ivp) == 1
    end

    # check that the matrices A and B need not be of the same type
    # with A dense and B a lazy adjoint
    B_adjoint = [0.5 1.5]'
    s = ConstrainedLinearControlContinuousSystem(A, B_adjoint, X, U)

    # check that the matrices A and B need not be of the same type
    # with A sparse and B a lazy adjoint
    A_sparse = sparse([1], [2], [1.0], 2, 2) # sparse matrix
    s = ConstrainedLinearControlContinuousSystem(A_sparse, B, X, U)
end

@testset "Continuous linear descriptor system" begin
    s = LinearDescriptorContinuousSystem(A, E)
    @test state_matrix(s) == A
    @test isnothing(input_matrix(s))
    @test isnothing(affine_term(s))
    @test isnothing(noise_matrix(s))
    @test s.E == E
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test isnothing(stateset(s))
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    # Scalar System
    scalar_sys = LinearDescriptorContinuousSystem(a, e)
    @test scalar_sys == LinearDescriptorContinuousSystem(As, Es)
end

@testset "Continuous constrained linear descriptor system" begin
    s = ConstrainedLinearDescriptorContinuousSystem(A, E, X)
    @test state_matrix(s) == A
    @test isnothing(input_matrix(s))
    @test isnothing(affine_term(s))
    @test isnothing(noise_matrix(s))
    @test s.E == E
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    for s in [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s) && !isparametric(s)
    end
    # Scalar System
    scalar_sys = ConstrainedLinearDescriptorContinuousSystem(a, e, Xs)
    @test scalar_sys == ConstrainedLinearDescriptorContinuousSystem(As, Es, Xs)

    @testset "Initial value problem" begin
        x0 = Singleton([1.5, 2.0])
        ivp = IVP(s, x0)
        # getter functions
        @test initial_state(ivp) == x0
    end
end

@testset "Polynomial system in continuous time" begin
    # default constructor for scalar p and
    s = PolynomialContinuousSystem(p)
    @test isnothing(state_matrix(s))
    @test isnothing(input_matrix(s))
    @test isnothing(affine_term(s))
    @test isnothing(noise_matrix(s))
    @test statedim(s) == sdp
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test isnothing(stateset(s))
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    @test mapping(s) == [p]
    for s in [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s) && !isparametric(s)
    end

    @test TypedPolynomials.nvariables(s) == 2
    @test TypedPolynomials.variables(s) == (x, y)

    # constructor for scalar p and given number of variables
    s = PolynomialContinuousSystem([p], 2)
end

@testset "Polynomial system in continuous time with state constraints" begin
    # default constructor for scalar p and
    s = ConstrainedPolynomialContinuousSystem(p, X)
    @test isnothing(state_matrix(s))
    @test isnothing(input_matrix(s))
    @test isnothing(affine_term(s))
    @test isnothing(noise_matrix(s))
    # @test s.p == p
    @test statedim(s) == sdp
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    @test mapping(s) == [p]
    for s in [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s) && !isparametric(s)
    end

    @test TypedPolynomials.nvariables(s) == 2
    @test TypedPolynomials.variables(s) == (x, y)
end

function vanderpol!(x, dx)
    dx[1] = x[2]
    dx[2] = x[2] * (1 - x[1]^2) - x[1]
    return dx
end

@testset "Continuous system defined by a function" begin
    s = BlackBoxContinuousSystem(vanderpol!, 2)
    @test isnothing(state_matrix(s))
    @test isnothing(input_matrix(s))
    @test isnothing(affine_term(s))
    @test isnothing(noise_matrix(s))
    @test statedim(s) == 2
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test isnothing(stateset(s))
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    f! = (x, dx) -> s.f(x, dx)
    x = [1.0, 0.0]
    dx = similar(x)
    f!(x, dx)
    @test dx ≈ [0.0, -1.0]

    for s in [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && !ispolynomial(s) && isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s) && !isparametric(s)
    end
end

@testset "Continuous system defined by a function with state constraints" begin
    H = HalfSpace([1.0, 0.0], 0.0) # x <= 0
    s = ConstrainedBlackBoxContinuousSystem(vanderpol!, 2, H)
    @test isnothing(state_matrix(s))
    @test isnothing(input_matrix(s))
    @test isnothing(affine_term(s))
    @test isnothing(noise_matrix(s))
    @test statedim(s) == 2
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == H
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    f! = (x, dx) -> s.f(x, dx)
    x = [1.0, 0.0]
    dx = similar(x)
    f!(x, dx)
    @test dx ≈ [0.0, -1.0]
    @test stateset(s) == H
    for s in [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && !ispolynomial(s) && isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s) && !isparametric(s)
    end
end

function vanderpol_controlled!(x, u, dx)
    dx[1] = x[2]
    dx[2] = x[2] * (1 - x[1]^2) - x[1] + u[1]
    return dx
end

@testset "Continuous control black-box system" begin
    add_one(x) = x + 1
    s = BlackBoxControlContinuousSystem(vanderpol_controlled!, 2, 1)
    @test isnothing(state_matrix(s))
    @test isnothing(input_matrix(s))
    @test isnothing(affine_term(s))
    @test isnothing(noise_matrix(s))
    @test statedim(s) == 2
    @test inputdim(s) == 1
    @test noisedim(s) == 0
    @test isnothing(stateset(s))
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    @test mapping(s) == vanderpol_controlled!
    for s in [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && !ispolynomial(s) && isblackbox(s)
        @test !isnoisy(s) && iscontrolled(s) && !isconstrained(s) && !isparametric(s)
    end
end

@testset "Continuous control system defined by a function with state constraints" begin
    H = HalfSpace([1.0, 0.0], 0.0) # x <= 0
    U = Interval(-0.1, 0.1)
    s = ConstrainedBlackBoxControlContinuousSystem(vanderpol_controlled!, 2, 1, H, U)
    @test isnothing(state_matrix(s))
    @test isnothing(input_matrix(s))
    @test isnothing(affine_term(s))
    @test isnothing(noise_matrix(s))
    @test statedim(s) == 2
    @test inputdim(s) == 1
    @test noisedim(s) == 0
    @test stateset(s) == H
    @test inputset(s) == U
    @test isnothing(noiseset(s))
    f! = (x, u, dx) -> s.f(x, u, dx)
    x = [1.0, 0.0]
    u = an_element(U)
    dx = similar(x)
    f!(x, u, dx)
    @test dx ≈ [0.0, -1.0 + u[1]]
    for s in [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && !ispolynomial(s) && isblackbox(s)
        @test !isnoisy(s) && iscontrolled(s) && isconstrained(s) && !isparametric(s)
    end
end

# ==============
# Noisy systems
# ==============

@testset "Noisy continuous linear system" begin
    s = NoisyLinearContinuousSystem(A, D)
    @test state_matrix(s) == A
    @test isnothing(input_matrix(s))
    @test isnothing(affine_term(s))
    @test noise_matrix(s) == D
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == nd
    @test isnothing(stateset(s))
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    for s in [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test isnoisy(s) && !iscontrolled(s) && !isconstrained(s) && !isparametric(s)
    end
    # Scalar System
    scalar_sys = NoisyLinearContinuousSystem(a, d)
    @test scalar_sys == NoisyLinearContinuousSystem(As, Ds)
end

@testset "Noisy Continuous constrained linear system" begin
    s = NoisyConstrainedLinearContinuousSystem(A, D, X, W)
    @test state_matrix(s) == A
    @test isnothing(input_matrix(s))
    @test isnothing(affine_term(s))
    @test noise_matrix(s) == D
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == nd
    @test stateset(s) == X
    @test isnothing(inputset(s))
    @test noiseset(s) == W
    for s in [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test isnoisy(s) && !iscontrolled(s) && isconstrained(s) && !isparametric(s)
    end
    # Scalar System
    scalar_sys = NoisyConstrainedLinearContinuousSystem(a, d, Xs, Ws)
    @test scalar_sys == NoisyConstrainedLinearContinuousSystem(As, Ds, Xs, Ws)
end

@testset "Noisy continuous control linear system" begin
    s = NoisyLinearControlContinuousSystem(A, B, D)
    @test state_matrix(s) == A
    @test input_matrix(s) == B
    @test isnothing(affine_term(s))
    @test noise_matrix(s) == D
    @test statedim(s) == sd
    @test inputdim(s) == id
    @test noisedim(s) == nd
    @test isnothing(stateset(s))
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    for s in [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test isnoisy(s) && iscontrolled(s) && !isconstrained(s) && !isparametric(s)
    end
    # Scalar System
    scalar_sys = NoisyLinearControlContinuousSystem(a, b, d)
    @test scalar_sys == NoisyLinearControlContinuousSystem(As, Bs, Ds)
end

@testset "Noisy Continuous constrained control linear system" begin
    s = NoisyConstrainedLinearControlContinuousSystem(A, B, D, X, U, W)
    @test state_matrix(s) == A
    @test input_matrix(s) == B
    @test isnothing(affine_term(s))
    @test noise_matrix(s) == D
    @test statedim(s) == sd
    @test inputdim(s) == id
    @test noisedim(s) == nd
    @test stateset(s) == X
    @test inputset(s) == U
    @test noiseset(s) == W
    for s in [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test isnoisy(s) && iscontrolled(s) && isconstrained(s) && !isparametric(s)
    end
    # Scalar System
    scalar_sys = NoisyConstrainedLinearControlContinuousSystem(a, b, d, Xs, Us, Ws)
    @test scalar_sys == NoisyConstrainedLinearControlContinuousSystem(As, Bs, Ds, Xs, Us, Ws)
end

@testset "Noisy continuous control affine system" begin
    s = NoisyAffineControlContinuousSystem(A, B, C, D)
    @test state_matrix(s) == A
    @test input_matrix(s) == B
    @test affine_term(s) == C
    @test noise_matrix(s) == D
    @test statedim(s) == sd
    @test inputdim(s) == id
    @test noisedim(s) == nd
    @test isnothing(stateset(s))
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    for s in [s, typeof(s)]
        @test isaffine(s) && !islinear(s) && !ispolynomial(s) && !isblackbox(s)
        @test isnoisy(s) && iscontrolled(s) && !isconstrained(s) && !isparametric(s)
    end
    # Scalar System
    scalar_sys = NoisyAffineControlContinuousSystem(a, b, c, d)
    @test scalar_sys == NoisyAffineControlContinuousSystem(As, Bs, Cs, Ds)
end

@testset "Noisy Continuous constrained control affine system" begin
    s = NoisyConstrainedAffineControlContinuousSystem(A, B, C, D, X, U, W)
    @test state_matrix(s) == A
    @test input_matrix(s) == B
    @test affine_term(s) == C
    @test noise_matrix(s) == D
    @test statedim(s) == sd
    @test inputdim(s) == id
    @test noisedim(s) == nd
    @test stateset(s) == X
    @test inputset(s) == U
    @test noiseset(s) == W
    for s in [s, typeof(s)]
        @test isaffine(s) && !islinear(s) && !ispolynomial(s) && !isblackbox(s)
        @test isnoisy(s) && iscontrolled(s) && isconstrained(s) && !isparametric(s)
    end
    # Scalar System
    scalar_sys = NoisyConstrainedAffineControlContinuousSystem(a, b, c, d, Xs, Us, Ws)
    @test scalar_sys == NoisyConstrainedAffineControlContinuousSystem(As, Bs, Cs, Ds, Xs, Us, Ws)
end

@testset "Noisy continuous control black-box system" begin
    s = NoisyBlackBoxControlContinuousSystem(add_one, sd, id, nd)
    @test isnothing(state_matrix(s))
    @test isnothing(input_matrix(s))
    @test isnothing(affine_term(s))
    @test isnothing(noise_matrix(s))
    @test s.f(state, input, noise) ≈ stateInputNoisePlusOne
    @test statedim(s) == sd
    @test inputdim(s) == id
    @test noisedim(s) == nd
    @test isnothing(stateset(s))
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    @test mapping(s) == add_one
    for s in [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && !ispolynomial(s) && isblackbox(s)
        @test isnoisy(s) && iscontrolled(s) && !isconstrained(s) && !isparametric(s)
    end
end

@testset "Noisy continuous constrained control blackbox system" begin
    s = NoisyConstrainedBlackBoxControlContinuousSystem(add_one, sd, id, nd, X, U, W)
    @test isnothing(state_matrix(s))
    @test isnothing(input_matrix(s))
    @test isnothing(affine_term(s))
    @test isnothing(noise_matrix(s))
    @test s.f(state, input, noise) ≈ stateInputNoisePlusOne
    @test statedim(s) == sd
    @test inputdim(s) == id
    @test noisedim(s) == nd
    @test stateset(s) == X
    @test inputset(s) == U
    @test noiseset(s) == W
    for s in [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && !ispolynomial(s) && isblackbox(s)
        @test isnoisy(s) && iscontrolled(s) && isconstrained(s) && !isparametric(s)
    end
end

@testset "Second-order linear and affine systems" begin
    M = [1.0 0; 0 2]
    C = [0.1 0; 0 0.2]
    K = [2.0 1; 0 1]
    b = [1.0, 0]
    B = hcat([1.0, 0])
    d = [1.0, 0]
    X = BallInf(zeros(2), 1.0)
    U = Singleton(ones(2))
    X1 = BallInf(zeros(1), 1.0)
    U1 = Singleton(ones(1))

    s = SecondOrderLinearContinuousSystem(M, C, K)
    @test mass_matrix(s) == M && viscosity_matrix(s) == C && stiffness_matrix(s) == K
    @test statedim(s) == 2
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test affine_term(s) == zeros(2)
    @test islinear(s)
    @test isaffine(s)
    @test !ispolynomial(s)
    @test !isnoisy(s)
    @test !iscontrolled(s)
    @test !isconstrained(s)
    @test !isparametric(s)

    s = SecondOrderLinearContinuousSystem(2, 3, 4)
    @test mass_matrix(s) == hcat(2)
    @test viscosity_matrix(s) == hcat(3)
    @test stiffness_matrix(s) == hcat(4)

    s = SecondOrderAffineContinuousSystem(M, C, K, b)
    @test mass_matrix(s) == M && viscosity_matrix(s) == C && stiffness_matrix(s) == K
    @test statedim(s) == 2
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test affine_term(s) == b
    @test islinear(s)
    @test isaffine(s)
    @test !ispolynomial(s)
    @test !isnoisy(s)
    @test !iscontrolled(s)
    @test !isconstrained(s)
    @test !isparametric(s)

    s = SecondOrderAffineContinuousSystem(2, 3, 4, 6)
    @test mass_matrix(s) == hcat(2)
    @test viscosity_matrix(s) == hcat(3)
    @test stiffness_matrix(s) == hcat(4)
    @test affine_term(s) == [6]

    s = SecondOrderConstrainedLinearControlContinuousSystem(M, C, K, B, X, U)
    @test mass_matrix(s) == M && viscosity_matrix(s) == C && stiffness_matrix(s) == K
    @test input_matrix(s) == B && stateset(s) == X && inputset(s) == U
    @test statedim(s) == 2
    @test inputdim(s) == 1
    @test noisedim(s) == 0
    @test affine_term(s) == zeros(2)
    @test islinear(s)
    @test isaffine(s)
    @test !ispolynomial(s)
    @test !isnoisy(s)
    @test iscontrolled(s)
    @test isconstrained(s)
    @test !isparametric(s)

    s = SecondOrderConstrainedLinearControlContinuousSystem(2, 3, 4, 5, X1, U1)
    @test mass_matrix(s) == hcat(2)
    @test viscosity_matrix(s) == hcat(3)
    @test stiffness_matrix(s) == hcat(4)
    @test stateset(s) == X1
    @test inputset(s) == U1

    s = SecondOrderConstrainedAffineControlContinuousSystem(M, C, K, B, d, X, U)
    @test mass_matrix(s) == M && viscosity_matrix(s) == C && stiffness_matrix(s) == K
    @test affine_term(s) == d && input_matrix(s) == B && stateset(s) == X &&
          inputset(s) == U
    @test statedim(s) == 2
    @test inputdim(s) == 1
    @test noisedim(s) == 0
    @test affine_term(s) == d
    @test islinear(s)
    @test isaffine(s)
    @test !ispolynomial(s)
    @test !isnoisy(s)
    @test iscontrolled(s)
    @test isconstrained(s)
    @test !isparametric(s)

    s = SecondOrderConstrainedAffineControlContinuousSystem(2, 3, 4, 5, 6, X1, U1)
    @test mass_matrix(s) == hcat(2)
    @test viscosity_matrix(s) == hcat(3)
    @test stiffness_matrix(s) == hcat(4)
    @test affine_term(s) == [6]
    @test stateset(s) == X1
    @test inputset(s) == U1
end

@testset "Second-order polynomial systems" begin
    M = [1.0 0; 0 2]
    C = [0.1 0; 0 0.2]
    fi(x) = x + x .^ 2 + ones(2)
    fe = zeros(2)
    s = SecondOrderContinuousSystem(M, C, fi, fe)
    @test mass_matrix(s) == M && viscosity_matrix(s) == C
    @test statedim(s) == 2
    @test isnothing(inputdim(s))
    @test noisedim(s) == 0
    @test isnothing(affine_term(s))
    @test !islinear(s)
    @test !isaffine(s)
    @test !ispolynomial(s)
    @test !isnoisy(s)
    @test !iscontrolled(s)
    @test !isconstrained(s)
    @test !isparametric(s)

    s = SecondOrderContinuousSystem(2, 3, fi, fe)
    @test mass_matrix(s) == hcat(2)
    @test viscosity_matrix(s) == hcat(3)
    @test s.fi == fi && s.fe == fe

    fe = zeros(2)
    X = Universe(2)
    U = Universe(2)
    s = SecondOrderConstrainedContinuousSystem(M, C, fi, fe, X, U)
    @test mass_matrix(s) == M && viscosity_matrix(s) == C
    @test stateset(s) === X && inputset(s) === U
    @test statedim(s) == 2
    @test isnothing(inputdim(s))
    @test noisedim(s) == 0
    @test isnothing(affine_term(s))
    @test !islinear(s)
    @test !isaffine(s)
    @test !ispolynomial(s)
    @test !isnoisy(s)
    @test !iscontrolled(s)
    @test isconstrained(s)
    @test !isparametric(s)

    s = SecondOrderConstrainedContinuousSystem(2, 3, fi, fe, X, U)
    @test mass_matrix(s) == hcat(2)
    @test viscosity_matrix(s) == hcat(3)
    @test stateset(s) === X && inputset(s) === U
    @test s.fi == fi && s.fe == fe
end

# ==================
# Parametric systems
# ==================

@testset "Linear parametric continuous systems" begin
    @static if isdefined(@__MODULE__, :LazySets)
        using LazySets: MatrixZonotope

        Ac = [1.0 0.0; 0.0 1.0]
        A1 = [0.1 0.0; 0.0 0.0]
        A2 = [0.0 0.0; 0.0 0.2]
        A = MatrixZonotope(Ac, [A1, A2])

        s = LinearParametricContinuousSystem(A)
        @test s isa LinearParametricContinuousSystem

        # shortcut constructor
        s = LinearContinuousSystem(A)
        @test s isa LinearParametricContinuousSystem

        @test statedim(s) == 2
        @test inputdim(s) == 0
        @test noisedim(s) == 0
        @test state_matrix(s) === A
        @test islinear(s)
        @test isparametric(s)
        @test isaffine(s)
        @test !isnoisy(s)
        @test !iscontrolled(s)
        @test !isconstrained(s)

        # control case
        Bc = hcat([1.0; 0.5])
        B1 = hcat([0.05; 0.0])
        B = MatrixZonotope(Bc, [B1])

        sc = LinearControlParametricContinuousSystem(A, B)
        @test sc isa LinearControlParametricContinuousSystem
        # shortcut constructor for control
        sc = LinearControlContinuousSystem(A, B)
        @test sc isa LinearControlParametricContinuousSystem

        @test statedim(sc) == 2
        @test inputdim(sc) == 1
        @test noisedim(sc) == 0
        @test state_matrix(sc) === A
        @test input_matrix(sc) === B
        @test islinear(sc)
        @test isparametric(sc)
        @test isaffine(sc)
        @test iscontrolled(sc)
        @test !isnoisy(sc)
        @test !isconstrained(sc)
    end
end
