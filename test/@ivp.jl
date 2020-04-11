@testset "@ivp for a continuous system" begin
    P1 = @ivp(x' = -x, x(0) ∈ Interval(-1.0, 1.0))
    testSystem = InitialValueProblem(LinearContinuousSystem(I(-1.0, 1)), Interval(-1, 1))
    @test P1 == testSystem
    # throw error if x(0) is not defined
    @test_throws ArgumentError @ivp(x' = -x)

    sys = @system(x' = -x)
    P2 = @ivp(sys, x(0) ∈ Interval(-1.0, 1.0))
    @test P2 == testSystem
    P3 = @ivp(@system(x' = -x), x(0) ∈ Interval(-1.0, 1.0))
    @test P3 == testSystem
end
