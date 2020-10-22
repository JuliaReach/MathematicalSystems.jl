@testset "vector_field method and `VectorField` for continuous systems" begin
    A = [1. 1; 1 -1]
    B = Matrix([0.5 1.5]')
    c = [0.1; 0.3]
    D = [1. 1 1; 1 -1 1]
    X = Hyperrectangle([0.0, 0.3], [2.0, 2.0])
    U = Interval(0.0, 1.0)
    W = Hyperrectangle([0.0, 0.3, 0.5], [2.0, 2.0, 2.0])
    f(x) = x'*x
    f(x,u) = x'*x + u'*u
    f(x,u,w) = x'*x + u'*u + w'*w
    x = [0.0; 0.3]
    u = [0.5]
    w = [0.5, 1.0, 1.3]

    sys = ContinuousIdentitySystem(size(A, 2))
    @test vector_field(sys, x) == zeros(size(A, 2))
    VF = MathematicalSystems.VectorField(sys)
    @test VF(x) == vector_field(sys, x)

    sys = ConstrainedContinuousIdentitySystem(size(A, 2), X)
    @test vector_field(sys, x) == zeros(size(A, 2))
    VF = MathematicalSystems.VectorField(sys)
    @test VF(x) == vector_field(sys, x)

    sys = LinearContinuousSystem(A)
    @test vector_field(sys, x) == A*x
    VF = MathematicalSystems.VectorField(sys)
    @test VF(x) == vector_field(sys, x)

    sys = AffineContinuousSystem(A, c)
    @test vector_field(sys, x) == A*x + c
    VF = MathematicalSystems.VectorField(sys)
    @test VF(x) == vector_field(sys, x)

    sys = LinearControlContinuousSystem(A, B)
    @test vector_field(sys, x, u) == A*x + B*u
    VF = MathematicalSystems.VectorField(sys)
    @test VF(x, u) == vector_field(sys, x, u)

    sys = ConstrainedLinearContinuousSystem(A, X)
    @test vector_field(sys, x) == A*x
    VF = MathematicalSystems.VectorField(sys)
    @test VF(x) == vector_field(sys, x)

    sys = ConstrainedAffineContinuousSystem(A, c, X)
    @test vector_field(sys, x) == A*x + c
    VF = MathematicalSystems.VectorField(sys)
    @test VF(x) == vector_field(sys, x)

    sys = ConstrainedLinearControlContinuousSystem(A, B, X, U)
    @test vector_field(sys, x, u) == A*x + B*u
    VF = MathematicalSystems.VectorField(sys)
    @test VF(x, u) == vector_field(sys, x, u)

    sys = ConstrainedAffineControlContinuousSystem(A, B, c, X, U)
    @test vector_field(sys, x, u) == A*x + B*u + c
    VF = MathematicalSystems.VectorField(sys)
    @test VF(x, u) == vector_field(sys, x, u)

    sys = BlackBoxContinuousSystem(f, size(A, 2))
    @test vector_field(sys, x) == f(x)
    VF = MathematicalSystems.VectorField(sys)
    @test VF(x) == vector_field(sys, x)

    sys = ConstrainedBlackBoxContinuousSystem(f, size(A, 2), X)
    @test vector_field(sys, x) == f(x)
    VF = MathematicalSystems.VectorField(sys)
    @test VF(x) == vector_field(sys, x)

    sys = ConstrainedBlackBoxControlContinuousSystem(f, size(A, 2), size(B, 2), X, U)
    @test vector_field(sys, x, u) == f(x, u)
    VF = MathematicalSystems.VectorField(sys)
    @test VF(x, u) == vector_field(sys, x, u)

    sys = NoisyConstrainedLinearContinuousSystem(A, D, X, W)
    @test vector_field(sys, x, w) == A*x + D*w
    VF = MathematicalSystems.VectorField(sys)
    @test VF(x, w) == vector_field(sys, x, w)

    sys = NoisyConstrainedLinearControlContinuousSystem(A, B, D, X, U, W)
    @test vector_field(sys, x, u, w) == A*x + B*u + D*w
    VF = MathematicalSystems.VectorField(sys)
    @test VF(x, u, w) == vector_field(sys, x, u, w)

    sys = NoisyConstrainedAffineControlContinuousSystem(A, B, c, D, X, U, W)
    @test vector_field(sys, x, u, w) == A*x + B*u + c + D*w
    VF = MathematicalSystems.VectorField(sys)
    @test VF(x, u, w) == vector_field(sys, x, u, w)

    sys = NoisyConstrainedBlackBoxControlContinuousSystem(f, size(A, 2), size(B, 2), size(D, 2), X, U, W)
    @test vector_field(sys, x, u, w) == f(x, u, w)
    VF = MathematicalSystems.VectorField(sys)
    @test VF(x, u, w) == vector_field(sys, x, u, w)
end

@testset "vector_field exception handling" begin
    A = [1. 1; 1 -1]
    B = Matrix([0.5 1.5]')
    c = [0.1; 0.3]
    D = [1. 1 1; 1 -1 1]
    X = Hyperrectangle([0.0, 0.3], [2.0, 2.0])
    U = Interval(0.0, 1.0)
    W = Hyperrectangle([0.0, 0.3, 0.5], [2.0, 2.0, 2.0])
    f(x) = x'*x
    f(x,u) = x'*x + u'*u
    f(x,u,w) = x'*x + u'*u + w'*w
    x = [0.0; 0.3]
    x_wrong_dim = [0.0]
    x_not_in_set = [-2.1; 0.3]
    u = [0.5]
    u_wrong_dim = [0.5, 0.3]
    u_not_in_set = [-1.0]
    w = [0.5, 1.0, 1.3]
    w_wrong_dim = [0.5, 1.0, 1.3, 1.0]
    w_not_in_set = [-2.1, 1.0, 1.3]

    sys = ContinuousIdentitySystem(size(A,2))
    @test_throws ArgumentError("the state vector has the wrong dimensions") vector_field(sys, x_wrong_dim)
    sys = ConstrainedContinuousIdentitySystem(size(A, 2), X)
    @test_throws ArgumentError("the state vector is not contained in the state set")  vector_field(sys, x_not_in_set)
    sys = LinearContinuousSystem(A)
    @test_throws ArgumentError("the state vector has the wrong dimensions") vector_field(sys, x_wrong_dim)
    sys = AffineContinuousSystem(A, c)
    @test_throws ArgumentError("the state vector has the wrong dimensions") vector_field(sys, x_wrong_dim)
    sys = LinearControlContinuousSystem(A, B)
    @test_throws ArgumentError("the input vector has the wrong dimensions")  vector_field(sys, x, u_wrong_dim)
    sys = ConstrainedLinearContinuousSystem(A, X)
    @test_throws ArgumentError("the state vector is not contained in the state set")  vector_field(sys, x_not_in_set)
    sys = ConstrainedAffineContinuousSystem(A, c, X)
    @test_throws ArgumentError("the state vector is not contained in the state set")  vector_field(sys, x_not_in_set)
    sys = ConstrainedLinearControlContinuousSystem(A, B, X, U)
    @test_throws ArgumentError("the input vector is not contained in the input set")  vector_field(sys, x, u_not_in_set)
    sys = ConstrainedAffineControlContinuousSystem(A, B, c, X, U)
    @test_throws ArgumentError("the input vector has the wrong dimensions")  vector_field(sys, x, u_wrong_dim)
    sys = BlackBoxContinuousSystem(f, size(A, 2))
    @test_throws ArgumentError("the state vector has the wrong dimensions")  vector_field(sys, x_wrong_dim)
    sys = ConstrainedBlackBoxContinuousSystem(f, size(A, 2), X)
    @test_throws ArgumentError("the state vector is not contained in the state set")  vector_field(sys, x_not_in_set)
    sys = ConstrainedBlackBoxControlContinuousSystem(f, size(A, 2), size(B, 2), X, U)
    @test_throws ArgumentError("the input vector is not contained in the input set")  vector_field(sys, x, u_not_in_set)
    sys = NoisyConstrainedLinearContinuousSystem(A, D, X, W)
    @test_throws ArgumentError("the noise vector is not contained in the noise set")  vector_field(sys, x, w_not_in_set)
    sys = NoisyConstrainedLinearControlContinuousSystem(A, B, D, X, U, W)
    @test_throws ArgumentError("the noise vector has the wrong dimensions")  vector_field(sys, x, u, w_wrong_dim)
    sys = NoisyConstrainedAffineControlContinuousSystem(A, B, c, D, X, U, W)
    @test_throws ArgumentError("the noise vector is not contained in the noise set")  vector_field(sys, x, u, w_not_in_set)
    sys = NoisyConstrainedBlackBoxControlContinuousSystem(f, size(A, 2), size(B, 2), size(D, 2), X, U, W)
    @test_throws ArgumentError("the noise vector has the wrong dimensions")  vector_field(sys, x, u, w_wrong_dim)
end
