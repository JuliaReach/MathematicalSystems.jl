__precompile__(true)

"""
Main module for `Systems.jl` -- a Julia package for mathematical systems interfaces.
"""
module Systems

#=========================
Abstract Types for Systems
==========================#
export AbstractSystem,
       AbstractDiscreteSystem,
       AbstractContinuousSystem,
       inputdim,
       statedim

include("abstract.jl")

#====================================
Concrete Types for Continuous Systems
====================================#
export ContinuousLinearSystem

include("continuous.jl")

#==================================
Concrete Types for Discrete Systems
===================================#
export DiscreteLinearSystem

include("discrete.jl")

end # module
