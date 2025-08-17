@testset "Creation of an identity multiple" begin
    I1 = IdentityMultiple(1.0I, 1)
    @test_throws ArgumentError IdentityMultiple(1.0I, 0)
    @test size(I1) == (1, 1)
    @test I1[1, 1] == 1.0
    @test_throws BoundsError I1[1, 2]
    @test_throws BoundsError I1[3]
    @test_throws ErrorException I1[1] = 2

    for n in [2, 1000]
        In = IdentityMultiple(1.0I, n) # same as IdentityMultiple(UniformScaling(1.0), n))
        @test size(In) == (n, n)
        @test In[1, 1] == 1.0 && In[1, 2] == 0.0
    end

    @test Id(3, 4) == IdentityMultiple(4I, 3)

    @test IdentityMultiple(1.0, 2) == IdentityMultiple(1.0I, 2)

    @test_throws ArgumentError Id(-1)
    @test_throws ArgumentError Id(0, 1)

    # printing
    show(IOBuffer(), MIME"text/plain"(), I1)
end

@testset "Operations between identity multiples" begin
    I2 = IdentityMultiple(UniformScaling(1.0), 2)
    I10 = IdentityMultiple(UniformScaling(1.0), 10)

    @test -I2 == IdentityMultiple(-1.0I, 2)
    @test (I2 + I2).M == UniformScaling(2.0)
    @test (10.0 * I2).M == (I2 * 10.0).M == UniformScaling(10.0)
    @test (I2 * I2).M == I2.M
    @test IdentityMultiple(6.0I, 2) / 3 == IdentityMultiple(2.0I, 2)
    @test (-I2).M == UniformScaling(-1.0)

    @test_throws DimensionMismatch I2 + I10
    @test_throws DimensionMismatch I2 * I10

    s2 = IdentityMultiple(UniformScaling(2.0), 2)
    s3 = UniformScaling(3.0)
    @test s2 * s3 == s3 * s2 == IdentityMultiple(6.0I, 2)
end

@testset "Create a continuous system with one matrix being a multiple of the identity" begin
    # See #40
    A, B = rand(4, 4), rand(4, 2)
    X = rand(Hyperrectangle; dim=4)
    U = rand(Ball2; dim=2)
    I4 = Id(4)
    s = ConstrainedLinearControlContinuousSystem(A, I4, X, B * U)

    @test statedim(s) == 4
    @test stateset(s) == X
end

@testset "Matrix operations for identity multiple" begin
    I2 = Id(2)
    @test getindex(I2, 1) == 1.0
    @test getindex(I2, 2) == 0.0
    @test getindex(I2, 3) == 0.0
    @test getindex(I2, 4) == 1.0
    x = I2 * rand(2)
    @test x isa Vector && length(x) == 2
    A = I2 * rand(2, 2)
    @test A isa Matrix && size(A) == (2, 2)

    @test A * I2 == A
    @test A / I2 == A
    @test I2 / I == I / I2 == IdentityMultiple(1.0, 2)
    @test Id(2) - Id(2) == 0.0Id(2)

    @test Id(2) + [3 3; 1 2] == [4 3; 1 3.0]
    @test [3 3; 1 2] + Id(2) == [4 3; 1 3.0]
end

@testset "Specific methods for IdentityMultiple" begin
    @test Diagonal(Id(2)) == Diagonal([1.0, 1])
    @test Hermitian(Id(2)) == Hermitian([1.0 0; 0 1])
    @test exp(Id(3, 1)) == Id(3, exp(1))
end
