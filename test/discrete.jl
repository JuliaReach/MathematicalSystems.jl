@testset "Discrete identity system" begin
    for sd in 1:3
        s = DiscreteIdentitySystem(sd)
        @test statedim(s) == sd
        @test inputdim(s) == 0
        @test noisedim(s) == 0
        for s = [s, typeof(s)]
            @test islinear(s) && isaffine(s) && !ispolynomial(s)
            @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s)
        end
    end
end

@testset "Discrete constrained identity system" begin
    for sd in 1:3
        X = Singleton(ones(sd))
        s = ConstrainedDiscreteIdentitySystem(sd, X)
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

@testset "Discrete linear system" begin
    for sd in 1:3
        s = LinearDiscreteSystem(zeros(sd, sd))
        @test statedim(s) == sd
        @test inputdim(s) == 0
        @test noisedim(s) == 0
        for s = [s, typeof(s)]
            @test islinear(s) && isaffine(s) && !ispolynomial(s)
            @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s)
        end
    end
end

@testset "Discrete affine system" begin
    for sd in 1:3
        s = AffineDiscreteSystem(zeros(sd, sd), zeros(sd))
        @test statedim(s) == sd
        @test inputdim(s) == 0
        @test noisedim(s) == 0
        for s = [s, typeof(s)]
            @test !islinear(s) && isaffine(s) && !ispolynomial(s)
            @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s)
        end
    end
end

@testset "Discrete linear control system" begin
    for sd in 1:3
        s = LinearControlDiscreteSystem(zeros(sd, sd), ones(sd, sd))
        @test statedim(s) == sd
        @test inputdim(s) == sd
        @test noisedim(s) == 0
        for s = [s, typeof(s)]
            @test islinear(s) && isaffine(s) && !ispolynomial(s)
            @test !isnoisy(s) && iscontrolled(s) && !isconstrained(s)
        end
    end
end

@testset "Discrete constrained linear system" begin
    A = [1. 1; 1 -1]
    X = Line([1., -1], 0.) # line x = y
    s = ConstrainedLinearDiscreteSystem(A, X)
    @test statedim(s) == 2
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == X
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s)
        @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s)
    end
end

@testset "Discrete constrained affine system" begin
    A = [1. 1; 1 -1]
    c = [1.; 1.]
    X = Line([1., -1], 0.) # line x = y
    s = ConstrainedAffineDiscreteSystem(A, c, X)
    @test statedim(s) == 2
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == X
    for s = [s, typeof(s)]
        @test !islinear(s) && isaffine(s) && !ispolynomial(s)
        @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s)
    end
end

@testset "Discrete constrained linear control system" begin
    A = [1. 1; 1 -1]
    B = Matrix([0.5 1.5]')
    X = Line([1., -1], 0.)
    U = Interval(0.9, 1.1)
    s = ConstrainedLinearControlDiscreteSystem(A, B, X, U)
    @test statedim(s) == 2
    @test inputdim(s) == 1
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test inputset(s) == U
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s)
        @test !isnoisy(s) && iscontrolled(s) && isconstrained(s)
    end
end

@testset "Discrete linear algebraic system" begin
    for sd in 1:3
        s = LinearAlgebraicDiscreteSystem(zeros(sd, sd), zeros(sd, sd))
        @test statedim(s) == sd
        @test inputdim(s) == 0
        @test noisedim(s) == 0
        for s = [s, typeof(s)]
            @test islinear(s) && isaffine(s) && !ispolynomial(s)
            @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s)
        end
    end
end

@testset "Discrete constrained linear algebraic system" begin
    A = [1. 1; 1 -1]
    E = [0. 1; 1 0]
    X = LinearConstraint([0, -1.], 0.) # the set y ≥ 0
    s = ConstrainedLinearAlgebraicDiscreteSystem(A, E, X)
    @test statedim(s) == 2
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == X
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s)
        @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s)
    end
end

@testset "Polynomial system in discrete time" begin
    @polyvar x y
    p = 2x^2 - 3x + y
    s = PolynomialDiscreteSystem(p)
    @test statedim(s) == 2
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    for s = [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && ispolynomial(s)
        @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s)
    end
end

@testset "Polynomial system in discrete time with state constraints" begin
    @polyvar x y
    p = 2x^2 - 3x + y
    X = BallInf(zeros(2), 0.1)
    s = ConstrainedPolynomialDiscreteSystem(p, X)
    @test statedim(s) == 2
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test dim(stateset(s)) == dim(X)
    for s = [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && ispolynomial(s)
        @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s)
    end
end

@testset "Implicit discrete system" begin
    add_one(x) = x + 1
    s = BlackBoxDiscreteSystem(add_one, 1)
    x = 1.0
    @test s.f(x) ≈ 2.0
    for s = [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && !ispolynomial(s)
        @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s)
    end
end

@testset "Noisy Discrete constrained linear system" begin
    A = [1. 1; 1 -1]
    D = [1. 2; 0 1]
    X = Line([1., -1], 0.) # line x = y
    W = BallInf(zeros(2), 2.0)
    s = NoisyConstrainedLinearDiscreteSystem(A, D, X, W)
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
end

@testset "Noisy Discrete constrained control linear system" begin
    A = [1. 1; 1 -1]
    B = Matrix([0.5 1.5]')
    D = [1. 2; 0 1]
    X = Line([1., -1], 0.) # line x = y
    U = Hyperrectangle(low=[0.9], high=[1.1])
    W = BallInf(zeros(2), 2.0)
    s = NoisyConstrainedLinearControlDiscreteSystem(A, B, D, X, U, W)
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
end

@testset "Noisy Discrete constrained control affine system" begin
    A = [1. 1; 1 -1]
    B = Matrix([0.5 1.5]')
    c = [1.0, 0.5]
    D = [1. 2; 0 1]
    X = Line([1., -1], 0.) # line x = y
    U = Hyperrectangle(low=[0.9], high=[1.1])
    W = BallInf(zeros(2), 2.0)
    s = NoisyConstrainedAffineControlDiscreteSystem(A, B, c, D, X, U, W)
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
end

@testset "Noisy Discrete constrained control blackbox system" begin
    n = 2
    m = 1
    l = 2
    f(x,u,w) = ones(n,n)*x + ones(n,m)*u + ones(n,l)*w
    X = BallInf(zeros(n), 1.0)
    U =  BallInf(zeros(m), 1.0)
    W =  BallInf(zeros(l), 1.0)
    s = NoisyConstrainedBlackBoxControlDiscreteSystem(f, n, m, l, X, U, W)
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


@testset "Constant input in a discrete constrained linear control system" begin
    A = [1. 1; 1 -1]
    B = Matrix([0.5 1.5]')
    X = Line([1., -1], 0.)
    U = ConstantInput(Hyperrectangle(low=[0.9], high=[1.1]))
    s = ConstrainedLinearControlDiscreteSystem(A, B, X, U)
    s = ConstrainedLinearControlDiscreteSystem(A, B, X, U)
    if VERSION < v"0.7-"
        @test next(s.U, 1)[1] isa Hyperrectangle
    else
        @test iterate(s.U)[1] isa Hyperrectangle
    end
end


@testset "Varying input in a discrete constrained linear control system" begin
    A = [1. 1; 1 -1]
    B = Matrix([0.5 1.5]')
    X = Line([1., -1], 0.)
    U = VaryingInput([Hyperrectangle(low=[0.9], high=[1.1]),
                      Hyperrectangle(low=[0.99], high=[1.0])])
    s = ConstrainedLinearControlDiscreteSystem(A, B, X, U)
    @test length(s.U) == 2
    for ui in s.U
        @test ui isa Hyperrectangle
    end
end
