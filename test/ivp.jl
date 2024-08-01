@testset "IVP interface" begin
    E = [0.0 1; 1 0]
    A = [1.0 1; 1 -1]
    B = Matrix([0.5 1.5]')
    c = [2.0, 3]
    D = [1.0 2; 0 1]
    X = Line([1.0, -1], 0.0) # line x = y
    U = Interval(0.9, 1.1)
    W = BallInf(zeros(2), 2.0)
    S = NoisyConstrainedAffineControlContinuousSystem(A, B, c, D, X, U, W)
    X0 = Ball2(zeros(2), 2.0)
    P = InitialValueProblem(S, X0)
    @test statedim(P) == 2
    @test stateset(P) == X
    @test inputdim(P) == 1
    @test inputset(P) == U
    @test noisedim(P) == 2
    @test noiseset(P) == W
    @test state_matrix(P) == A
    @test input_matrix(P) == B
    @test noise_matrix(P) == D
    @test !islinear(P)
    @test isaffine(P)
    @test !ispolynomial(P)
    @test !isblackbox(P)
    @test isnoisy(P)
    @test iscontrolled(P)
    @test isconstrained(P)
    @test affine_term(P) == c

    f() = 1
    P = BlackBoxDiscreteSystem(f, 1)
    @test mapping(P) == f
end
