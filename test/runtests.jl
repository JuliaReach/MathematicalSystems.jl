using MathematicalSystems, LazySets, TypedPolynomials
using Compat, Compat.Test

@static if VERSION >= v"0.7-"
    using SparseArrays
end

include("continuous.jl")
include("discrete.jl")
include("identity.jl")
include("inputs.jl")
include("maps.jl")
include("outputs.jl")
