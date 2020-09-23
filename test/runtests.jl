using MathematicalSystems, LazySets, TypedPolynomials
using SparseArrays, LinearAlgebra
using InteractiveUtils: subtypes
using Test

# fix namespace conflicts with LazySets
using MathematicalSystems: LinearMap, AffineMap, ResetMap

const SECOND_ORDER_CTYPES = [SecondOrderAffineContinuousSystem,
                             SecondOrderConstrainedAffineControlContinuousSystem,
                             SecondOrderConstrainedLinearControlContinuousSystem,
                             SecondOrderLinearContinuousSystem]

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
include("@ivp.jl")
