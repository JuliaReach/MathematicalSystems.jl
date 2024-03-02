@testset "Identity map" begin
    m = IdentityMap(2)
    @test statedim(m) == 2
    @test inputdim(m) == 0
    @test outputdim(m) == 2
    @test islinear(m) && isaffine(m)
    @test apply(m, ones(2)) == ones(2)
end

@testset "Constrained identity map" begin
    X = Line([1.0, -1], 0.0) # line x = y
    m = ConstrainedIdentityMap(2, X)
    @test statedim(m) == 2
    @test inputdim(m) == 0
    @test outputdim(m) == 2
    @test islinear(m) && isaffine(m)
    @test stateset(m) == X
    @test apply(m, ones(2)) == ones(2)
end

@testset "Linear map" begin
    A = [1.0 1; 1 -1]
    m = LinearMap(A)
    @test statedim(m) == 2
    @test inputdim(m) == 0
    @test outputdim(m) == 2
    @test islinear(m) && isaffine(m)

    # applying the linear map on a vector
    @test apply(m, ones(2)) == [2.0, 0.0]

    # applying the linear map on a set
    X = BallInf(zeros(2), 1.0)
    @test apply(m, X) == LazySets.LinearMap(A, X)
end

@testset "Constrained linear map" begin
    A = [1.0 1; 1 -1]
    X = Line([1.0, -1], 0.0) # line x = y
    m = ConstrainedLinearMap(A, X)
    @test statedim(m) == 2
    @test inputdim(m) == 0
    @test outputdim(m) == 2
    @test stateset(m) == X
    @test islinear(m) && isaffine(m)

    # applying the linear map on a vector
    @test apply(m, ones(2)) == [2.0, 0.0]

    # applying the linear map on a set
    X = BallInf(zeros(2), 1.0)
    @test apply(m, X) == LazySets.LinearMap(A, X)
end

@testset "Affine map" begin
    A = [1.0 1; 1 -1]
    b = [0.5, 0.5]
    m = AffineMap(A, b)
    @test statedim(m) == 2
    @test inputdim(m) == 0
    @test outputdim(m) == 2

    # applying the affine map on a vector
    @test apply(m, ones(2)) == [2.5, 0.5]

    A = [1.0 1.0]
    b = [0.5]
    m = AffineMap(A, b)
    @test outputdim(m) == 1
    @test !islinear(m) && isaffine(m)
end

@testset "Constrained affine map" begin
    A = [1.0 1; 1 -1]
    b = [0.5, 0.5]
    X = Line([1.0, -1], 0.0) # line x = y
    m = ConstrainedAffineMap(A, b, X)
    @test statedim(m) == 2
    @test inputdim(m) == 0
    @test outputdim(m) == 2
    @test stateset(m) == X

    # applying the affine map on a vector
    @test apply(m, ones(2)) == [2.5, 0.5]

    A = [1.0 1.0]
    b = [0.5]
    m = ConstrainedAffineMap(A, b, X)
    @test outputdim(m) == 1
    @test !islinear(m) && isaffine(m)
end

@testset "Linear control map" begin
    A = [1.0 1; 1 -1]
    B = Matrix([0.5 1.5]')
    m = LinearControlMap(A, B)
    @test statedim(m) == 2
    @test inputdim(m) == 1
    @test outputdim(m) == 2
    @test islinear(m) && isaffine(m)

    # applying the affine map on a vector
    x = ones(2)
    u = [1 / 2]
    @test apply(m, x, u) == A * x + B * u
end

@testset "Constrained linear control map" begin
    A = [1.0 1; 1 -1]
    B = Matrix([0.5 1.5]')
    X = Line([1.0, -1], 0.0) # line x = y
    U = Interval(-1, 1)
    m = ConstrainedLinearControlMap(A, B, X, U)
    @test statedim(m) == 2
    @test inputdim(m) == 1
    @test outputdim(m) == 2
    @test inputset(m) == U
    @test islinear(m) && isaffine(m)

    # applying the affine map on a vector
    x = ones(2) # (it is not checked that x ∈ X in this library)
    u = [1 / 2]   # same for u ∈ U
    @test stateset(m) == X
    @test apply(m, x, u) == A * x + B * u
end

@testset "Affine control map" begin
    A = [1.0 1; 1 -1]
    B = Matrix([0.5 1.5]')
    c = [0.5, 0.5]
    m = AffineControlMap(A, B, c)
    @test statedim(m) == 2
    @test inputdim(m) == 1
    @test outputdim(m) == 2
    @test !islinear(m) && isaffine(m)

    # applying the affine map on a vector
    x = ones(2)
    u = [1 / 2]
    @test apply(m, x, u) == A * x + B * u + c
end

@testset "Constrained affine control map" begin
    A = [1.0 1; 1 -1]
    B = Matrix([0.5 1.5]')
    X = Line([1.0, -1], 0.0) # line x = y
    c = [0.5, 0.5]
    U = Interval(-1, 1)
    m = ConstrainedAffineControlMap(A, B, c, X, U)
    @test statedim(m) == 2
    @test inputdim(m) == 1
    @test outputdim(m) == 2
    @test stateset(m) == X
    @test inputset(m) == U
    @test !islinear(m) && isaffine(m)

    # applying the affine map on a vector
    x = ones(2)
    u = [1 / 2]
    @test apply(m, x, u) == A * x + B * u + c
end

@testset "Reset map" begin
    m = ResetMap(10, Dict(9 => 0.0))
    @test statedim(m) == 10
    @test inputdim(m) == 0
    @test outputdim(m) == 10
    # alternative constructor from pairs
    @test m.dict == ResetMap(10, 9 => 0.0).dict

    m = ResetMap(10, Dict(2 => -1.0, 5 => 1.0))
    @test outputdim(m) == 10
    @test !islinear(m) && isaffine(m)
    # alternative constructor from pairs
    @test m.dict == ResetMap(10, 2 => -1.0, 5 => 1.0).dict

    # applying the affine map on a vector
    x = zeros(10)
    @test apply(m, x) == [0, -1.0, 0, 0, 1.0, 0, 0, 0, 0, 0]
end

@testset "Constrained reset map" begin
    X = BallInf(zeros(10), 1.0)

    m = ConstrainedResetMap(10, X, Dict(9 => 0.0))
    @test statedim(m) == 10
    @test inputdim(m) == 0
    @test outputdim(m) == 10
    @test stateset(m) == X
    # alternative constructor from pairs
    @test m.dict == ConstrainedResetMap(10, X, 9 => 0.0).dict

    m = ConstrainedResetMap(10, X, Dict(2 => -1.0, 5 => 1.0))
    @test outputdim(m) == 10
    @test stateset(m) == X
    @test !islinear(m) && isaffine(m)
    # alternative constructor from pairs
    @test m.dict == ConstrainedResetMap(10, X, 2 => -1.0, 5 => 1.0).dict

    # applying the affine map on a vector
    x = zeros(10)
    @test apply(m, x) == [0, -1.0, 0, 0, 1.0, 0, 0, 0, 0, 0]
end

@testset "Black-box map" begin
    h(x) = [x[1] * x[2], x[2] * x[3]]

    m = BlackBoxMap(3, 2, h)
    @test statedim(m) == 3
    @test inputdim(m) == 0
    @test outputdim(m) == 2
    @test !islinear(m)
    @test !isaffine(m)
    @test apply(m, [2, 3, 4]) == [6, 12]
end

@testset "Constrained black-box map" begin
    h(x) = [x[1] * x[2], x[2] * x[3]]
    X = BallInf(zeros(3), 1.0)

    m = ConstrainedBlackBoxMap(3, 2, h, X)
    @test statedim(m) == 3
    @test inputdim(m) == 0
    @test outputdim(m) == 2
    @test !islinear(m)
    @test !isaffine(m)
    @test apply(m, [2, 3, 4]) == [6, 12]
    @test stateset(m) == X
end

@testset "Black-box control map" begin
    h(x, u) = [x[1] * x[2] + u, x[2] * x[3]]

    m = BlackBoxControlMap(3, 1, 2, h)
    @test statedim(m) == 3
    @test inputdim(m) == 1
    @test outputdim(m) == 2
    @test !islinear(m)
    @test !isaffine(m)
    @test apply(m, [2, 3, 4], 4) == [10, 12]
end

@testset "Constrained black-box control map" begin
    h(x, u) = [x[1] * x[2] + u, x[2] * x[3]]
    X = BallInf(zeros(3), 1.0)
    U = Interval(0, 5)

    m = ConstrainedBlackBoxControlMap(3, 1, 2, h, X, U)
    @test statedim(m) == 3
    @test inputdim(m) == 1
    @test outputdim(m) == 2
    @test !islinear(m)
    @test !isaffine(m)
    @test apply(m, [2, 3, 4], 4) == [10, 12]
    @test stateset(m) == X
    @test inputset(m) == U
end
