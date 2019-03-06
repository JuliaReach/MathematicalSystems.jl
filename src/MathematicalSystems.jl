__precompile__(true)
module MathematicalSystems

using LinearAlgebra
using LinearAlgebra: checksquare

#=======================
Identity operator
=======================#
include("identity.jl")

export IdentityMultiple, I

#=========================
Abstract Types for Systems
==========================#
include("abstract.jl")

# types
export AbstractSystem,
       AbstractDiscreteSystem,
       AbstractContinuousSystem

# methods
export statedim,
       stateset,
       inputdim,
       inputset

# traits
export islinear,
       isaffine,
       isalgebraic

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
       ConstrainedAffineControlContinuousSystem,
       ConstrainedLinearControlContinuousSystem,
       LinearAlgebraicContinuousSystem,
       ConstrainedLinearAlgebraicContinuousSystem,
       PolynomialContinuousSystem,
       ConstrainedPolynomialContinuousSystem,
       BlackBoxContinuousSystem,
       ConstrainedBlackBoxContinuousSystem,
       ConstrainedBlackBoxControlContinuousSystem

#==================================
Concrete Types for Discrete Systems
===================================#
export DiscreteIdentitySystem,
       ConstrainedDiscreteIdentitySystem,
       LinearDiscreteSystem,
       AffineDiscreteSystem,
       LinearControlDiscreteSystem,
       ConstrainedLinearDiscreteSystem,
       ConstrainedAffineDiscreteSystem,
       ConstrainedLinearControlDiscreteSystem,
       ConstrainedAffineControlDiscreteSystem,
       LinearAlgebraicDiscreteSystem,
       ConstrainedLinearAlgebraicDiscreteSystem,
       PolynomialDiscreteSystem,
       ConstrainedPolynomialDiscreteSystem,
       BlackBoxDiscreteSystem,
       ConstrainedBlackBoxDiscreteSystem,
       ConstrainedBlackBoxControlDiscreteSystem

include("systems.jl")

#==========================================
Concrete Types for an Initial Value Problem
===========================================#
export InitialValueProblem, IVP

include("ivp.jl")

#=====================
Input related methods
=====================#
export AbstractInput,
       ConstantInput,
       VaryingInput,
       nextinput

include("inputs.jl")

#==================================
Maps
===================================#

# types
export AbstractMap,
       IdentityMap,
       ConstrainedIdentityMap,
       LinearMap,
       ConstrainedLinearMap,
       AffineMap,
       ConstrainedAffineMap,
       LinearControlMap,
       ConstrainedLinearControlMap,
       AffineControlMap,
       ConstrainedAffineControlMap,
       ResetMap,
       ConstrainedResetMap

# methods
export outputmap,
       outputdim,
       apply

include("maps.jl")

#=========================
Systems with outputs
==========================#
export SystemWithOutput,
       LinearTimeInvariantSystem,
       LTISystem

include("outputs.jl")

#=========================
Macros
==========================#
export @map

include("macros.jl")


end # module
