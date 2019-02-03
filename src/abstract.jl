"""
    AbstractSystem

Abstract supertype for all system types.
"""
abstract type AbstractSystem end

"""
    statedim(s::AbstractSystem)

Returns the dimension of the state space of system `s`.
"""
function statedim end

"""
    stateset(s::AbstractSystem)

Returns the set of allowed states of system `s`.
"""
function stateset end

"""
    inputdim(s::AbstractSystem)

Returns the dimension of the input space of system `s`.
"""
function inputdim end

"""
    inputset(s::AbstractSystem)

Returns the set of allowed inputs of system `s`.
"""
function inputset end

"""
    AbstractDiscreteSystem

Abstract supertype for all discrete system types.
"""
abstract type AbstractDiscreteSystem <: AbstractSystem end

"""
    AbstractContinuousSystem

Abstract supertype for all continuous system types.
"""
abstract type AbstractContinuousSystem <: AbstractSystem end

"""
    islinear(s::AbstractSystem)

Specifies if the dynamics of system `s` is specified by linear equations.

### Notes

We adopt the notion from [Section 2.7, 1]. For example, the system with inputs
``x' = f(t, x, u) = A x + B u`` is linear, since the function ``f(t, ⋅, ⋅)`` is
linear in ``(x, u)`` for each ``t ∈ \\mathbb{R}``. On the other hand,
``x' = f(t, x, u) = A x + B u + c`` is affine but not linear, since it is not
linear in ``(x, u)``.
 
[1] Sontag, Eduardo D. *Mathematical control theory: deterministic finite dimensional
systems.* Vol. 6. Springer Science & Business Media, 2013.
"""
function islinear(::AbstractSystem) end

"""
    AbstractMap

Abstract supertype for all map types.
"""
abstract type AbstractMap end

"""
    outputdim(m::AbstractMap)

Returns the dimension of the output space of the map `m`.
"""
function outputdim end

"""
    outputmap(s::SystemWithOutput)

Returns the output map of a system with output.
"""
function outputmap end

"""
    islinear(m::AbstractMap)

Specifies if the map `m` is linear or not.

### Notes

A map is *linear* if it preserves the operations of scalar multiplication and
vector addition.
"""
function islinear(::AbstractMap) end

"""
    apply(m::AbstractMap, args...)

Apply the rule specified by the map to the given arguments.
"""
function apply end

