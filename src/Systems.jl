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
       statedim,
       stateset,
       inputdim,
       inputset

include("abstract.jl")

#====================================
Concrete Types for Continuous Systems
====================================#
export ContinuousIdentitySystem,
       ConstrainedContinuousIdentitySystem,
       LinearContinuousSystem,
       LinearControlContinuousSystem,
       ConstrainedLinearContinuousSystem,
       ConstrainedLinearControlContinuousSystem,
       LinearAlgebraicContinuousSystem,
       ConstrainedLinearAlgebraicContinuousSystem

include("continuous.jl")

#==================================
Concrete Types for Discrete Systems
===================================#
export DiscreteIdentitySystem,
       ConstrainedDiscreteIdentitySystem,
       LinearDiscreteSystem,
       LinearControlDiscreteSystem,
       ConstrainedLinearDiscreteSystem,
       ConstrainedLinearControlDiscreteSystem,
       LinearAlgebraicDiscreteSystem,
       ConstrainedLinearAlgebraicDiscreteSystem

include("discrete.jl")

#==========================================
Concrete Types for an Initial Value Problem
===========================================#
export InitialValueProblem, IVP

include("ivp.jl")


#=====================
Input related methods
=====================#
export AbstractInput, ConstantInput, VaryingInput,
       next_input

include("inputs.jl")

end # module
