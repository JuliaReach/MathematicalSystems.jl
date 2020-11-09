"""
    AbstractSystem

Abstract supertype for all system types.
"""
abstract type AbstractSystem end

"""
    statedim(s::AbstractSystem)

Returns the dimension of the state space of system `s`.
"""
statedim(::AbstractSystem) = nothing

"""
    stateset(s::AbstractSystem)

Returns the set of allowed states of system `s`.
"""
stateset(::AbstractSystem) = nothing

"""
    inputdim(s::AbstractSystem)

Returns the dimension of the input space of system `s`.
"""
inputdim(::AbstractSystem) = nothing

"""
    inputset(s::AbstractSystem)

Returns the set of allowed inputs of system `s`.
"""
inputset(::AbstractSystem) = nothing

"""
    noisedim(s::AbstractSystem)

Returns the dimension of the noise space of system `s`.
"""
noisedim(::AbstractSystem) = nothing

"""
    noiseset(s::AbstractSystem)

Returns the set of allowed noises of system `s`.
"""
noiseset(::AbstractSystem) = nothing

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

The result of this function only depends on the system type, not the value, and
can also be applied to `typeof(s)`. So, if a system type allows an instance that
is not linear, it returns `false` by default. For example, polynomial systems
can be nonlinear; hence `islinear` returns `false`.

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

The result of this function only depends on the system type, not the value, and
can also be applied to `typeof(s)`. So, if a system type allows an instance that
is not affine, it returns `false` by default. For example, polynomial systems
can be nonlinear; hence `isaffine` is `false`.
"""
function isaffine(::AbstractSystem) end

"""
    ispolynomial(s::AbstractSystem)

Specifies if the dynamics of system `s` is specified by polynomial equations.

The result of this function only depends on the system type, not the value, and
can also be applied to `typeof(s)`. Hence, e.g. a `LinearContinuousSystem` is not
considered to be of polynomial type.
"""
function ispolynomial(::AbstractSystem) end

"""
    isblackbox(s::AbstractSystem)

Specifies if no specific structure is assumed for the dynamics of system `s`.

The result of this function only depends on the system type, not the value, and
can also be applied to `typeof(s)`.
"""
function isblackbox(::AbstractSystem) end

"""
    isnoisy(s::AbstractSystem)

Determines if the dynamics of system `s` contains a noise term `w`.

The result of this function only depends on the system type, not the value, and
can also be applied to `typeof(s)`.
"""
function isnoisy(::AbstractSystem) end

"""
    iscontrolled(s::AbstractSystem)

Determines if the dynamics of system `s` contains a control input `u`.

The result of this function only depends on the system type, not the value, and
can also be applied to `typeof(s)`.
"""
function iscontrolled(::AbstractSystem) end

"""
    isconstrained(s::AbstractSystem)

Determines if the system `s` has constraints on the state, input and noise,
respectively (those that are available).

The result of this function only depends on the system type, not the value, and
can also be applied to `typeof(s)`.
"""
function isconstrained(::AbstractSystem) end

"""
    AbstractMap

Abstract supertype for all map types.
"""
abstract type AbstractMap end

"""
    outputdim(m::AbstractMap)

Returns the dimension of the output space of the map `m`.
"""
outputdim(::AbstractMap) = nothing

"""
    outputmap(s::SystemWithOutput)

Returns the output map of a system with output.
"""
outputmap(::AbstractSystem) = nothing

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

"""
    state_matrix(s::AbstractSystem)

Return the state matrix of an affine system.

### Notes

The state matrix is the matrix proportional to the state, e.g. the matrix `A`
in the linear continuous system ``x' = Ax``.
"""
state_matrix(::AbstractSystem) = nothing

"""
    input_matrix(s::AbstractSystem)

Return the input matrix of a system with linear input.

### Notes

The input matrix is the matrix proportional to the input, e.g. the matrix `B`
in the linear continuous system with input, ``x' = Ax + Bu``.
"""
input_matrix(::AbstractSystem) = nothing

"""
    noise_matrix(s::AbstractSystem)

Return the noise matrix of a system with linear noise.

### Notes

The noise matrix is the matrix proportional to the noise, e.g. the matrix `D`
in the linear system with noise, ``x' = Ax + Dw``.
"""
noise_matrix(::AbstractSystem) = nothing

"""
    affine_term(s::AbstractSystem)

Return the affine term in an affine system.

### Notes

The affine term is e.g. the vector ``c`` in the affine system ``x' = Ax + c``.
"""
affine_term(::AbstractSystem) = nothing
