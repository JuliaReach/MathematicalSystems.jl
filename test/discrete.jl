# linear systems
E = [0.0 1; 1 0]
A = [1.0 1; 1 -1]
B = Matrix([0.5 1.5]')
C = [1.0; 1.0]
D = [1.0 2; 0 1]
X = Line([1.0, -1], 0.0) # line x = y
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
state = [1.0; 2.0]
input = 1
noise = [3.0; 1.0]
statePlusOne = add_one(state)
stateInputPlusOne = add_one(state, input)
stateInputNoisePlusOne = add_one(state, input, noise)

# Scalar System
a = 1.0;
b = 2.0;
c = 0.1;
d = 3.0;
Xs = 1;
Us = 2;
Ws = 3;
e = 2.0;
As = [a][:, :];
Bs = [b][:, :];
Cs = [c];
Ds = [d][:, :];
Es = [e][:, :];

@testset "Discrete identity system" begin
    s = DiscreteIdentitySystem(sd)
    @test state_matrix(s) == Id(sd)
    @test isnothing(input_matrix(s))
    @test isnothing(affine_term(s))
    @test isnothing(noise_matrix(s))
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test isnothing(stateset(s))
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    for s in [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s) && !isparametric(s)
    end
end

@testset "Discrete constrained identity system" begin
    s = ConstrainedDiscreteIdentitySystem(sd, X)
    @test state_matrix(s) == Id(sd)
    @test isnothing(input_matrix(s))
    @test isnothing(affine_term(s))
    @test isnothing(noise_matrix(s))
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    for s in [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s) && !isparametric(s)
    end
end

@testset "Discrete linear system" begin
    s = LinearDiscreteSystem(A)
    @test state_matrix(s) == A
    @test isnothing(input_matrix(s))
    @test isnothing(affine_term(s))
    @test isnothing(noise_matrix(s))
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test isnothing(stateset(s))
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    for s in [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s) && !isparametric(s)
    end
    # Scalar System
    scalar_sys = LinearDiscreteSystem(a)
    @test scalar_sys == LinearDiscreteSystem(As)
end

@testset "Discrete affine system" begin
    s = AffineDiscreteSystem(A, C)
    @test state_matrix(s) == A
    @test isnothing(input_matrix(s))
    @test affine_term(s) == C
    @test isnothing(noise_matrix(s))
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test isnothing(stateset(s))
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    for s in [s, typeof(s)]
        @test !islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s) && !isparametric(s)
    end
    # Scalar System
    scalar_sys = AffineDiscreteSystem(a, c)
    @test scalar_sys == AffineDiscreteSystem(As, Cs)
end

@testset "Discrete linear control system" begin
    s = LinearControlDiscreteSystem(A, B)
    @test state_matrix(s) == A
    @test input_matrix(s) == B
    @test isnothing(affine_term(s))
    @test isnothing(noise_matrix(s))
    @test statedim(s) == sd
    @test inputdim(s) == id
    @test noisedim(s) == 0
    @test isnothing(stateset(s))
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    for s in [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && iscontrolled(s) && !isconstrained(s) && !isparametric(s)
    end
    # Scalar System
    scalar_sys = LinearControlDiscreteSystem(a, b)
    @test scalar_sys == LinearControlDiscreteSystem(As, Bs)
end

@testset "Discrete constrained linear system" begin
    s = ConstrainedLinearDiscreteSystem(A, X)
    @test state_matrix(s) == A
    @test isnothing(input_matrix(s))
    @test isnothing(affine_term(s))
    @test isnothing(noise_matrix(s))
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    for s in [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s) && !isparametric(s)
    end
    # Scalar System
    scalar_sys = ConstrainedLinearDiscreteSystem(a, Xs)
    @test scalar_sys == ConstrainedLinearDiscreteSystem(As, Xs)
end

@testset "Discrete constrained affine system" begin
    s = ConstrainedAffineDiscreteSystem(A, C, X)
    @test state_matrix(s) == A
    @test isnothing(input_matrix(s))
    @test affine_term(s) == C
    @test isnothing(noise_matrix(s))
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    for s in [s, typeof(s)]
        @test !islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s) && !isparametric(s)
    end
    # Scalar System
    scalar_sys = ConstrainedAffineDiscreteSystem(a, c, Xs)
    @test scalar_sys == ConstrainedAffineDiscreteSystem(As, Cs, Xs)
end

@testset "Discrete constrained linear control system" begin
    s = ConstrainedLinearControlDiscreteSystem(A, B, X, U)
    @test state_matrix(s) == A
    @test input_matrix(s) == B
    @test isnothing(affine_term(s))
    @test isnothing(noise_matrix(s))
    @test statedim(s) == sd
    @test inputdim(s) == id
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test inputset(s) == U
    @test isnothing(noiseset(s))
    for s in [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && iscontrolled(s) && isconstrained(s) && !isparametric(s)
    end
    # Scalar System
    scalar_sys = ConstrainedLinearControlDiscreteSystem(a, b, Xs, Us)
    @test scalar_sys == ConstrainedLinearControlDiscreteSystem(As, Bs, Xs, Us)
end

@testset "Discrete linear descriptor system" begin
    s = LinearDescriptorDiscreteSystem(A, E)
    @test state_matrix(s) == A
    @test isnothing(input_matrix(s))
    @test isnothing(affine_term(s))
    @test isnothing(noise_matrix(s))
    @test s.E == E
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test isnothing(stateset(s))
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    for s in [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s) && !isparametric(s)
    end
    # Scalar System
    scalar_sys = LinearDescriptorDiscreteSystem(a, e)
    @test scalar_sys == LinearDescriptorDiscreteSystem(As, Es)
end

@testset "Discrete constrained linear descriptor system" begin
    s = ConstrainedLinearDescriptorDiscreteSystem(A, E, X)
    @test state_matrix(s) == A
    @test isnothing(input_matrix(s))
    @test isnothing(affine_term(s))
    @test isnothing(noise_matrix(s))
    @test s.E == E
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    for s in [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s) && !isparametric(s)
    end
    # Scalar System
    scalar_sys = ConstrainedLinearDescriptorDiscreteSystem(a, e, Xs)
    @test scalar_sys == ConstrainedLinearDescriptorDiscreteSystem(As, Es, Xs)
end

@testset "Polynomial system in discrete time" begin
    s = PolynomialDiscreteSystem(p)
    @test isnothing(state_matrix(s))
    @test isnothing(input_matrix(s))
    @test isnothing(affine_term(s))
    @test isnothing(noise_matrix(s))
    # @test s.p == p
    @test statedim(s) == sdp
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test isnothing(stateset(s))
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    for s in [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s) && !isparametric(s)
    end
end

@testset "Polynomial system in discrete time with state constraints" begin
    s = ConstrainedPolynomialDiscreteSystem(p, X)
    @test isnothing(state_matrix(s))
    @test isnothing(input_matrix(s))
    @test isnothing(affine_term(s))
    @test isnothing(noise_matrix(s))
    # @test s.p == p
    @test statedim(s) == sdp
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test stateset(s) == X
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    for s in [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && ispolynomial(s) && !isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && isconstrained(s) && !isparametric(s)
    end
end

@testset "Implicit discrete system" begin
    s = BlackBoxDiscreteSystem(add_one, sd)
    @test isnothing(state_matrix(s))
    @test isnothing(input_matrix(s))
    @test isnothing(affine_term(s))
    @test isnothing(noise_matrix(s))
    @test s.f(state) ≈ statePlusOne
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == 0
    @test isnothing(stateset(s))
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    for s in [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && !ispolynomial(s) && isblackbox(s)
        @test !isnoisy(s) && !iscontrolled(s) && !isconstrained(s) && !isparametric(s)
    end
end

@testset "Discrete control black-box system" begin
    s = BlackBoxControlDiscreteSystem(add_one, sd, id)
    @test isnothing(state_matrix(s))
    @test isnothing(input_matrix(s))
    @test isnothing(affine_term(s))
    @test isnothing(noise_matrix(s))
    @test s.f(state, input) ≈ stateInputPlusOne
    @test statedim(s) == sd
    @test inputdim(s) == id
    @test noisedim(s) == 0
    @test isnothing(stateset(s))
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    for s in [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && !ispolynomial(s) && isblackbox(s)
        @test !isnoisy(s) && iscontrolled(s) && !isconstrained(s) && !isparametric(s)
    end
end

# ==============
# Noisy systems
# ==============

@testset "Noisy Discrete linear system" begin
    s = NoisyLinearDiscreteSystem(A, D)
    @test state_matrix(s) == A
    @test isnothing(input_matrix(s))
    @test isnothing(affine_term(s))
    @test noise_matrix(s) == D
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == nd
    @test isnothing(stateset(s))
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    for s in [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test isnoisy(s) && !iscontrolled(s) && !isconstrained(s) && !isparametric(s)
    end
    # Scalar System
    scalar_sys = NoisyLinearDiscreteSystem(a, d)
    @test scalar_sys == NoisyLinearDiscreteSystem(As, Ds)
end

@testset "Noisy Discrete constrained linear system" begin
    s = NoisyConstrainedLinearDiscreteSystem(A, D, X, W)
    @test state_matrix(s) == A
    @test isnothing(input_matrix(s))
    @test isnothing(affine_term(s))
    @test noise_matrix(s) == D
    @test statedim(s) == sd
    @test inputdim(s) == 0
    @test noisedim(s) == nd
    @test stateset(s) == X
    @test isnothing(inputset(s))
    @test noiseset(s) == W
    for s in [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test isnoisy(s) && !iscontrolled(s) && isconstrained(s) && !isparametric(s)
    end
    # Scalar System
    scalar_sys = NoisyConstrainedLinearDiscreteSystem(a, d, Xs, Ws)
    @test scalar_sys == NoisyConstrainedLinearDiscreteSystem(As, Ds, Xs, Ws)
end

@testset "Noisy discrete control linear system" begin
    s = NoisyLinearControlDiscreteSystem(A, B, D)
    @test state_matrix(s) == A
    @test input_matrix(s) == B
    @test isnothing(affine_term(s))
    @test noise_matrix(s) == D
    @test statedim(s) == sd
    @test inputdim(s) == id
    @test noisedim(s) == nd
    @test isnothing(stateset(s))
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    for s in [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test isnoisy(s) && iscontrolled(s) && !isconstrained(s) && !isparametric(s)
    end
    # Scalar System
    scalar_sys = NoisyLinearControlDiscreteSystem(a, b, d)
    @test scalar_sys == NoisyLinearControlDiscreteSystem(As, Bs, Ds)
end

@testset "Noisy Discrete constrained control linear system" begin
    s = NoisyConstrainedLinearControlDiscreteSystem(A, B, D, X, U, W)
    @test state_matrix(s) == A
    @test input_matrix(s) == B
    @test isnothing(affine_term(s))
    @test noise_matrix(s) == D
    @test statedim(s) == sd
    @test inputdim(s) == id
    @test noisedim(s) == nd
    @test stateset(s) == X
    @test inputset(s) == U
    @test noiseset(s) == W
    for s in [s, typeof(s)]
        @test islinear(s) && isaffine(s) && !ispolynomial(s) && !isblackbox(s)
        @test isnoisy(s) && iscontrolled(s) && isconstrained(s) && !isparametric(s)
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
    @test isnothing(stateset(s))
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    for s in [s, typeof(s)]
        @test isaffine(s) && !islinear(s) && !ispolynomial(s) && !isblackbox(s)
        @test isnoisy(s) && iscontrolled(s) && !isconstrained(s) && !isparametric(s)
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
    for s in [s, typeof(s)]
        @test isaffine(s) && !islinear(s) && !ispolynomial(s) && !isblackbox(s)
        @test isnoisy(s) && iscontrolled(s) && isconstrained(s) && !isparametric(s)
    end
    # Scalar System
    scalar_sys = NoisyConstrainedAffineControlDiscreteSystem(a, b, c, d, Xs, Us, Ws)
    @test scalar_sys == NoisyConstrainedAffineControlDiscreteSystem(As, Bs, Cs, Ds, Xs, Us, Ws)
end

@testset "Noisy discrete control black-box system" begin
    s = NoisyBlackBoxControlDiscreteSystem(add_one, sd, id, nd)
    @test isnothing(state_matrix(s))
    @test isnothing(input_matrix(s))
    @test isnothing(affine_term(s))
    @test isnothing(noise_matrix(s))
    @test s.f(state, input, noise) ≈ stateInputNoisePlusOne
    @test statedim(s) == sd
    @test inputdim(s) == id
    @test noisedim(s) == nd
    @test isnothing(stateset(s))
    @test isnothing(inputset(s))
    @test isnothing(noiseset(s))
    for s in [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && !ispolynomial(s) && isblackbox(s)
        @test isnoisy(s) && iscontrolled(s) && !isconstrained(s) && !isparametric(s)
    end
end

@testset "Noisy Discrete constrained control blackbox system" begin
    s = NoisyConstrainedBlackBoxControlDiscreteSystem(add_one, sd, id, nd, X, U, W)
    @test isnothing(state_matrix(s))
    @test isnothing(input_matrix(s))
    @test isnothing(affine_term(s))
    @test isnothing(noise_matrix(s))
    @test s.f(state, input, noise) ≈ stateInputNoisePlusOne
    @test statedim(s) == sd
    @test inputdim(s) == id
    @test noisedim(s) == nd
    @test stateset(s) == X
    @test inputset(s) == U
    @test noiseset(s) == W
    for s in [s, typeof(s)]
        @test !islinear(s) && !isaffine(s) && !ispolynomial(s) && isblackbox(s)
        @test isnoisy(s) && iscontrolled(s) && isconstrained(s) && !isparametric(s)
    end
end

@testset "Constant input in a discrete constrained linear control system" begin
    U = ConstantInput(Hyperrectangle(; low=[0.9], high=[1.1]))
    s = ConstrainedLinearControlDiscreteSystem(A, B, X, U)
    s = ConstrainedLinearControlDiscreteSystem(A, B, X, U)
    if VERSION < v"0.7-"
        @test next(s.U, 1)[1] isa Hyperrectangle
    else
        @test iterate(s.U)[1] isa Hyperrectangle
    end
end

@testset "Varying input in a discrete constrained linear control system" begin
    U = VaryingInput([Hyperrectangle(; low=[0.9], high=[1.1]),
                      Hyperrectangle(; low=[0.99], high=[1.0])])
    s = ConstrainedLinearControlDiscreteSystem(A, B, X, U)
    @test length(s.U) == 2
    for ui in s.U
        @test ui isa Hyperrectangle
    end
end

# ==================
# Parametric systems
# ==================

@testset "Linear parametric discrete systems" begin
    @static if isdefined(@__MODULE__, :LazySets)
        using LazySets: MatrixZonotope

        Ac = [1.0 0.0; 0.0 1.0]
        A1 = [0.1 0.0; 0.0 0.0]
        A2 = [0.0 0.0; 0.0 0.2]
        A = MatrixZonotope(Ac, [A1, A2])

        s = LinearParametricDiscreteSystem(A)
        @test s isa LinearParametricDiscreteSystem
        # shortcut constructor
        s = LinearDiscreteSystem(A)
        @test s isa LinearParametricDiscreteSystem

        @test statedim(s) == 2
        @test inputdim(s) == 0
        @test noisedim(s) == 0
        @test state_matrix(s) === A
        @test islinear(s)
        @test isparametric(s)
        @test isaffine(s)
        @test !isnoisy(s)
        @test !iscontrolled(s)
        @test !isconstrained(s)

        Bc = hcat([1.0; 0.5])
        B1 = hcat([0.05; 0.0])
        B = MatrixZonotope(Bc, [B1])

        sc = LinearControlParametricDiscreteSystem(A, B)
        @test sc isa LinearControlParametricDiscreteSystem
        # shortcut constructor
        sc = LinearControlDiscreteSystem(A, B)
        @test sc isa LinearControlParametricDiscreteSystem

        @test statedim(sc) == 2
        @test inputdim(sc) == 1
        @test noisedim(sc) == 0
        @test state_matrix(sc) === A
        @test input_matrix(sc) === B
        @test islinear(sc)
        @test isparametric(sc)
        @test isaffine(sc)
        @test iscontrolled(sc)
        @test !isnoisy(sc)
        @test !isconstrained(sc)

        X = Zonotope([0.0, 0.0], Matrix{Float64}(I, 2, 2))
        U = Zonotope([0.0], Matrix{Float64}(I, 1, 1))

        scd = ConstrainedLinearControlParametricDiscreteSystem(A, B, X, U)
        @test scd isa ConstrainedLinearControlParametricDiscreteSystem

        @test statedim(scd) == 2
        @test inputdim(scd) == 1
        @test noisedim(scd) == 0
        @test state_matrix(scd) === A
        @test input_matrix(scd) === B
        @test stateset(scd) === X
        @test inputset(scd) === U
        @test islinear(scd)
        @test isparametric(scd)
        @test isaffine(scd)
        @test iscontrolled(scd)
        @test isconstrained(scd)
        @test !isnoisy(scd)
    end
end
