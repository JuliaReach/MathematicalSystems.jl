@testset "Continuous identity system" begin
    for sd in 1:3
        s = ContinuousIdentitySystem(sd)
        @test statedim(s) == sd
        @test inputdim(s) == 0
    end
end

@testset "Continuous constrained identity system" begin
    for sd in 1:3
        X = Singleton(ones(sd))
        s = ConstrainedContinuousIdentitySystem(sd, X)
        @test statedim(s) == sd
        @test stateset(s) == X
        @test inputdim(s) == 0
    end
end

@testset "Continuous linear system" begin
    for sd in 1:3
        s = LinearContinuousSystem(zeros(sd, sd))
        @test statedim(s) == sd
        @test inputdim(s) == 0
    end
end

@testset "Continuous linear control system" begin
    for sd in 1:3
        s = LinearControlContinuousSystem(zeros(sd, sd), ones(sd, sd))
        @test statedim(s) == sd
        @test inputdim(s) == sd
    end
end

@testset "Continuous constrained linear system" begin
    A = [1. 1; 1 -1]
    X = Line([1., -1], 0.) # line x = y
    s = ConstrainedLinearContinuousSystem(A, X)
    @test statedim(s) == 2
    @test stateset(s) == X
    @test inputdim(s) == 0
end

@testset "Continuous constrained linear control system" begin
    A = [1. 1; 1 -1]
    B = [0.5 1.5]'
    X = Line([1., -1], 0.)
    U = Hyperrectangle(low=[0.9, 0.9], high=[1.1, 1.2])
    s = ConstrainedLinearControlContinuousSystem(A, B, X, U)
    @test statedim(s) == 2
    @test stateset(s) == X
    @test inputdim(s) == 1
    @test inputset(s) == U

    # initial value problem composite type
    x0 = Singleton([1.5, 2.0])
    p = InitialValueProblem(s, x0)
    @test inputset(p) == U
    @test statedim(p) == 2
    @test inputdim(p) == 1
end

@testset "Continuous linear algebraic system" begin
    for sd in 1:3
        s = LinearAlgebraicContinuousSystem(zeros(sd, sd), zeros(sd, sd))
        @test statedim(s) == sd
        @test inputdim(s) == 0
    end
end

@testset "Continuous constrained linear algebraic system" begin
    A = [1. 1; 1 -1]
    E = [0. 1; 1 0]
    X = LinearConstraint([0, -1.], 0.) # the set y ≥ 0
    s = ConstrainedLinearAlgebraicContinuousSystem(A, E, X)
    @test statedim(s) == 2
    @test stateset(s) == X
    @test inputdim(s) == 0
end

@testset "Initial value problem for a continuous constrained linear algebraic system" begin
    A = [1. 1; 1 -1]
    E = [0. 1; 1 0]
    X = LinearConstraint([0, -1.], 0.) # the set y ≥ 0
    s = ConstrainedLinearAlgebraicContinuousSystem(A, E, X)
    x0 = Singleton([1.5, 2.0])
    p = IVP(s, x0)
    @test statedim(p) == 2
    @test inputdim(p) == 0
end
