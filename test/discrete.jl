# linear systems
E = [0. 1; 1 0]
A = [1. 1; 1 -1]
B = Matrix([0.5 1.5]')
C = [1.; 1.]
D = [1. 2; 0 1]
X = Line([1., -1], 0.) # line x = y
U = Interval(0.9, 1.1)
W = BallInf(zeros(2), 2.0)
sd = 2
id = 1
nd = 2

# polynomial system
@polyvar x y
p = 2x^2 - 3x + y
sdp = 2

# blackbox system
add_one(x) = x .+ 1
add_one(x, u) = x .+ 1 .+ u
add_one(x, u, w) = x .+ 1 .+ u .+ w
state = [1.0; 2.0]
input = 1
noise = [3.0; 1.0]
statePlusOne = add_one(state)
stateInputPlusOne = add_one(state, input)
stateInputNoisePlusOne = add_one(state, input, noise)

# Scalar System
a = 1.; b = 2.; c = 0.1; d = 3.; Xs = 1; Us = 2; Ws = 3; e = 2.;
As = [a][:,:]; Bs = [b][:,:]; Cs = [c]; Ds = [d][:,:]; Es = [e][:,:]

@testset "Discrete identity system" begin
    s = DiscreteIdentitySystem(sd)
    @test state_matrix(s) == I(sd)
    @test input_matrix(s) == nothing
    @test affine_term(s) == nothing
    @test noise_matrix(s) == nothing
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == nothing
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s)
    end
end

@testset "Discrete constrained identity system" begin
    s = ConstrainedDiscreteIdentitySystem(sd, X)
    @test state_matrix(s) == I(sd)
    @test input_matrix(s) == nothing
    @test affine_term(s) == nothing
    @test noise_matrix(s) == nothing
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s)
    end
end

@testset "Discrete linear system" begin
    s = LinearDiscreteSystem(A)
    @test state_matrix(s) == A
    @test input_matrix(s) == nothing
    @test affine_term(s) == nothing
    @test noise_matrix(s) == nothing
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == nothing
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s)
    end
    # Scalar System
    scalar_sys = LinearDiscreteSystem(a)
    @test scalar_sys == LinearDiscreteSystem(As)
end

@testset "Discrete affine system" begin
    s = AffineDiscreteSystem(A, C)
    @test state_matrix(s) == A
    @test input_matrix(s) == nothing
    @test affine_term(s) == C
    @test noise_matrix(s) == nothing
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == nothing
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test !islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s)
    end
    # Scalar System
    scalar_sys = AffineDiscreteSystem(a, c)
    @test scalar_sys == AffineDiscreteSystem(As, Cs)
end

@testset "Discrete linear control system" begin
    s = LinearControlDiscreteSystem(A, B)
    @test state_matrix(s) == A
    @test input_matrix(s) == B
    @test affine_term(s) == nothing
    @test noise_matrix(s) == nothing
    @test statedim(s) == sd
    @test inputdim(s) == id
    @test noisedim(s) == 0
    @test stateset(s) == nothing
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && iscontrolled(s) && !isconstrained(s)
    end
    # Scalar System
    scalar_sys = LinearControlDiscreteSystem(a, b)
    @test scalar_sys == LinearControlDiscreteSystem(As, Bs)
end

@testset "Discrete constrained linear system" begin
    s = ConstrainedLinearDiscreteSystem(A, X)
    @test state_matrix(s) == A
    @test input_matrix(s) == nothing
    @test affine_term(s) == nothing
    @test noise_matrix(s) == nothing
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s)
    end
    # Scalar System
    scalar_sys = ConstrainedLinearDiscreteSystem(a, Xs)
    @test scalar_sys == ConstrainedLinearDiscreteSystem(As, Xs)
end

@testset "Discrete constrained affine system" begin
    s = ConstrainedAffineDiscreteSystem(A, C, X)
    @test state_matrix(s) == A
    @test input_matrix(s) == nothing
    @test affine_term(s) == C
    @test noise_matrix(s) == nothing
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test !islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s)
    end
    # Scalar System
    scalar_sys = ConstrainedAffineDiscreteSystem(a, c, Xs)
    @test scalar_sys == ConstrainedAffineDiscreteSystem(As, Cs, Xs)
end

@testset "Discrete constrained linear control system" begin
    s = ConstrainedLinearControlDiscreteSystem(A, B, X, U)
    @test state_matrix(s) == A
    @test input_matrix(s) == B
    @test affine_term(s) == nothing
    @test noise_matrix(s) == nothing
    @test statedim(s) == sd
    @test inputdim(s) == id
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test inputset(s) == U
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && iscontrolled(s) && isconstrained(s)
    end
    # Scalar System
    scalar_sys = ConstrainedLinearControlDiscreteSystem(a, b, Xs, Us)
    @test scalar_sys == ConstrainedLinearControlDiscreteSystem(As, Bs, Xs, Us)
end

@testset "Discrete linear algebraic system" begin
    s = LinearAlgebraicDiscreteSystem(A, E)
    @test state_matrix(s) == A
    @test input_matrix(s) == nothing
    @test affine_term(s) == nothing
    @test noise_matrix(s) == nothing
    @test s.E == E
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == nothing
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s)
    end
    # Scalar System
    scalar_sys = LinearAlgebraicDiscreteSystem(a, e)
    @test scalar_sys == LinearAlgebraicDiscreteSystem(As, Es)
end

@testset "Discrete constrained linear algebraic system" begin
    s = ConstrainedLinearAlgebraicDiscreteSystem(A, E, X)
    @test state_matrix(s) == A
    @test input_matrix(s) == nothing
    @test affine_term(s) == nothing
    @test noise_matrix(s) == nothing
    @test s.E == E
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s)
    end
    # Scalar System
    scalar_sys = ConstrainedLinearAlgebraicDiscreteSystem(a, e, Xs)
    @test scalar_sys == ConstrainedLinearAlgebraicDiscreteSystem(As, Es, Xs)
end

@testset "Polynomial system in discrete time" begin
    s = PolynomialDiscreteSystem(p)
    @test state_matrix(s) == nothing
    @test input_matrix(s) == nothing
    @test affine_term(s) == nothing
    @test noise_matrix(s) == nothing
    # @test s.p == p
    @test statedim(s) == sdp
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == nothing
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s)
    end
end

@testset "Polynomial system in discrete time with state constraints" begin
    s = ConstrainedPolynomialDiscreteSystem(p, X)
    @test state_matrix(s) == nothing
    @test input_matrix(s) == nothing
    @test affine_term(s) == nothing
    @test noise_matrix(s) == nothing
    # @test s.p == p
    @test statedim(s) == sdp
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s)
    end
end

@testset "Implicit discrete system" begin
    s = BlackBoxDiscreteSystem(add_one, sd)
    @test state_matrix(s) == nothing
    @test input_matrix(s) == nothing
    @test affine_term(s) == nothing
    @test noise_matrix(s) == nothing
    @test s.f(state) ≈ statePlusOne
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == nothing
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && !ispolynomial(s) && isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s)
    end
end

@testset "Discrete control black-box system" begin
    s = BlackBoxControlDiscreteSystem(add_one, sd, id)
    @test state_matrix(s) == nothing
    @test input_matrix(s) == nothing
    @test affine_term(s) == nothing
    @test noise_matrix(s) == nothing
    @test s.f(state, input) ≈ stateInputPlusOne
    @test statedim(s) == sd
    @test inputdim(s) == id
    @test noisedim(s) == 0
    @test stateset(s) == nothing
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && !ispolynomial(s) && isblackbox(s)
        @test !isnoisy(s) && iscontrolled(s) && !isconstrained(s)
    end
end

# ==============
# Noisy systems
# ==============

@testset "Noisy Discrete linear system" begin
    s = NoisyLinearDiscreteSystem(A, D)
    @test state_matrix(s) == A
    @test input_matrix(s) == nothing
    @test affine_term(s) == nothing
    @test noise_matrix(s) == D
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == nd
    @test stateset(s) == nothing
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test isnoisy(s) && !iscontrolled(s) && !isconstrained(s)
    end
    # Scalar System
    scalar_sys = NoisyLinearDiscreteSystem(a, d)
    @test scalar_sys == NoisyLinearDiscreteSystem(As, Ds)
end

@testset "Noisy Discrete constrained linear system" begin
    s = NoisyConstrainedLinearDiscreteSystem(A, D, X, W)
    @test state_matrix(s) == A
    @test input_matrix(s) == nothing
    @test affine_term(s) == nothing
    @test noise_matrix(s) == D
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == nd
    @test stateset(s) == X
    @test inputset(s) == nothing
    @test noiseset(s) == W
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test isnoisy(s) && !iscontrolled(s) && isconstrained(s)
    end
    # Scalar System
    scalar_sys = NoisyConstrainedLinearDiscreteSystem(a, d, Xs, Ws)
    @test scalar_sys == NoisyConstrainedLinearDiscreteSystem(As, Ds, Xs, Ws)
end

@testset "Noisy discrete control linear system" begin
    s = NoisyLinearControlDiscreteSystem(A, B, D)
    @test state_matrix(s) == A
    @test input_matrix(s) == B
    @test affine_term(s) == nothing
    @test noise_matrix(s) == D
    @test statedim(s) == sd
    @test inputdim(s) == id
    @test noisedim(s) == nd
    @test stateset(s) == nothing
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test isnoisy(s) && iscontrolled(s) && !isconstrained(s)
    end
    # Scalar System
    scalar_sys = NoisyLinearControlDiscreteSystem(a, b, d)
    @test scalar_sys == NoisyLinearControlDiscreteSystem(As, Bs, Ds)
end

@testset "Noisy Discrete constrained control linear system" begin
    s = NoisyConstrainedLinearControlDiscreteSystem(A, B, D, X, U, W)
    @test state_matrix(s) == A
    @test input_matrix(s) == B
    @test affine_term(s) == nothing
    @test noise_matrix(s) == D
    @test statedim(s) == sd
    @test inputdim(s) == id
    @test noisedim(s) == nd
    @test stateset(s) == X
    @test inputset(s) == U
    @test noiseset(s) == W
    for s = [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test isnoisy(s) && iscontrolled(s) && isconstrained(s)
    end
    # Scalar System
    scalar_sys = NoisyConstrainedLinearControlDiscreteSystem(a, b, d, Xs, Us, Ws)
    @test scalar_sys == NoisyConstrainedLinearControlDiscreteSystem(As, Bs, Ds, Xs, Us, Ws)
end

@testset "Noisy discrete control affine system" begin
    s = NoisyAffineControlDiscreteSystem(A, B, C, D)
    @test state_matrix(s) == A
    @test input_matrix(s) == B
    @test affine_term(s) == C
    @test noise_matrix(s) == D
    @test statedim(s) == sd
    @test inputdim(s) == id
    @test noisedim(s) == nd
    @test stateset(s) == nothing
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test isaffine(s) && !islinear(s) && !ispolynomial(s) && !isblackbox(s)
        @test isnoisy(s) && iscontrolled(s) && !isconstrained(s)
    end
    # Scalar System
    scalar_sys = NoisyAffineControlDiscreteSystem(a, b, c, d)
    @test scalar_sys == NoisyAffineControlDiscreteSystem(As, Bs, Cs, Ds)
end

@testset "Noisy Discrete constrained control affine system" begin
    s = NoisyConstrainedAffineControlDiscreteSystem(A, B, C, D, X, U, W)
    @test state_matrix(s) == A
    @test input_matrix(s) == B
    @test affine_term(s) == C
    @test noise_matrix(s) == D
    @test statedim(s) == sd
    @test inputdim(s) == id
    @test noisedim(s) == nd
    @test stateset(s) == X
    @test inputset(s) == U
    @test noiseset(s) == W
    for s = [s, typeof(s)]
        @test isaffine(s) && !islinear(s) && !ispolynomial(s) && !isblackbox(s)
        @test isnoisy(s) && iscontrolled(s) && isconstrained(s)
    end
    # Scalar System
    scalar_sys = NoisyConstrainedAffineControlDiscreteSystem(a, b, c, d, Xs, Us, Ws)
    @test scalar_sys == NoisyConstrainedAffineControlDiscreteSystem(As, Bs, Cs, Ds, Xs, Us, Ws)
end

@testset "Noisy discrete control black-box system" begin
    s = NoisyBlackBoxControlDiscreteSystem(add_one, sd, id, nd)
    @test state_matrix(s) == nothing
    @test input_matrix(s) == nothing
    @test affine_term(s) == nothing
    @test noise_matrix(s) == nothing
    @test s.f(state, input, noise) ≈ stateInputNoisePlusOne
    @test statedim(s) == sd
    @test inputdim(s) == id
    @test noisedim(s) == nd
    @test stateset(s) == nothing
    @test inputset(s) == nothing
    @test noiseset(s) == nothing
    for s = [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && !ispolynomial(s) && isblackbox(s)
        @test isnoisy(s) && iscontrolled(s) && !isconstrained(s)
    end
end

@testset "Noisy Discrete constrained control blackbox system" begin
    s = NoisyConstrainedBlackBoxControlDiscreteSystem(add_one, sd, id, nd, X, U, W)
    @test state_matrix(s) == nothing
    @test input_matrix(s) == nothing
    @test affine_term(s) == nothing
    @test noise_matrix(s) == nothing
    @test s.f(state, input, noise) ≈ stateInputNoisePlusOne
    @test statedim(s) == sd
    @test inputdim(s) == id
    @test noisedim(s) == nd
    @test stateset(s) == X
    @test inputset(s) == U
    @test noiseset(s) == W
    for s = [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && !ispolynomial(s) && isblackbox(s)
        @test isnoisy(s) && iscontrolled(s) && isconstrained(s)
    end
end


@testset "Constant input in a discrete constrained linear control system" begin
    U = ConstantInput(Hyperrectangle(low=[0.9], high=[1.1]))
    s = ConstrainedLinearControlDiscreteSystem(A, B, X, U)
    s = ConstrainedLinearControlDiscreteSystem(A, B, X, U)
    if VERSION < v"0.7-"
        @test next(s.U, 1)[1] isa Hyperrectangle
    else
        @test iterate(s.U)[1] isa Hyperrectangle
    end
end


@testset "Varying input in a discrete constrained linear control system" begin
    U = VaryingInput([Hyperrectangle(low=[0.9], high=[1.1]),
                      Hyperrectangle(low=[0.99], high=[1.0])])
    s = ConstrainedLinearControlDiscreteSystem(A, B, X, U)
    @test length(s.U) == 2
    for ui in s.U
        @test ui isa Hyperrectangle
    end
end
