using MathematicalSystems, LazySets, TypedPolynomials
using SparseArrays, LinearAlgebra
using InteractiveUtils: subtypes
using Test

# fix namespace conflicts with LazySets
using MathematicalSystems: LinearMap, AffineMap, ResetMap

include("continuous.jl")
include("discrete.jl")
include("identity.jl")
include("inputs.jl")
include("maps.jl")
include("outputs.jl")
include("macros.jl")
include("successor.jl")
include("utilities.jl")
include("discretize.jl")
include("@system.jl")
