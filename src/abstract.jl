"""
    AbstractSystem

Abstract supertype for all system types.
"""
abstract type AbstractSystem end

@doc """
    statedim(s::AbstractSystem)

Returns the dimension of the state space of system `s`.
"""
statedim(::AbstractSystem)
function statedim end

@doc """
    stateset(s::AbstractSystem)

Returns the set of allowed states of system `s`.
"""
stateset(::AbstractSystem)
function stateset end

@doc """
    inputdim(s::AbstractSystem)

Returns the dimension of the input space of system `s`.
"""
inputdim(::AbstractSystem)
function inputdim end

@doc """
    inputset(s::AbstractSystem)

Returns the set of allowed inputs of system `s`.
"""
inputset(::AbstractSystem)
function inputset end

@doc """
    noisedim(s::AbstractSystem)

Returns the dimension of the noise space of system `s`.
"""
noisedim(::AbstractSystem)
function noisedim end

@doc """
    noiseset(s::AbstractSystem)

Returns the set of allowed noises of system `s`.
"""
noiseset(::AbstractSystem)
function noiseset end

@doc """
    state_matrix(s::AbstractSystem)

Returns the state matrix of an affine system.

### Notes

The state matrix is the matrix proportional to the state, e.g. the matrix `A`
in the linear continuous system ``x' = Ax``.
"""
state_matrix(::AbstractSystem)
function state_matrix end

@doc """
    input_matrix(s::AbstractSystem)

Returns the input matrix of a system with linear input.

### Notes

The input matrix is the matrix proportional to the input, e.g. the matrix `B`
in the linear continuous system with input, ``x' = Ax + Bu``.
"""
input_matrix(::AbstractSystem)
function input_matrix end

@doc """
    noise_matrix(s::AbstractSystem)

Returns the noise matrix of a system with linear noise.

### Notes

The noise matrix is the matrix proportional to the noise, e.g. the matrix `D`
in the linear system with noise, ``x' = Ax + Dw``.
"""
noise_matrix(::AbstractSystem)
function noise_matrix end

@doc """
    affine_term(s::AbstractSystem)

Returns the affine term in an affine system.

### Notes

The affine term is e.g. the vector ``c`` in the affine system ``x' = Ax + c``.
"""
affine_term(::AbstractSystem)
function affine_term end

@doc """
    mapping(s::AbstractSystem)

Returns the mapping of a black-box system.
"""
mapping(::AbstractSystem)
function mapping end

@doc """
    outputmap(s::AbstractSystem)

Returns the output map of a system with output.
"""
outputmap(::AbstractSystem)
function outputmap end

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

@doc """
    islinear(s::AbstractSystem)

Determines whether the dynamics of system `s` is specified by linear equations.

### Notes

We adopt the notion from [Sontag13; Section 2.7](@citet). For example, the system with inputs
``x' = f(t, x, u) = A x + B u`` is linear, since the function ``f(t, ⋅, ⋅)`` is
linear in ``(x, u)`` for each ``t ∈ \\mathbb{R}``. On the other hand,
``x' = f(t, x, u) = A x + B u + c`` is affine but not linear, since it is not
linear in ``(x, u)``.

The result of this function only depends on the system type, not the value, and
can also be applied to `typeof(s)`. So, if a system type allows an instance that
is not linear, it returns `false` by default. For example, polynomial systems
can be nonlinear; hence `islinear` returns `false`.
"""
islinear(::AbstractSystem)
function islinear end

@doc """
    isaffine(s::AbstractSystem)

Determines whether the dynamics of system `s` is specified by affine equations.

### Notes

An affine system is the composition of a linear system and a translation.
See [`islinear(::AbstractSystem)`](@ref) for the notion of linear system adopted
in this library.

The result of this function only depends on the system type, not the value, and
can also be applied to `typeof(s)`. So, if a system type allows an instance that
is not affine, it returns `false` by default. For example, polynomial systems
can be nonlinear; hence `isaffine` is `false`.
"""
isaffine(::AbstractSystem)
function isaffine end

@doc """
    ispolynomial(s::AbstractSystem)

Determines whether the dynamics of system `s` is specified by polynomial equations.

The result of this function only depends on the system type, not the value, and
can also be applied to `typeof(s)`. Hence, e.g. a `LinearContinuousSystem` is not
considered to be of polynomial type.
"""
ispolynomial(::AbstractSystem)
function ispolynomial end

@doc """
    isblackbox(s::AbstractSystem)

Determines whether no specific structure is assumed for the dynamics of system `s`.

The result of this function only depends on the system type, not the value, and
can also be applied to `typeof(s)`.
"""
isblackbox(::AbstractSystem)
function isblackbox end

@doc """
    isnoisy(s::AbstractSystem)

Determines if the dynamics of system `s` contains a noise term `w`.

The result of this function only depends on the system type, not the value, and
can also be applied to `typeof(s)`.
"""
isnoisy(::AbstractSystem)
function isnoisy end

@doc """
    iscontrolled(s::AbstractSystem)

Determines if the dynamics of system `s` contains a control input `u`.

The result of this function only depends on the system type, not the value, and
can also be applied to `typeof(s)`.
"""
iscontrolled(::AbstractSystem)
function iscontrolled end

@doc """
    isconstrained(s::AbstractSystem)

Determines if the system `s` has constraints on the state, input and noise,
respectively (those that are available).

The result of this function only depends on the system type, not the value, and
can also be applied to `typeof(s)`.
"""
isconstrained(::AbstractSystem)
function isconstrained end

@doc """
    isparametric(s::AbstractSystem)

Determines if the system `s` contains one or more symbolic parameters in its
dynamics (for example, matrix entries that can take values from a
specified set).

The result of this function only depends on the
system type, not the value, and can also be applied to `typeof(s)`.
"""
isparametric(::AbstractSystem)
function isparametric end

"""
    AbstractMap

Abstract supertype for all map types.
"""
abstract type AbstractMap end

@doc """
    outputdim(m::AbstractMap)

Returns the dimension of the output space of the map `m`.
"""
outputdim(::AbstractMap)
function outputdim end

@doc """
    islinear(m::AbstractMap)

Determines whether the map `m` is linear or not.

### Notes

A map is *linear* if it preserves the operations of scalar multiplication and
vector addition.
"""
islinear(::AbstractMap)
function islinear end

@doc """
    isaffine(m::AbstractMap)

Determines whether the map `m` is affine or not.

### Notes

An affine map is the composition of a linear map and a translation.
See also [`islinear(::AbstractMap)`](@ref).
"""
isaffine(::AbstractMap)
function isaffine end

@doc """
    apply(m::AbstractMap, args...)

Apply the rule specified by the map to the given arguments.
"""
apply(::AbstractMap)
function apply end
