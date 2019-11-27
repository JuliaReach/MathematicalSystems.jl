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

This function uses the information of the type, not the value. So, if a system
type allows an instance that is not linear, it returns `false` by default.
For example, polynomial systems can be nonlinear; hence `islinear`
returns `false`.

[1] Sontag, Eduardo D. *Mathematical control theory: deterministic finite dimensional
systems.* Vol. 6. Springer Science & Business Media, 2013.
"""
function islinear(::AbstractSystem) end

"""
    isaffine(s::AbstractSystem)

Specifies if the dynamics of system `s` is specified by affine equations.

### Notes

An affine system is the composition of a linear system and a translation.
See [`islinear(::AbstractSystem)`](@ref) for the notion of linear system adopted
in this library.

This function uses the information of the type, not the value. So, if a system
type allows an instance that is not affine, it returns `false` by default.
For example, polynomial systems can be nonlinear; hence `isaffine` is `false`.
"""
function isaffine(::AbstractSystem) end

"""
    ispolynomial(s::AbstractSystem)

Specifies if the dynamics of system `s` is specified by polynomial equations.

The criterion refers to the *type* information, not the value. Hence, e.g. a
`LinearContinuousSystem` is not considered to be of polynomial type.
"""
function ispolynomial(::AbstractSystem) end

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
    isaffine(m::AbstractMap)

Specifies if the map `m` is affine or not.

### Notes

An affine map is the composition of a linear map and a translation.
See also [`islinear(::AbstractMap)`](@ref).
"""
function isaffine(::AbstractMap) end

"""
    apply(m::AbstractMap, args...)

Apply the rule specified by the map to the given arguments.
"""
function apply end
