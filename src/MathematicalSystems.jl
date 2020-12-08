__precompile__(true)
module MathematicalSystems

using LinearAlgebra, SparseArrays
using LinearAlgebra: checksquare
using RecipesBase

#=======================
Identity operator
=======================#
include("identity.jl")

export IdentityMultiple, I

#=========================
Abstract Types for Systems
==========================#
include("abstract.jl")

#=======================
Utility functions
=======================#
include("utilities.jl")

# types
export AbstractSystem,
       AbstractDiscreteSystem,
       AbstractContinuousSystem

# methods
export statedim,
       inputdim,
       noisedim,
       stateset,
       inputset,
       noiseset,
       state_matrix,
       input_matrix,
       noise_matrix,
       affine_term,
       mass_matrix,
       viscosity_matrix,
       stiffness_matrix

# traits
export islinear,
       isaffine,
       ispolynomial,
       isblackbox,
       isnoisy,
       iscontrolled,
       isconstrained

#====================================
Concrete Types for Continuous Systems
====================================#
include("systems.jl")

export ContinuousIdentitySystem,
       ConstrainedContinuousIdentitySystem,
       LinearContinuousSystem,
       AffineContinuousSystem,
       LinearControlContinuousSystem,
       AffineControlContinuousSystem,
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
       BlackBoxControlContinuousSystem,
       ConstrainedBlackBoxControlContinuousSystem,
       NoisyLinearContinuousSystem,
       NoisyConstrainedLinearContinuousSystem,
       NoisyLinearControlContinuousSystem,
       NoisyConstrainedLinearControlContinuousSystem,
       NoisyAffineControlContinuousSystem,
       NoisyConstrainedAffineControlContinuousSystem,
       NoisyBlackBoxControlContinuousSystem,
       NoisyConstrainedBlackBoxControlContinuousSystem,
       SecondOrderLinearContinuousSystem,
       SecondOrderAffineContinuousSystem,
       SecondOrderConstrainedLinearControlContinuousSystem,
       SecondOrderConstrainedAffineControlContinuousSystem

#==================================
Concrete Types for Discrete Systems
===================================#
export DiscreteIdentitySystem,
       ConstrainedDiscreteIdentitySystem,
       LinearDiscreteSystem,
       AffineDiscreteSystem,
       LinearControlDiscreteSystem,
       AffineControlDiscreteSystem,
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
       BlackBoxControlDiscreteSystem,
       ConstrainedBlackBoxControlDiscreteSystem,
       NoisyLinearDiscreteSystem,
       NoisyConstrainedLinearDiscreteSystem,
       NoisyLinearControlDiscreteSystem,
       NoisyConstrainedLinearControlDiscreteSystem,
       NoisyAffineControlDiscreteSystem,
       NoisyConstrainedAffineControlDiscreteSystem,
       NoisyBlackBoxControlDiscreteSystem,
       NoisyConstrainedBlackBoxControlDiscreteSystem,
       SecondOrderLinearDiscreteSystem,
       SecondOrderAffineDiscreteSystem,
       SecondOrderConstrainedLinearControlDiscreteSystem,
       SecondOrderConstrainedAffineControlDiscreteSystem

#==========================================
Concrete Types for an Initial Value Problem
===========================================#
include("ivp.jl")

export InitialValueProblem, IVP,
       initial_state,
       system

#=====================
Input related methods
=====================#
include("inputs.jl")

export AbstractInput,
       ConstantInput,
       VaryingInput,
       nextinput

#==================================
Maps
===================================#
include("maps.jl")

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

#=========================
Systems with outputs
==========================#
include("outputs.jl")

export SystemWithOutput,
       LinearTimeInvariantSystem,
       LTISystem

#=========================
Macros
==========================#
include("macros.jl")

export @map,
       @system,
       @ivp

#===================================
Successor state for discrete systems
and vector field for continuous systems
====================================#
include("instantiate.jl")
include("successor.jl")
include("vector_field.jl")

export successor,
       vector_field

#===================================
Discretization for affine systems
====================================#
include("discretize.jl")

export discretize

end # module
