@testset "@ivp for a continuous system" begin
    P = @ivp(x' = -x, x(0) ∈ Interval(-1.0, 1.0))
    @test P == InitialValueProblem(LinearContinuousSystem(I(-1.0, 1)), Interval(-1, 1))
    # throw error if x(0) is not defined
    @test_throws ArgumentError @ivp(x' = -x)
end
