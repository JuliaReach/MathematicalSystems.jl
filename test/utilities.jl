@testset "Equality of systems" begin
    A = [1. 1; 1 -1]
    c = [1.; 1.]
    X = Line([1., -1], 0.) # line x = y
    s1 = ConstrainedAffineDiscreteSystem(A, c, X)
    s2 = ConstrainedAffineContinuousSystem(A, c, X)

    A = [1.0 1+1e-8; 1 -1]
    c = [1.; 1.]
    X = Line([1., -1], 0.) # line x = y
    s3 = ConstrainedAffineDiscreteSystem(A, c, X)

    @test s1 == s1
    @test s1 != s2
    @test s1 != s3
    @test s1 ≈ s1
    @test s1 ≈ s3
    @test !(s1 ≈ s2)

    x0 = [1.0, 3.0]
    ivp1 = p = InitialValueProblem(s1, x0)
    ivp2 = p = InitialValueProblem(s3, x0)

    @test ivp1 == ivp1
    @test ivp1 != ivp2
    @test ivp1 ≈ ivp1
    @test ivp1 ≈ ivp2
end
