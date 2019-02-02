# fix namespace conflicts with LazySets
import MathematicalSystems.LinearMap

@testset "Identity map" begin
    m = IdentityMap(5)
    @test outputdim(m) == 5
    @test islinear(m)
    @test apply(m, ones(2)) == ones(2)
end

@testset "Linear map" begin
    A = [1. 1; 1 -1]
    m = LinearMap(A)
    @test outputdim(m) == 2
    @test islinear(m)

    # applying the linear map on a vector
    @test apply(m, ones(2)) == [2.0, 0.0]

    # applying the linear map on a set
    X = BallInf(zeros(2), 1.0)
    @test apply(m, X) == LazySets.LinearMap(A, X)
end

@testset "Affine map" begin
    A = [1. 1; 1 -1]
    b = [0.5, 0.5]
    m = AffineMap(A, b)
    @test outputdim(m) == 2

    # applying the affine map on a vector
    @test apply(m, ones(2)) == [2.5, 0.5]

    A = [1. 1.]
    b = [0.5]
    m = AffineMap(A, b)
    @test outputdim(m) == 1
    @test islinear(m)
end

@testset "Linear control map" begin
    A = [1. 1; 1 -1]
    B = Matrix([0.5 1.5]')
    m = LinearControlMap(A, B)
    @test outputdim(m) == 2
    @test islinear(m)

    # applying the affine map on a vector
    x = ones(2)
    u = [1/2]
    @test apply(m, x, u) == A * x + B * u
end

@testset "Constrained linear control map" begin
    A = [1. 1; 1 -1]
    B = Matrix([0.5 1.5]')
    U = Interval(-1, 1)
    m = ConstrainedLinearControlMap(A, B, U)
    @test outputdim(m) == 2
    @test islinear(m)

    # applying the affine map on a vector
    x = ones(2)
    u = [1/2]
    @test apply(m, x, u) == A*x + B*u
end

@testset "Affine control map" begin
    A = [1. 1; 1 -1]
    B = Matrix([0.5 1.5]')
    c = [0.5, 0.5]
    m = AffineControlMap(A, B, c)
    @test outputdim(m) == 2
    @test islinear(m)

    # applying the affine map on a vector
    x = ones(2)
    u = [1/2]
    @test apply(m, x, u) == A*x + B*u + c
end

@testset "Constrained affine control map" begin
    A = [1. 1; 1 -1]
    B = Matrix([0.5 1.5]')
    c = [0.5, 0.5]
    U = Interval(-1, 1)
    m = ConstrainedAffineControlMap(A, B, c, U)
    @test outputdim(m) == 2
    @test islinear(m)

    # applying the affine map on a vector
    x = ones(2)
    u = [1/2]
    @test apply(m, x, u) == A * x + B * u  + c
end

@testset "Reset map" begin
    m = ResetMap(10, Dict(9 => 0.))
    @test outputdim(m) == 10

    m = ResetMap(10, 2 => -1., 5 => 1.)
    @test outputdim(m) == 10
    @test islinear(m)

    # applying the affine map on a vector
    x = zeros(10)
    @test apply(m, x) == [0, -1., 0, 0, 1., 0, 0, 0, 0, 0]
end
