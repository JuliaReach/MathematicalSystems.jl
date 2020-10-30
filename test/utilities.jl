@testset "Equality of systems" begin
    A = [1. 1; 1 -1]
    A2 = [1.0 1+1e-8; 1 -1]
    c = [1.; 1.]
    X = Line([1., -1], 0.) # line x = y
    Y = Singleton([0., 0.])
    s1 = ConstrainedAffineDiscreteSystem(A, c, X)
    s2 = ConstrainedAffineContinuousSystem(A, c, X)
    s3 = ConstrainedAffineDiscreteSystem(A2, c, X)
    s4 = ConstrainedAffineDiscreteSystem(A, c, Y)

    @test s1 == s1
    @test s1 != s2
    @test s1 != s3
    @test s1 != s4
    @test s1 ≈ s1
    @test !(s1 ≈ s2)
    @test s1 ≈ s3
    @test !(s1 ≈ s4)

    x0 = [1.0, 3.0]
    ivp1 = InitialValueProblem(s1, x0)
    ivp2 = InitialValueProblem(s2, x0)
    ivp3 = InitialValueProblem(s3, x0)
    ivp4 = InitialValueProblem(s4, x0)

    @test ivp1 == ivp1
    @test ivp1 != ivp2
    @test ivp1 != ivp3
    @test ivp1 != ivp4
    @test ivp1 ≈ ivp1
    @test !(ivp1 ≈ ivp2)
    @test ivp1 ≈ ivp3
    @test !(ivp1 ≈ ivp4)
end

@testset "Promote Arrays element type" begin
    A = [1, 2, 3]
    B = [1.0, 2.0, 3.0]
    C = [1.0 + 0*im, 2.0 + 0*im, 3 + 0*im]
    A_prom, B_prom = promote_array(A, B)
    @test eltype(A_prom) == eltype(A_prom)
    A_prom, B_prom, C_prom = promote_array(A, B, C)
    @test eltype(A_prom) == eltype(A_prom) == eltype(C_prom)

    M1 = [1 2; 3 4]
    M2 = [1.0, 2]
    M1_prom, M2_prom = promote_array(M1, M2)
    @test eltype(M1_prom) == eltype(M2_prom)
end
