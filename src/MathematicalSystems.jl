__precompile__(true)
module MathematicalSystems

using Compat
using Compat.LinearAlgebra
import Compat.LinearAlgebra: checksquare

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
       AffineContinuousSystem,
       LinearControlContinuousSystem,
       ConstrainedLinearContinuousSystem,
       ConstrainedAffineContinuousSystem,
       ConstrainedLinearControlContinuousSystem,
       LinearAlgebraicContinuousSystem,
       ConstrainedLinearAlgebraicContinuousSystem,
       PolynomialContinuousSystem,
       ConstrainedPolynomialContinuousSystem

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
       ConstrainedLinearAlgebraicDiscreteSystem,
       PolynomialDiscreteSystem,
       ConstrainedPolynomialDiscreteSystem

include("discrete.jl")

#==========================================
Concrete Types for an Initial Value Problem
===========================================#
export InitialValueProblem, IVP

include("ivp.jl")


#=====================
Input related methods
=====================#
export AbstractInput, ConstantInput, VaryingInput, nextinput

include("inputs.jl")

end # module
