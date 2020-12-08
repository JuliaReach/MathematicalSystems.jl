# linear systems
E = [0. 1; 1 0]
A = [1. 1; 1 -1]
B = Matrix([0.5 1.5]')
C = [1.; 1.]
D = [1. 2; 0 1]
X = Line([1., -1], 0.) # line x = y
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
add_one(x) = x .+ 1
add_one(x, u) = x .+ 1 .+ u
add_one(x, u, w) = x .+ 1 .+ u .+ w
state = [1.0; 2.0]
input = 1
noise = [3.0; 1.0]
statePlusOne = add_one(state)
stateInputPlusOne = add_one(state, input)
stateInputNoisePlusOne = add_one(state, input, noise)

# Scalar System
a = 1.; b = 2.; c = 0.1; d = 3.; Xs = 1; Us = 2; Ws = 3; e = 2.;
As = [a][:,:]; Bs = [b][:,:]; Cs = [c]; Ds = [d][:,:]; Es = [e][:,:]



@testset "Continuous identity system" begin
    s = ContinuousIdentitySystem(sd)
    @test state_matrix(s) == I(sd)
    @test input_matrix(s) == nothing
    @test affine_term(s) == nothing
    @test noise_matrix(s) == nothing
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == nothing
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s)
    end
end

@testset "Continuous constrained identity system" begin
    s = ConstrainedContinuousIdentitySystem(sd, X)
    @test state_matrix(s) == I(sd)
    @test input_matrix(s) == nothing
    @test affine_term(s) == nothing
    @test noise_matrix(s) == nothing
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s)
    end
end

@testset "Continuous linear system" begin
    s = LinearContinuousSystem(A)
    @test state_matrix(s) == A
    @test input_matrix(s) == nothing
    @test affine_term(s) == nothing
    @test noise_matrix(s) == nothing
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == nothing
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s)
    end
    # Scalar System
    scalar_sys = LinearContinuousSystem(a)
    @test scalar_sys == LinearContinuousSystem(As)
end

@testset "Continuous affine system" begin
    s = AffineContinuousSystem(A, C)
    @test state_matrix(s) == A
    @test input_matrix(s) == nothing
    @test affine_term(s) == C
    @test noise_matrix(s) == nothing
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == nothing
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test !islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s)
    end
    # Scalar System
    scalar_sys = AffineContinuousSystem(a, c)
    @test scalar_sys == AffineContinuousSystem(As, Cs)
end

@testset "Continuous linear control system" begin
    s = LinearControlContinuousSystem(A, B)
    @test state_matrix(s) == A
    @test input_matrix(s) == B
    @test affine_term(s) == nothing
    @test noise_matrix(s) == nothing
    @test statedim(s) == sd
    @test inputdim(s) == id
    @test noisedim(s) == 0
    @test stateset(s) == nothing
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && iscontrolled(s) && !isconstrained(s)
    end
    # Scalar System
    scalar_sys = LinearControlContinuousSystem(a, b)
    @test scalar_sys == LinearControlContinuousSystem(As, Bs)
end

@testset "Continuous constrained linear system" begin
    s = ConstrainedLinearContinuousSystem(A, X)
    @test state_matrix(s) == A
    @test input_matrix(s) == nothing
    @test affine_term(s) == nothing
    @test noise_matrix(s) == nothing
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s)
    end
    # Scalar System
    scalar_sys = ConstrainedLinearContinuousSystem(a, Xs)
    @test scalar_sys == ConstrainedLinearContinuousSystem(As, Xs)
end

@testset "Continuous constrained affine system" begin
    s = ConstrainedAffineContinuousSystem(A, C, X)
    @test state_matrix(s) == A
    @test input_matrix(s) == nothing
    @test affine_term(s) == C
    @test noise_matrix(s) == nothing
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test !islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s)
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
    @test noise_matrix(s) == nothing
    @test statedim(s) == sd
    @test inputdim(s) == id
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test inputset(s) == U
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test !islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && iscontrolled(s) && isconstrained(s)
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
    for s = [s, typeof(s)]
        @test !islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && iscontrolled(s) && !isconstrained(s)
    end
    # Scalar System
    a = 1.; b = 2.; c = 0.1
    A = [a][:,:]; B = [b][:,:]; C = [c]
    scalar_sys = AffineControlContinuousSystem(a, b, c)
    @test scalar_sys == AffineControlContinuousSystem(A, B, C)
end

@testset "Continuous constrained linear control system" begin
    s = ConstrainedLinearControlContinuousSystem(A, B, X, U)
    @test state_matrix(s) == A
    @test input_matrix(s) == B
    @test affine_term(s) == nothing
    @test noise_matrix(s) == nothing
    @test statedim(s) == sd
    @test inputdim(s) == id
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test inputset(s) == U
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && iscontrolled(s) && isconstrained(s)
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

@testset "Continuous linear algebraic system" begin
    s = LinearAlgebraicContinuousSystem(A, E)
    @test state_matrix(s) == A
    @test input_matrix(s) == nothing
    @test affine_term(s) == nothing
    @test noise_matrix(s) == nothing
    @test s.E == E
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == nothing
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    # Scalar System
    scalar_sys = LinearAlgebraicContinuousSystem(a, e)
    @test scalar_sys == LinearAlgebraicContinuousSystem(As, Es)
end

@testset "Continuous constrained linear algebraic system" begin
    s = ConstrainedLinearAlgebraicContinuousSystem(A, E, X)
    @test state_matrix(s) == A
    @test input_matrix(s) == nothing
    @test affine_term(s) == nothing
    @test noise_matrix(s) == nothing
    @test s.E == E
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s)
    end
    # Scalar System
    scalar_sys = ConstrainedLinearAlgebraicContinuousSystem(a, e, Xs)
    @test scalar_sys == ConstrainedLinearAlgebraicContinuousSystem(As, Es, Xs)

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
    @test state_matrix(s) == nothing
    @test input_matrix(s) == nothing
    @test affine_term(s) == nothing
    @test noise_matrix(s) == nothing
    # @test s.p == p
    @test statedim(s) == sdp
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == nothing
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s)
    end

    @test TypedPolynomials.nvariables(s) == 2
    @test TypedPolynomials.variables(s) == (x, y)

    # constructor for scalar p and given number of variables
    s = PolynomialContinuousSystem([p], 2)
end

@testset "Polynomial system in continuous time with state constraints" begin
    # default constructor for scalar p and
    s = ConstrainedPolynomialContinuousSystem(p, X)
    @test state_matrix(s) == nothing
    @test input_matrix(s) == nothing
    @test affine_term(s) == nothing
    @test noise_matrix(s) == nothing
    # @test s.p == p
    @test statedim(s) == sdp
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s)
    end

    @test TypedPolynomials.nvariables(s) == 2
    @test TypedPolynomials.variables(s) == (x, y)
end

function vanderpol!(x, dx)
    dx[1] = x[2]
    dx[2] = x[2] * (1-x[1]^2) - x[1]
    return dx
end

@testset "Continuous system defined by a function" begin
    s = BlackBoxContinuousSystem(vanderpol!, 2)
    @test state_matrix(s) == nothing
    @test input_matrix(s) == nothing
    @test affine_term(s) == nothing
    @test noise_matrix(s) == nothing
    @test statedim(s) == 2
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == nothing
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    f! = (x, dx) -> s.f(x, dx)
    x = [1.0, 0.0]
    dx = similar(x)
    f!(x, dx)
    @test dx ≈ [0.0, -1.0]

    for s = [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && !ispolynomial(s) && isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s)
    end
end

@testset "Continuous system defined by a function with state constraints" begin
    H = HalfSpace([1.0, 0.0], 0.0) # x <= 0
    s = ConstrainedBlackBoxContinuousSystem(vanderpol!, 2, H)
    @test state_matrix(s) == nothing
    @test input_matrix(s) == nothing
    @test affine_term(s) == nothing
    @test noise_matrix(s) == nothing
    @test statedim(s) == 2
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == H
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    f! = (x, dx) -> s.f(x, dx)
    x = [1.0, 0.0]
    dx = similar(x)
    f!(x, dx)
    @test dx ≈ [0.0, -1.0]
    @test stateset(s) == H
    for s = [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && !ispolynomial(s) && isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s)
    end
end

function vanderpol_controlled!(x, u, dx)
    dx[1] = x[2]
    dx[2] = x[2] * (1-x[1]^2) - x[1] + u[1]
    return dx
end

@testset "Continuous control black-box system" begin
    add_one(x) = x + 1
    s = BlackBoxControlContinuousSystem(vanderpol_controlled!, 2, 1)
    @test state_matrix(s) == nothing
    @test input_matrix(s) == nothing
    @test affine_term(s) == nothing
    @test noise_matrix(s) == nothing
    @test statedim(s) == 2
    @test inputdim(s) == 1
    @test noisedim(s) == 0
    @test stateset(s) == nothing
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && !ispolynomial(s) && isblackbox(s)
        @test !isnoisy(s) && iscontrolled(s) && !isconstrained(s)
    end
end

@testset "Continuous control system defined by a function with state constraints" begin
    H = HalfSpace([1.0, 0.0], 0.0) # x <= 0
    U = Interval(-0.1, 0.1)
    s = ConstrainedBlackBoxControlContinuousSystem(vanderpol_controlled!, 2, 1, H, U)
    @test state_matrix(s) == nothing
    @test input_matrix(s) == nothing
    @test affine_term(s) == nothing
    @test noise_matrix(s) == nothing
    @test statedim(s) == 2
    @test inputdim(s) == 1
    @test noisedim(s) == 0
    @test stateset(s) == H
    @test inputset(s) == U
    @test noiseset(s) == nothing
    f! = (x, u, dx) -> s.f(x, u, dx)
    x = [1.0, 0.0]
    u = an_element(U)
    dx = similar(x)
    f!(x, u, dx)
    @test dx ≈ [0.0, -1.0 + u[1]]
    for s = [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && !ispolynomial(s) && isblackbox(s)
        @test !isnoisy(s) && iscontrolled(s) && isconstrained(s)
    end
end

# ==============
# Noisy systems
# ==============

@testset "Noisy continuous linear system" begin
    s = NoisyLinearContinuousSystem(A, D)
    @test state_matrix(s) == A
    @test input_matrix(s) == nothing
    @test affine_term(s) == nothing
    @test noise_matrix(s) == D
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == nd
    @test stateset(s) == nothing
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test isnoisy(s) && !iscontrolled(s) && !isconstrained(s)
    end
    # Scalar System
    scalar_sys = NoisyLinearContinuousSystem(a, d)
    @test scalar_sys == NoisyLinearContinuousSystem(As, Ds)
end

@testset "Noisy Continuous constrained linear system" begin
    s = NoisyConstrainedLinearContinuousSystem(A, D, X, W)
    @test state_matrix(s) == A
    @test input_matrix(s) == nothing
    @test affine_term(s) == nothing
    @test noise_matrix(s) == D
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == nd
    @test stateset(s) == X
    @test inputset(s) == nothing
    @test noiseset(s) == W
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test isnoisy(s) && !iscontrolled(s) && isconstrained(s)
    end
    # Scalar System
    scalar_sys = NoisyConstrainedLinearContinuousSystem(a, d, Xs, Ws)
    @test scalar_sys == NoisyConstrainedLinearContinuousSystem(As, Ds, Xs, Ws)
end

@testset "Noisy continuous control linear system" begin
    s = NoisyLinearControlContinuousSystem(A, B, D)
    @test state_matrix(s) == A
    @test input_matrix(s) == B
    @test affine_term(s) == nothing
    @test noise_matrix(s) == D
    @test statedim(s) == sd
    @test inputdim(s) == id
    @test noisedim(s) == nd
    @test stateset(s) == nothing
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test isnoisy(s) && iscontrolled(s) && !isconstrained(s)
    end
    # Scalar System
    scalar_sys = NoisyLinearControlContinuousSystem(a, b, d)
    @test scalar_sys == NoisyLinearControlContinuousSystem(As, Bs, Ds)
end

@testset "Noisy Continuous constrained control linear system" begin
    s = NoisyConstrainedLinearControlContinuousSystem(A, B, D, X, U, W)
    @test state_matrix(s) == A
    @test input_matrix(s) == B
    @test affine_term(s) == nothing
    @test noise_matrix(s) == D
    @test statedim(s) == sd
    @test inputdim(s) == id
    @test noisedim(s) == nd
    @test stateset(s) == X
    @test inputset(s) == U
    @test noiseset(s) == W
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test isnoisy(s) && iscontrolled(s) && isconstrained(s)
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
    @test stateset(s) == nothing
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test isaffine(s) && !islinear(s) && !ispolynomial(s) && !isblackbox(s)
        @test isnoisy(s) && iscontrolled(s) && !isconstrained(s)
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
    for s = [s, typeof(s)]
        @test isaffine(s) && !islinear(s) && !ispolynomial(s) && !isblackbox(s)
        @test isnoisy(s) && iscontrolled(s) && isconstrained(s)
    end
    # Scalar System
    scalar_sys = NoisyConstrainedAffineControlContinuousSystem(a, b, c, d, Xs, Us, Ws)
    @test scalar_sys == NoisyConstrainedAffineControlContinuousSystem(As, Bs, Cs, Ds, Xs, Us, Ws)
end

@testset "Noisy continuous control black-box system" begin
    s = NoisyBlackBoxControlContinuousSystem(add_one, sd, id, nd)
    @test state_matrix(s) == nothing
    @test input_matrix(s) == nothing
    @test affine_term(s) == nothing
    @test noise_matrix(s) == nothing
    @test s.f(state, input, noise) ≈ stateInputNoisePlusOne
    @test statedim(s) == sd
    @test inputdim(s) == id
    @test noisedim(s) == nd
    @test stateset(s) == nothing
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && !ispolynomial(s) && isblackbox(s)
        @test isnoisy(s) && iscontrolled(s) && !isconstrained(s)
    end
end

@testset "Noisy Continuous constrained control blackbox system" begin
    s = NoisyConstrainedBlackBoxControlContinuousSystem(add_one, sd, id, nd, X, U, W)
    @test state_matrix(s) == nothing
    @test input_matrix(s) == nothing
    @test affine_term(s) == nothing
    @test noise_matrix(s) == nothing
    @test s.f(state, input, noise) ≈ stateInputNoisePlusOne
    @test statedim(s) == sd
    @test inputdim(s) == id
    @test noisedim(s) == nd
    @test stateset(s) == X
    @test inputset(s) == U
    @test noiseset(s) == W
    for s = [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && !ispolynomial(s) && isblackbox(s)
        @test isnoisy(s) && iscontrolled(s) && isconstrained(s)
    end
end

@testset "Second order systems" begin
    M = [1. 0; 0 2]
    C = [0.1 0; 0 0.2]
    K = [2. 1; 0 1]
    b = [1., 0]
    B = hcat([1., 0])
    d = [1., 0]
    X = BallInf(zeros(2), 1.0)
    U = Singleton(ones(2))

    sys = SecondOrderLinearContinuousSystem(M, C, K)
    @test mass_matrix(sys) == M && viscosity_matrix(sys) == C && stiffness_matrix(sys) == K

    sys = SecondOrderAffineContinuousSystem(M, C, K, b)
    @test mass_matrix(sys) == M && viscosity_matrix(sys) == C && stiffness_matrix(sys) == K
    @test affine_term(sys) == b

    sys = SecondOrderConstrainedLinearControlContinuousSystem(M, C, K, B, X, U)
    @test mass_matrix(sys) == M && viscosity_matrix(sys) == C && stiffness_matrix(sys) == K
    @test input_matrix(sys) == B && stateset(sys) == X && inputset(sys) == U

    sys = SecondOrderConstrainedAffineControlContinuousSystem(M, C, K, B, d, X, U)
    @test mass_matrix(sys) == M && viscosity_matrix(sys) == C && stiffness_matrix(sys) == K
    @test affine_term(sys) == d && input_matrix(sys) == B && stateset(sys) == X && inputset(sys) == U
end
