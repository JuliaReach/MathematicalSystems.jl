@testset "Discrete identity system" begin
    for sd in 1:3
        s = DiscreteIdentitySystem(sd)
        @test statedim(s) == sd
        @test inputdim(s) == 0
        @test islinear(s) && isaffine(s)
    end
end

@testset "Discrete constrained identity system" begin
    for sd in 1:3
        X = Singleton(ones(sd))
        s = ConstrainedDiscreteIdentitySystem(sd, X)
        @test statedim(s) == sd
        @test stateset(s) == X
        @test inputdim(s) == 0
        @test islinear(s) && isaffine(s)
    end
end

@testset "Discrete linear system" begin
    for sd in 1:3
        s = LinearDiscreteSystem(zeros(sd, sd))
        @test statedim(s) == sd
        @test inputdim(s) == 0
        @test islinear(s) && isaffine(s)
    end
end

@testset "Discrete linear control system" begin
    for sd in 1:3
        s = LinearControlDiscreteSystem(zeros(sd, sd), ones(sd, sd))
        @test statedim(s) == sd
        @test inputdim(s) == sd
        @test islinear(s) && isaffine(s)
    end
end

@testset "Discrete constrained linear system" begin
    A = [1. 1; 1 -1]
    X = Line([1., -1], 0.) # line x = y
    s = ConstrainedLinearDiscreteSystem(A, X)
    @test statedim(s) == 2
    @test stateset(s) == X
    @test inputdim(s) == 0
    @test islinear(s) && isaffine(s)
end

@testset "Discrete constrained linear control system" begin
    A = [1. 1; 1 -1]
    B = Matrix([0.5 1.5]')
    X = Line([1., -1], 0.)
    U = Interval(0.9, 1.1)
    s = ConstrainedLinearControlDiscreteSystem(A, B, X, U)
    @test statedim(s) == 2
    @test stateset(s) == X
    @test inputdim(s) == 1
    @test inputset(s) == U
    @test islinear(s) && isaffine(s)
end

@testset "Discrete linear algebraic system" begin
    for sd in 1:3
        s = LinearAlgebraicDiscreteSystem(zeros(sd, sd), zeros(sd, sd))
        @test statedim(s) == sd
        @test inputdim(s) == 0
        @test islinear(s) && isaffine(s)
    end
end

@testset "Discrete constrained linear algebraic system" begin
    A = [1. 1; 1 -1]
    E = [0. 1; 1 0]
    X = LinearConstraint([0, -1.], 0.) # the set y ≥ 0
    s = ConstrainedLinearAlgebraicDiscreteSystem(A, E, X)
    @test statedim(s) == 2
    @test stateset(s) == X
    @test inputdim(s) == 0
    @test islinear(s) && isaffine(s)
end

@testset "Constant input in a discrete constrained linear control system" begin
    A = [1. 1; 1 -1]
    B = Matrix([0.5 1.5]')
    X = Line([1., -1], 0.)
    U = ConstantInput(Hyperrectangle(low=[0.9], high=[1.1]))
    s = ConstrainedLinearControlDiscreteSystem(A, B, X, U)
    s = ConstrainedLinearControlDiscreteSystem(A, B, X, U)
    @test islinear(s) && isaffine(s)
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
    @test islinear(s) && isaffine(s)
end

@testset "Polynomial system in discrete time" begin
    @polyvar x y
    p = 2x^2 - 3x + y
    s = PolynomialDiscreteSystem(p)
    @test statedim(s) == 2
    @test inputdim(s) == 0
    @test !islinear(s) && !isaffine(s)
end

@testset "Polynomial system in discrete time with state constraints" begin
    @polyvar x y
    p = 2x^2 - 3x + y
    X = BallInf(zeros(2), 0.1)
    s = ConstrainedPolynomialDiscreteSystem(p, X)
    @test statedim(s) == 2
    @test inputdim(s) == 0
    @test dim(stateset(s)) == dim(X)
    @test !islinear(s) && !isaffine(s)
end

@testset "Implicit discrete system" begin
    add_one(x) = x + 1
    s = BlackBoxDiscreteSystem(add_one, 1)
    x = 1.0
    @test s.f(x) ≈ 2.0
end
