using MathematicalSystems, LazySets, TypedPolynomials
using Compat, Compat.Test
using SparseArrays

# fix namespace conflicts with LazySets
using MathematicalSystems: LinearMap, ResetMap

include("continuous.jl")
include("discrete.jl")
include("identity.jl")
include("inputs.jl")
include("maps.jl")
include("outputs.jl")
