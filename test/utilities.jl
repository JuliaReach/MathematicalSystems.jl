@testset "Equality of systems" begin
    A = [1.0 1; 1 -1]
    A2 = [1.0 1+1e-8; 1 -1]
    c = [1.0; 1.0]
    X = Line([1.0, -1], 0.0) # line x = y
    Y = Singleton([0.0, 0.0])
    s1 = ConstrainedAffineDiscreteSystem(A, c, X)
    s2 = ConstrainedAffineContinuousSystem(A, c, X)
    s3 = ConstrainedAffineDiscreteSystem(A2, c, X)
    s4 = ConstrainedAffineDiscreteSystem(A, c, Y)
    s5 = ConstrainedAffineDiscreteSystem(Int.(A), Int.(c), X)

    @test s1 == s1
    @test s1 != s2
    @test s1 != s3
    @test s1 != s4
    @test s1 == s5
    @test s1 ≈ s1
    @test !(s1 ≈ s2)
    @test s1 ≈ s3
    @test !(s1 ≈ s4)
    @test s1 ≈ s5

    x0 = [1.0, 3.0]
    ivp1 = InitialValueProblem(s1, x0)
    ivp2 = InitialValueProblem(s2, x0)
    ivp3 = InitialValueProblem(s3, x0)
    ivp4 = InitialValueProblem(s4, x0)
    ivp5 = InitialValueProblem(s5, x0)

    @test ivp1 == ivp1
    @test ivp1 != ivp2
    @test ivp1 != ivp3
    @test ivp1 != ivp4
    @test ivp1 == ivp5
    @test ivp1 ≈ ivp1
    @test !(ivp1 ≈ ivp2)
    @test ivp1 ≈ ivp3
    @test !(ivp1 ≈ ivp4)
    @test ivp1 ≈ ivp5
end
