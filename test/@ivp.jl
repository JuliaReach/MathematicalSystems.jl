@testset "@ivp for a continuous system" begin
    P1 = @ivp(x' = -x, x(0) ∈ Interval(-1.0, 1.0))
    testSystem = InitialValueProblem(LinearContinuousSystem(Id(1, -1.0)), Interval(-1, 1))
    @test P1 == testSystem
    # throw error if x(0) is not defined
    @test_throws ArgumentError @ivp(x' = -x)

    sys = @system(x' = -x)
    P2 = @ivp(sys, x(0) ∈ Interval(-1.0, 1.0))
    @test P2 == testSystem
    P3 = @ivp(@system(x' = -x), x(0) ∈ Interval(-1.0, 1.0))
    @test P3 == testSystem
end

@testset "@ivp for constrained parametric control systems" begin
    @static if isdefined(@__MODULE__, :LazySets)
        AS = rand(MatrixZonotope)
        BS = rand(MatrixZonotope)
        U = BallInf(zeros(1), 1.0)
        X0 = Interval(-1.0, 1.0)

        P = @ivp(x' = A * x + B * u, x(0) ∈ X0, u ∈ U, A ∈ AS, B ∈ BS)
        @test P == InitialValueProblem(ConstrainedLinearControlParametricContinuousSystem(AS, BS,
                                                                                           U),
                                       X0)
        @test inputset(system(P)) == U
    end
end

