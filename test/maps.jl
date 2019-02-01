# fix namespace conflicts with LazySets
import MathematicalSystems.LinearMap

@testset "Identity map" begin
    m = IdentityMap(5)
    @test outputdim(m) == 5
end

@testset "Linear map" begin
    A = [1. 1; 1 -1]
    m = LinearMap(A)
    @test outputdim(m) == 2
end

@testset "Affine map" begin
    A = [1. 1; 1 -1]
    b = [0.5, 0.5]
    m = AffineMap(A, b)
    @test outputdim(m) == 2

    A = [1. 1.]
    b = [0.5]
    m = AffineMap(A, b)
    @test outputdim(m) == 1
end

@testset "Linear control map" begin
    A = [1. 1; 1 -1]
    B = Matrix([0.5 1.5]')
    m = LinearControlMap(A, B)
    @test outputdim(m) == 2
end

@testset "Constrained linear control map" begin
    A = [1. 1; 1 -1]
    B = Matrix([0.5 1.5]')
    U = Interval(-1, 1)
    m = ConstrainedLinearControlMap(A, B, U)
    @test outputdim(m) == 2
end

@testset "Affine control map" begin
    A = [1. 1; 1 -1]
    B = Matrix([0.5 1.5]')
    c = [0.5, 0.5]
    m = AffineControlMap(A, B, c)
    @test outputdim(m) == 2
end

@testset "Constrained affine control map" begin
    A = [1. 1; 1 -1]
    B = Matrix([0.5 1.5]')
    c = [0.5, 0.5]
    U = Interval(-1, 1)
    m = ConstrainedAffineControlMap(A, B, c, U)
    @test outputdim(m) == 2
end
