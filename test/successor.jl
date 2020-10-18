@testset "successor method for discrete systems" begin
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

    sys = DiscreteIdentitySystem(size(A, 2))
    @test successor(sys, x) == x
    sys = ConstrainedDiscreteIdentitySystem(size(A, 2), X)
    @test successor(sys, x) == x
    sys = LinearDiscreteSystem(A)
    @test successor(sys, x) == A*x
    sys = AffineDiscreteSystem(A, c)
    @test successor(sys, x) == A*x + c
    sys = LinearControlDiscreteSystem(A, B)
    @test successor(sys, x, u) == A*x + B*u
    sys = ConstrainedLinearDiscreteSystem(A, X)
    @test successor(sys, x) == A*x
    sys = ConstrainedAffineDiscreteSystem(A, c, X)
    @test successor(sys, x) == A*x + c
    sys = ConstrainedLinearControlDiscreteSystem(A, B, X, U)
    @test successor(sys, x, u) == A*x + B*u
    sys = ConstrainedAffineControlDiscreteSystem(A, B, c, X, U)
    @test successor(sys, x, u) == A*x + B*u + c
    sys = BlackBoxDiscreteSystem(f, size(A, 2))
    @test successor(sys, x) == f(x)
    sys = ConstrainedBlackBoxDiscreteSystem(f, size(A, 2), X)
    @test successor(sys, x) == f(x)
    sys = ConstrainedBlackBoxControlDiscreteSystem(f, size(A, 2), size(B, 2), X, U)
    @test successor(sys, x, u) == f(x, u)
    sys = NoisyConstrainedLinearDiscreteSystem(A, D, X, W)
    @test successor(sys, x, w) == A*x + D*w
    sys = NoisyConstrainedLinearControlDiscreteSystem(A, B, D, X, U, W)
    @test successor(sys, x, u, w) == A*x + B*u + D*w
    sys = NoisyConstrainedAffineControlDiscreteSystem(A, B, c, D, X, U, W)
    @test successor(sys, x, u, w) == A*x + B*u + c + D*w
    sys = NoisyConstrainedBlackBoxControlDiscreteSystem(f, size(A, 2), size(B, 2), size(D, 2), X, U, W)
    @test successor(sys, x, u, w) == f(x, u, w)
end

@testset "successor exception handling" begin
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

    sys = DiscreteIdentitySystem(size(A,2))
    @test_throws ArgumentError("the state vector has the wrong dimensions") successor(sys, x_wrong_dim)
    sys = ConstrainedDiscreteIdentitySystem(size(A, 2), X)
    @test_throws ArgumentError("the state vector is not contained in the state set")  successor(sys, x_not_in_set)
    sys = LinearDiscreteSystem(A)
    @test_throws ArgumentError("the state vector has the wrong dimensions") successor(sys, x_wrong_dim)
    sys = AffineDiscreteSystem(A, c)
    @test_throws ArgumentError("the state vector has the wrong dimensions") successor(sys, x_wrong_dim)
    sys = LinearControlDiscreteSystem(A, B)
    @test_throws ArgumentError("the input vector has the wrong dimensions")  successor(sys, x, u_wrong_dim)
    sys = ConstrainedLinearDiscreteSystem(A, X)
    @test_throws ArgumentError("the state vector is not contained in the state set")  successor(sys, x_not_in_set)
    sys = ConstrainedAffineDiscreteSystem(A, c, X)
    @test_throws ArgumentError("the state vector is not contained in the state set")  successor(sys, x_not_in_set)
    sys = ConstrainedLinearControlDiscreteSystem(A, B, X, U)
    @test_throws ArgumentError("the input vector is not contained in the input set")  successor(sys, x, u_not_in_set)
    sys = ConstrainedAffineControlDiscreteSystem(A, B, c, X, U)
    @test_throws ArgumentError("the input vector has the wrong dimensions")  successor(sys, x, u_wrong_dim)
    sys = BlackBoxDiscreteSystem(f, size(A, 2))
    @test_throws ArgumentError("the state vector has the wrong dimensions")  successor(sys, x_wrong_dim)
    sys = ConstrainedBlackBoxDiscreteSystem(f, size(A, 2), X)
    @test_throws ArgumentError("the state vector is not contained in the state set")  successor(sys, x_not_in_set)
    sys = ConstrainedBlackBoxControlDiscreteSystem(f, size(A, 2), size(B, 2), X, U)
    @test_throws ArgumentError("the input vector is not contained in the input set")  successor(sys, x, u_not_in_set)
    sys = NoisyConstrainedLinearDiscreteSystem(A, D, X, W)
    @test_throws ArgumentError("the noise vector is not contained in the noise set")  successor(sys, x, w_not_in_set)
    sys = NoisyConstrainedLinearControlDiscreteSystem(A, B, D, X, U, W)
    @test_throws ArgumentError("the noise vector has the wrong dimensions")  successor(sys, x, u, w_wrong_dim)
    sys = NoisyConstrainedAffineControlDiscreteSystem(A, B, c, D, X, U, W)
    @test_throws ArgumentError("the noise vector is not contained in the noise set")  successor(sys, x, u, w_not_in_set)
    sys = NoisyConstrainedBlackBoxControlDiscreteSystem(f, size(A, 2), size(B, 2), size(D, 2), X, U, W)
    @test_throws ArgumentError("the noise vector has the wrong dimensions")  successor(sys, x, u, w_wrong_dim)
end
