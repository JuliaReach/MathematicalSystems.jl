
@testset "Convert Continuous to Discrete Type" begin
    for dtype in subtypes(AbstractDiscreteSystem)
        ctype = eval.(Meta.parse.(replace(string(dtype), "Discrete" => "Continuous")))
        @test MathematicalSystems._complementary_type(dtype) == ctype
        @inferred MathematicalSystems._complementary_type(dtype)
    end

    for ctype in subtypes(AbstractContinuousSystem)
        dtype = eval.(Meta.parse.(replace(string(ctype), "Continuous" => "Discrete")))
        @test MathematicalSystems._complementary_type(ctype) == dtype
        @inferred MathematicalSystems._complementary_type(ctype)
    end
end

@testset "Exact Discretization of Continous Systems" begin
    ΔT = 0.1
    A = [0.5 1; 0.0 0.5]
    B = Matrix([0.5 1.0]')
    c = [1.0; 1.0]
    D = [0.3 0.7; -0.5 1.30]
    X = BallInf(zeros(2), 1.0)
    U = BallInf(zeros(1), 2.0)
    W = BallInf(zeros(2), 3.0)
    A_d = exp(A*ΔT)
    M = inv(A)*(A_d - I)
    B_d = M*B
    c_d = M*c
    D_d = M*D
    dict = Dict([:A => A, :B => B, :b => c, :c => c, :D => D,
                 :X => X, :U => U, :W => W])
    dict_discretized = Dict([:A => A_d, :B => B_d, :b => c_d, :c => c_d, :D => D_d,
                 :X => X, :U => U, :W => W])
    # get affine ctypes
    CTYPES = filter(x -> (occursin("Linear", string(x)) || occursin("Affine", string(x))) &&
                         !occursin("Algebraic", string(x)) , subtypes(AbstractContinuousSystem))
    DTYPES = MathematicalSystems._complementary_type.(CTYPES)
    CFIELDS = fieldnames.(CTYPES)
    CValues = [getindex.(Ref(dict), type) for type in CFIELDS]
    DValues = [getindex.(Ref(dict_discretized), type) for type in CFIELDS]
    discretized_function = [discretize(CTYPES[i](CValues[i]...), ΔT) for i=1:length(CTYPES)]
    discretized_constructed = [DTYPES[i](DValues[i]...) for i=1:length(DTYPES)]

    @test all(discretized_constructed .== discretized_function)
end
