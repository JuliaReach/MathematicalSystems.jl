@testset "Continuous identity system" begin
    for sd in 1:3
        s = ContinuousIdentitySystem(sd)
        @test statedim(s) == sd
        @test inputdim(s) == 0
        @test noisedim(s) == 0
        for s = [s, typeof(s)]
            @test islinear(s) && isaffine(s) && !ispolynomial(s)
            @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s)
        end
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
        for s = [s, typeof(s)]
            @test islinear(s) && isaffine(s) && !ispolynomial(s)
            @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s)
        end
    end
end

@testset "Continuous linear system" begin
    for sd in 1:3
        s = LinearContinuousSystem(zeros(sd, sd))
        @test statedim(s) == sd
        @test inputdim(s) == 0
        @test noisedim(s) == 0
        for s = [s, typeof(s)]
            @test islinear(s) && isaffine(s) && !ispolynomial(s)
            @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s)
        end
    end
    # Scalar System
    a = 1.
    A = [a][:,:]
    scalar_sys = LinearContinuousSystem(a)
    @test scalar_sys == LinearContinuousSystem(A)
end

@testset "Continuous affine system" begin
    for sd in 1:3
        s = AffineContinuousSystem(zeros(sd, sd), zeros(sd))
        @test statedim(s) == sd
        @test inputdim(s) == 0
        for s = [s, typeof(s)]
            @test !islinear(s) && isaffine(s) && !ispolynomial(s)
            @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s)
        end
    end
    # Scalar System
    a = 1.; c = 0.1
    A = [a][:,:]; C = [c]
    scalar_sys = AffineContinuousSystem(a, c)
    @test scalar_sys == AffineContinuousSystem(A, C)
end

@testset "Continuous linear control system" begin
    for sd in 1:3
        s = LinearControlContinuousSystem(zeros(sd, sd), ones(sd, sd))
        @test statedim(s) == sd
        @test inputdim(s) == sd
        @test noisedim(s) == 0
        for s = [s, typeof(s)]
            @test islinear(s) && isaffine(s) && !ispolynomial(s)
            @test !isnoisy(s) && iscontrolled(s) && !isconstrained(s)
        end
    end
    # Scalar System
    a = 1.; b = 2.
    A = [a][:,:]; B = [b][:,:]
    scalar_sys = LinearControlContinuousSystem(a, b)
    @test scalar_sys == LinearControlContinuousSystem(A, B)
end

@testset "Continuous constrained linear system" begin
    A = [1. 1; 1 -1]
    X = Line([1., -1], 0.) # line x = y
    s = ConstrainedLinearContinuousSystem(A, X)
    @test statedim(s) == 2
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == X
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s)
        @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s)
    end
    # Scalar System
    a = 1.; X = 1
    A = [a][:,:]
    scalar_sys = ConstrainedLinearContinuousSystem(a, X)
    @test scalar_sys == ConstrainedLinearContinuousSystem(A, X)
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
    for s = [s, typeof(s)]
        @test !islinear(s) && isaffine(s) && !ispolynomial(s)
        @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s)
    end
    # Scalar System
    a = 1.; c = 0.1; X = 1
    A = [a][:,:]; C = [c]
    scalar_sys = ConstrainedAffineContinuousSystem(a, c, X)
    @test scalar_sys == ConstrainedAffineContinuousSystem(A, C, X)
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
    for s = [s, typeof(s)]
        @test !islinear(s) && isaffine(s) && !ispolynomial(s)
        @test !isnoisy(s) && iscontrolled(s) && isconstrained(s)
    end
    # Scalar System
    a = 1.; b = 2.; c = 0.1; X = 1; U = 2
    A = [a][:,:]; B = [b][:,:]; C = [c]
    scalar_sys = ConstrainedAffineControlContinuousSystem(a, b, c, X, U)
    @test scalar_sys == ConstrainedAffineControlContinuousSystem(A, B, C, X, U)
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
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s)
        @test !isnoisy(s) && iscontrolled(s) && isconstrained(s)
    end
    # initial value problem composite type
    x0 = Singleton([1.5, 2.0])
    p = InitialValueProblem(s, x0)
    @test initial_state(p) == x0
    @test system(p) == s
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
        for s = [s, typeof(s)]
            @test islinear(s) && isaffine(s) && !ispolynomial(s)
            @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s)
        end
    end
    # Scalar System
    a = 1.; e = 2.
    A = [a][:,:]; E = [e][:,:]
    scalar_sys = LinearAlgebraicContinuousSystem(a, e)
    @test scalar_sys == LinearAlgebraicContinuousSystem(A, E)
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
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s)
        @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s)
    end
    # Scalar System
    a = 1.; e = 2.; X = 1
    A = [a][:,:]; E = [e][:,:]
    scalar_sys = ConstrainedLinearAlgebraicContinuousSystem(a, e, X)
    @test scalar_sys == ConstrainedLinearAlgebraicContinuousSystem(A, E, X)
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
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s)
        @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s)
    end

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
    for s = [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && ispolynomial(s)
        @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s)
    end

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
    for s = [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && ispolynomial(s)
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
    f! = (x, dx) -> s.f(x, dx)
    x = [1.0, 0.0]
    dx = similar(x)
    f!(x, dx)
    @test dx ≈ [0.0, -1.0]
    for s = [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && !ispolynomial(s)
        @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s)
    end
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
    for s = [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && !ispolynomial(s)
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
    s = BlackBoxControlContinuousSystem(add_one, 2, 1)
    @test statedim(s) == 2
    @test inputdim(s) == 1
    for s = [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && !ispolynomial(s)
        @test !isnoisy(s) && iscontrolled(s) && !isconstrained(s)
    end
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
    for s = [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && !ispolynomial(s)
        @test !isnoisy(s) && iscontrolled(s) && isconstrained(s)
    end
end

# ==============
# Noisy systems
# ==============

@testset "Noisy continuous linear system" begin
    A = [1. 1; 1 -1]
    D = [1. 2; 0 1]
    s = NoisyLinearContinuousSystem(A, D)
    @test s.A == A
    @test s.D == D
    @test statedim(s) == 2
    @test inputdim(s) == 0
    @test noisedim(s) == 2
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s)
        @test isnoisy(s) && !iscontrolled(s) && !isconstrained(s)
    end
    # Scalar System
    a = 1.; d = 3.
    A = [a][:,:]; D = [d][:,:]
    scalar_sys = NoisyLinearContinuousSystem(a, d)
    @test scalar_sys == NoisyLinearContinuousSystem(A, D)
end

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
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s)
        @test isnoisy(s) && !iscontrolled(s) && isconstrained(s)
    end
    # Scalar System
    a = 1.; d = 3.; X = 1; W = 3
    A = [a][:,:]; D = [d][:,:]
    scalar_sys = NoisyConstrainedLinearContinuousSystem(a, d, X, W)
    @test scalar_sys == NoisyConstrainedLinearContinuousSystem(A, D, X, W)
end

@testset "Noisy continuous control linear system" begin
    A = [1. 1; 1 -1]
    B = Matrix([0.5 1.5]')
    D = [1. 2; 0 1]
    s = NoisyLinearControlContinuousSystem(A, B, D)
    @test s.A == A
    @test s.B == B
    @test s.D == D
    @test statedim(s) == 2
    @test inputdim(s) == 1
    @test noisedim(s) == 2
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s)
        @test isnoisy(s) && iscontrolled(s) && !isconstrained(s)
    end
    # Scalar System
    a = 1.; b = 2.; d = 3.
    A = [a][:,:]; B = [b][:,:]; D = [d][:,:]
    scalar_sys = NoisyLinearControlContinuousSystem(a, b, d)
    @test scalar_sys == NoisyLinearControlContinuousSystem(A, B, D)
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
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s)
        @test isnoisy(s) && iscontrolled(s) && isconstrained(s)
    end
    # Scalar System
    a = 1.; b = 2.; d = 3.; X = 1; U = 2; W = 3
    A = [a][:,:]; B = [b][:,:]; D = [d][:,:]
    scalar_sys = NoisyConstrainedLinearControlContinuousSystem(a, b, d, X, U, W)
    @test scalar_sys == NoisyConstrainedLinearControlContinuousSystem(A, B, D, X, U, W)
end

@testset "Noisy continuous control affine system" begin
    A = [1. 1; 1 -1]
    B = Matrix([0.5 1.5]')
    c = [1.0, 0.5]
    D = [1. 2; 0 1]
    s = NoisyAffineControlContinuousSystem(A, B, c, D)
    @test s.A == A
    @test s.B == B
    @test s.c == c
    @test s.D == D
    @test statedim(s) == 2
    @test inputdim(s) == 1
    @test noisedim(s) == 2
    for s = [s, typeof(s)]
        @test isaffine(s) && !islinear(s) && !ispolynomial(s)
        @test isnoisy(s) && iscontrolled(s) && !isconstrained(s)
    end
    # Scalar System
    a = 1.; b = 2.; c = 0.1; d = 3.; X = 1; U = 2; W = 3
    A = [a][:,:]; B = [b][:,:]; C = [c]; D = [d][:,:]
    scalar_sys = NoisyAffineControlContinuousSystem(a, b, c, d)
    @test scalar_sys == NoisyAffineControlContinuousSystem(A, B, C, D)
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
    for s = [s, typeof(s)]
        @test isaffine(s) && !islinear(s) && !ispolynomial(s)
        @test isnoisy(s) && iscontrolled(s) && isconstrained(s)
    end
    # Scalar System
    a = 1.; b = 2.; c = 0.1; d = 3.; X = 1; U = 2; W = 3
    A = [a][:,:]; B = [b][:,:]; C = [c]; D = [d][:,:]
    scalar_sys = NoisyConstrainedAffineControlContinuousSystem(a, b, c, d, X, U, W)
    @test scalar_sys == NoisyConstrainedAffineControlContinuousSystem(A, B, C, D, X, U, W)
end

@testset "Noisy continuous control black-box system" begin
    n = 2
    m = 1
    l = 2
    f(x,u,w) = ones(n,n)*x + ones(n,m)*u + ones(n,l)*w
    s = NoisyBlackBoxControlContinuousSystem(f, n, m, l)
    @test s.f == f
    @test statedim(s) == n
    @test inputdim(s) == m
    @test noisedim(s) == l
    for s = [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && !ispolynomial(s)
        @test isnoisy(s) && iscontrolled(s) && !isconstrained(s)
    end
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
    for s = [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && !ispolynomial(s)
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
