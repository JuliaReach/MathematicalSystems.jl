@testset "Creation of an identity multiple" begin
    I1 = IdentityMultiple(1.0I, 1)
    @test size(I1) == (1, 1)
    @test I1[1, 1] == 1.0
    @test_throws BoundsError I1[1, 2]

    for n in [2, 1000]
        In = IdentityMultiple(1.0I, n) # same as IdentityMultiple(UniformScaling(1.0), n))
        @test size(In) == (n, n)
        @test In[1, 1] == 1.0 && In[1, 2] == 0.0
    end

    @test I(3, 3) == IdentityMultiple(3I, 3)

    @test_throws ArgumentError I(-1)
    @test_throws ArgumentError I(1, 0)
end

@testset "Operations between identity multiples" begin
    I2 = IdentityMultiple(UniformScaling(1.0), 2)
    I10 = IdentityMultiple(UniformScaling(1.0), 10)

    @test (I2 + I2).M == UniformScaling(2.0)
    @test (10.0 * I2).M == UniformScaling(10.0)
    @test (I2 * I2).M == I2.M
    @test (-I2).M == UniformScaling(-1.0)

    @test_throws AssertionError I2 + I10
    @test_throws AssertionError I2 * I10
end

@testset "Create a continuous system with one matrix being a multiple of the identity" begin
    # See #40
    A, B = rand(4, 4), rand(4, 2)
    X = rand(Hyperrectangle, dim=4)
    U = rand(Ball2, dim=2)
    I4 = I(4)
    s = ConstrainedLinearControlContinuousSystem(A, I4, X, B*U);

    @test statedim(s) == 4
    @test stateset(s) == X
end

@testset "Matrix operations for identity multiple" begin
    I2 = I(2)
    @test getindex(I2, 1) == 1.
    @test getindex(I2, 2) == 0.
    @test getindex(I2, 3) == 0.
    @test getindex(I2, 4) == 1.
    x = I2 * rand(2)
    @test x isa Vector && length(x) == 2
    A = I2 * rand(2, 2)
    @test A isa Matrix && size(A) == (2, 2)

    @test I(2) / I == IdentityMultiple(1.0, 2)
    @test I(2) - I(2) == 0.0I(2)

    @test I(2) + [3 3; 1 2] == [4 3; 1 3.]
    @test [3 3; 1 2] + I(2) == [4 3; 1 3.]
end

@testset "Specific methods for IdentityMultiple" begin
    @test Hermitian(I(2)) == Hermitian([1. 0; 0 1])
end
