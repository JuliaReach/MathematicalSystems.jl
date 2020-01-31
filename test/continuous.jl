@testset "Continuous identity system" begin
    for sd in 1:3
        s = ContinuousIdentitySystem(sd)
        @test statedim(s) == sd
        @test inputdim(s) == 0
        @test noisedim(s) == 0
        @test islinear(s) && isaffine(s) && !ispolynomial(s)
        @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s)
    end
end

@testset "Continuous constrained identity system" begin
    for sd in 1:3
        X = Singleton(ones(sd))
        s = ConstrainedContinuousIdentitySystem(sd, X)
        @test statedim(s) == sd
        @test inputdim(s) == 0
        @test noisedim(s) == 0
        @test stateset(s) == X
        @test islinear(s) && isaffine(s) && !ispolynomial(s)
        @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s)
    end
end

@testset "Continuous linear system" begin
    for sd in 1:3
        s = LinearContinuousSystem(zeros(sd, sd))
        @test statedim(s) == sd
        @test inputdim(s) == 0
        @test noisedim(s) == 0
        @test islinear(s) && isaffine(s) && !ispolynomial(s)
        @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s)
    end
end

@testset "Continuous affine system" begin
    for sd in 1:3
        s = AffineContinuousSystem(zeros(sd, sd), zeros(sd))
        @test statedim(s) == sd
        @test inputdim(s) == 0
        @test !islinear(s) && isaffine(s) && !ispolynomial(s)
        @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s)
    end
end

@testset "Continuous linear control system" begin
    for sd in 1:3
        s = LinearControlContinuousSystem(zeros(sd, sd), ones(sd, sd))
        @test statedim(s) == sd
        @test inputdim(s) == sd
        @test noisedim(s) == 0
        @test islinear(s) && isaffine(s) && !ispolynomial(s)
        @test !isnoisy(s) && iscontrolled(s) && !isconstrained(s)
    end
end

@testset "Continuous constrained linear system" begin
    A = [1. 1; 1 -1]
    X = Line([1., -1], 0.) # line x = y
    s = ConstrainedLinearContinuousSystem(A, X)
    @test statedim(s) == 2
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test islinear(s) && isaffine(s) && !ispolynomial(s)
    @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s)
end

@testset "Continuous constrained affine system" begin
    A = [1. 1; 1 -1]
    c = [1.; 1.]
    X = Line([1., -1], 0.) # line x = y
    s = ConstrainedAffineContinuousSystem(A, c, X)
    @test statedim(s) == 2
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test !islinear(s) && isaffine(s) && !ispolynomial(s)
    @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s)
end

@testset "Continuous affine control system with state constraints" begin
    A = zeros(2, 2)
    B = Matrix([0.5 1.5]')
    c = [0.0, 1.0]
    X = Line([1., -1], 0.) # line x = y
    U = Interval(-1.0, 1.0)  # -1 <= u <= 1
    s = ConstrainedAffineControlContinuousSystem(A, B, c, X, U)
    @test statedim(s) == 2
    @test inputdim(s) == 1
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test inputset(s) == U
    @test !islinear(s) && isaffine(s) && !ispolynomial(s)
    @test !isnoisy(s) && iscontrolled(s) && isconstrained(s)
end

@testset "Continuous constrained linear control system" begin
    A = [1. 1; 1 -1]
    B = Matrix([0.5 1.5]')
    X = Line([1., -1], 0.)
    U = Interval(0.9, 1.1)
    s = ConstrainedLinearControlContinuousSystem(A, B, X, U)
    @test statedim(s) == 2
    @test inputdim(s) == 1
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test inputset(s) == U
    @test islinear(s) && isaffine(s) && !ispolynomial(s)
    @test !isnoisy(s) && iscontrolled(s) && isconstrained(s)

    # initial value problem composite type
    x0 = Singleton([1.5, 2.0])
    p = InitialValueProblem(s, x0)
    @test inputset(p) == U
    @test statedim(p) == 2
    @test inputdim(p) == 1

    # check that the matrices A and B need not be of the same type
    # with A dense and B a lazy adjoint
    B = [0.5 1.5]'
    s = ConstrainedLinearControlContinuousSystem(A, B, X, U)

    # check that the matrices A and B need not be of the same type
    # with A sparse and B a lazy adjoint
    A = sparse([1], [2], [1.0], 2, 2) # sparse matrix
    s = ConstrainedLinearControlContinuousSystem(A, B, X, U)
end

@testset "Continuous linear algebraic system" begin
    for sd in 1:3
        s = LinearAlgebraicContinuousSystem(zeros(sd, sd), zeros(sd, sd))
        @test statedim(s) == sd
        @test inputdim(s) == 0
        @test noisedim(s) == 0
        @test islinear(s) && isaffine(s) && !ispolynomial(s)
        @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s)
    end
end

@testset "Continuous constrained linear algebraic system" begin
    A = [1. 1; 1 -1]
    E = [0. 1; 1 0]
    X = LinearConstraint([0, -1.], 0.) # the set y ≥ 0
    s = ConstrainedLinearAlgebraicContinuousSystem(A, E, X)
    @test statedim(s) == 2
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test islinear(s) && isaffine(s) && !ispolynomial(s)
    @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s)
end

@testset "Initial value problem for a continuous constrained linear algebraic system" begin
    A = [1. 1; 1 -1]
    E = [0. 1; 1 0]
    X = LinearConstraint([0, -1.], 0.) # the set y ≥ 0
    s = ConstrainedLinearAlgebraicContinuousSystem(A, E, X)
    @test statedim(s) == 2
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test islinear(s) && isaffine(s) && !ispolynomial(s)
    @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s)

    x0 = Singleton([1.5, 2.0])
    p = IVP(s, x0)
    # getter functions
    @test initial_state(p) == x0
end

@testset "Polynomial system in continuous time" begin
    @polyvar x y
    p = 2x^2 - 3x + y

    # default constructor for scalar p and
    s = PolynomialContinuousSystem(p)
    @test statedim(s) == 2
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test !islinear(s) && !isaffine(s) && ispolynomial(s)
    @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s)

    @test TypedPolynomials.nvariables(s) == 2
    @test TypedPolynomials.variables(s) == (x, y)

    # constructor for scalar p and given number of variables
    s = PolynomialContinuousSystem([p], 2)
end

@testset "Polynomial system in continuous time with state constraints" begin
    @polyvar x y
    p = 2x^2 - 3x + y
    X = BallInf(zeros(2), 0.1)

    # default constructor for scalar p and
    s = ConstrainedPolynomialContinuousSystem(p, X)
    @test statedim(s) == 2
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test dim(stateset(s)) == dim(X)
    @test !islinear(s) && !isaffine(s) && ispolynomial(s)
    @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s)

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
    f! = (x, dx) -> s.f(x, dx)
    x = [1.0, 0.0]
    dx = similar(x)
    f!(x, dx)
    @test dx ≈ [0.0, -1.0]
    @test !islinear(s) && !isaffine(s) && !ispolynomial(s)
    @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s)
end

@testset "Continuous system defined by a function with state constraints" begin
    H = HalfSpace([1.0, 0.0], 0.0) # x <= 0
    s = ConstrainedBlackBoxContinuousSystem(vanderpol!, 2, H)
    f! = (x, dx) -> s.f(x, dx)
    x = [1.0, 0.0]
    dx = similar(x)
    f!(x, dx)
    @test dx ≈ [0.0, -1.0]
    @test stateset(s) == H
    @test !islinear(s) && !isaffine(s) && !ispolynomial(s)
    @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s)
end

function vanderpol_controlled!(x, u, dx)
    dx[1] = x[2]
    dx[2] = x[2] * (1-x[1]^2) - x[1] + u[1]
    return dx
end

@testset "Continuous control system defined by a function with state constraints" begin
    H = HalfSpace([1.0, 0.0], 0.0) # x <= 0
    U = Interval(-0.1, 0.1)
    s = ConstrainedBlackBoxControlContinuousSystem(vanderpol_controlled!, 2, 1, H, U)
    f! = (x, u, dx) -> s.f(x, u, dx)
    x = [1.0, 0.0]
    u = an_element(U)
    dx = similar(x)
    f!(x, u, dx)
    @test dx ≈ [0.0, -1.0 + u[1]]
    @test statedim(s) == 2
    @test inputdim(s) == 1
    @test stateset(s) == H
    @test inputset(s) == U
    @test !islinear(s) && !isaffine(s) && !ispolynomial(s)
    @test !isnoisy(s) && iscontrolled(s) && isconstrained(s)
end

# Noisy
@testset "Noisy Continuous constrained linear system" begin
    A = [1. 1; 1 -1]
    D = [1. 2; 0 1]
    X = Line([1., -1], 0.) # line x = y
    W = BallInf(zeros(2), 2.0)
    s = NoisyConstrainedLinearContinuousSystem(A, D, X, W)
    @test s.A == A
    @test s.D == D
    @test statedim(s) == 2
    @test inputdim(s) == 0
    @test noisedim(s) == 2 == dim(W)
    @test stateset(s) == X
    @test noiseset(s) == W
    @test islinear(s) && isaffine(s) && !ispolynomial(s)
    @test isnoisy(s) && !iscontrolled(s) && isconstrained(s)
end

@testset "Noisy Continuous constrained control linear system" begin
    A = [1. 1; 1 -1]
    B = Matrix([0.5 1.5]')
    D = [1. 2; 0 1]
    X = Line([1., -1], 0.) # line x = y
    U = Hyperrectangle(low=[0.9], high=[1.1])
    W = BallInf(zeros(2), 2.0)
    s = NoisyConstrainedLinearControlContinuousSystem(A, B, D, X, U, W)
    @test s.A == A
    @test s.B == B
    @test s.D == D
    @test statedim(s) == 2
    @test inputdim(s) == dim(U)
    @test noisedim(s) == 2 == dim(W)
    @test stateset(s) == X
    @test inputset(s) == U
    @test noiseset(s) == W
    @test islinear(s) && isaffine(s) && !ispolynomial(s)
    @test isnoisy(s) && iscontrolled(s) && isconstrained(s)
end

@testset "Noisy Continuous constrained control affine system" begin
    A = [1. 1; 1 -1]
    B = Matrix([0.5 1.5]')
    c = [1.0, 0.5]
    D = [1. 2; 0 1]
    X = Line([1., -1], 0.) # line x = y
    U = Hyperrectangle(low=[0.9], high=[1.1])
    W = BallInf(zeros(2), 2.0)
    s = NoisyConstrainedAffineControlContinuousSystem(A, B, c, D, X, U, W)
    @test s.A == A
    @test s.B == B
    @test s.c == c
    @test s.D == D
    @test statedim(s) == 2
    @test inputdim(s) == dim(U)
    @test noisedim(s) == 2 == dim(W)
    @test stateset(s) == X
    @test inputset(s) == U
    @test noiseset(s) == W
    @test isaffine(s) && !islinear(s) && !ispolynomial(s)
    @test isnoisy(s) && iscontrolled(s) && isconstrained(s)
end

@testset "Noisy Continuous constrained control blackbox system" begin
    n = 2
    m = 1
    l = 2
    f(x,u,w) = ones(n,n)*x + ones(n,m)*u + ones(n,l)*w
    X = BallInf(zeros(n), 1.0)
    U =  BallInf(zeros(m), 1.0)
    W =  BallInf(zeros(l), 1.0)
    s = NoisyConstrainedBlackBoxControlContinuousSystem(f, n, m, l, X, U, W)
    @test s.f == f
    @test statedim(s) == n
    @test inputdim(s) == dim(U)
    @test noisedim(s) == l == dim(W)
    @test stateset(s) == X
    @test inputset(s) == U
    @test noiseset(s) == W
    @test !islinear(s) && !isaffine(s) && !ispolynomial(s)
    @test isnoisy(s) && iscontrolled(s) && isconstrained(s)
end
