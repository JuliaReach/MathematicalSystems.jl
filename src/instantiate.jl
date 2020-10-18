# helper functions to check that the given system can be applied to the states/inputs
@inline _is_conformable_state(system, x) = statedim(system) == length(x)
@inline _is_conformable_input(system, u) = inputdim(system) == length(u)
@inline _is_conformable_noise(system, w) = noisedim(system) == length(w)
@inline _in_stateset(system, x) = x ∈ stateset(system)
@inline _in_inputset(system, u) = u ∈ inputset(system)
@inline _in_noiseset(system, w) = w ∈ noiseset(system)

@inline function _argument_error(sym, set=:none)
    if sym == :x
        vector = "state"
    elseif sym == :u
        vector = "input"
    elseif sym == :w
        vector = "noise"
    end
    if set == :none
        throw(ArgumentError("the $vector vector has the wrong dimensions"))
    else
        throw(ArgumentError("the $vector vector is not contained in the $(vector) set"))
    end
end


# =============================
# Successor for discrete system
# =============================

"""
    successor(system::DiscreteIdentitySystem, x::AbstractVector)

Return the successor state of a `DiscreteIdentitySystem`.

### Input

- `system` -- `DiscreteIdentitySystem`
- `x`      -- state (it should be any vector type)

### Output

The same state `x`.
"""
function successor(system::DiscreteIdentitySystem, x::AbstractVector)
    !_is_conformable_state(system, x) && _argument_error(:x)
    return x
end

"""
    successor(system::ConstrainedDiscreteIdentitySystem, x::AbstractVector;
              [check_constraints]=true)

Return the successor state of a `ConstrainedDiscreteIdentitySystem`.

### Input

- `system`            -- `ConstrainedDiscreteIdentitySystem`
- `x`                 -- state (it should be any vector type)
- `check_constraints` -- (optional, default: `true`) check if the state belongs to
                         the state set

### Output

The same state `x`.
"""
function successor(system::ConstrainedDiscreteIdentitySystem, x::AbstractVector;
                   check_constraints::Bool=true)
    !_is_conformable_state(system, x) && _argument_error(:x)
    if check_constraints
        !_in_stateset(system, x) && _argument_error(:x,:X)
    end
    return x
end

"""
    successor(system::AbstractDiscreteSystem, x::AbstractVector;
              [check_constraints]=true)

Return the successor state of an `AbstractDiscreteSystem`.

### Input

- `system`            -- `AbstractDiscreteSystem`
- `x`                 -- state (it should be any vector type)
- `check_constraints` -- (optional, default: `true`) check if the state belongs to
                         the state set

### Output

The result of applying the system to state `x`.
"""
successor(system::AbstractDiscreteSystem, x::AbstractVector; kwargs...) =
    _instantiate(system, x; kwargs...)

"""
    successor(system::AbstractDiscreteSystem, x::AbstractVector, u::AbstractVector;
              [check_constraints]=true)

Return the successor state of an `AbstractDiscreteSystem`.

### Input

- `system`            -- `AbstractDiscreteSystem`
- `x`                 -- state (it should be any vector type)
- `u`                 -- input (it should be any vector type) or noise, if `system`
                         is not controlled
- `check_constraints` -- (optional, default: `true`) check if the state belongs to
                         the state set

### Output

The result of applying the system to state `x` and input `u`.

### Notes

If the system is not controlled but noisy, the input `u` is interpreted as noise.
    """
successor(system::AbstractDiscreteSystem, x::AbstractVector, u::AbstractVector; kwargs...) =
    _instantiate(system, x, u; kwargs...)

"""
    successor(system::AbstractDiscreteSystem,
              x::AbstractVector, u::AbstractVector, w::AbstractVector; [check_constraints]=true)

Return the successor state of an `AbstractDiscreteSystem`.

### Input

- `system`            -- `AbstractDiscreteSystem`
- `x`                 -- state (it should be any vector type)
- `u`                 -- input (it should be any vector type)
- `w`                 -- noise (it should be any vector type)
- `check_constraints` -- (optional, default: `true`) check if the state belongs to
                         the state set

### Output

The result of applying the system to state `x`, input `u` and noise `w`.
"""
successor(system::AbstractDiscreteSystem, x::AbstractVector, u::AbstractVector, w::AbstractVector; kwargs...) =
    _instantiate(system, x, u, w; kwargs...)

# =============================
# Vector Field for continuous system
# =============================

"""
    vector_field(system::AbstractContinuousSystem, x::AbstractVector;
              [check_constraints]=true)

Return the vector field state of an `AbstractContinuousSystem`.

### Input

- `system`            -- `AbstractContinuousSystem`
- `x`                 -- state (it should be any vector type)
- `check_constraints` -- (optional, default: `true`) check if the state belongs to
                         the state set

### Output

The vector field of the system at state `x`.
"""
vector_field(system::AbstractContinuousSystem, x::AbstractVector; kwargs...) =
    _instantiate(system, x; kwargs...)

"""
    vector_field(system::AbstractContinuousSystem, x::AbstractVector, u::AbstractVector;
              [check_constraints]=true)

Return the vector field state of an `AbstractContinuousSystem`.

### Input

- `system`            -- `AbstractContinuousSystem`
- `x`                 -- state (it should be any vector type)
- `u`                 -- input (it should be any vector type) or noise, if `system`
                         is not controlled
- `check_constraints` -- (optional, default: `true`) check if the state belongs to
                         the state set

### Output

The vector field of the system at state `x` and applying input `u`.

### Notes

If the system is not controlled but noisy, the input `u` is interpreted as noise.
    """
vector_field(system::AbstractContinuousSystem, x::AbstractVector, u::AbstractVector; kwargs...) =
    _instantiate(system, x, u; kwargs...)

"""
    vector_field(system::AbstractContinuousSystem,
              x::AbstractVector, u::AbstractVector, w::AbstractVector; [check_constraints]=true)

Return the vector field state of an `AbstractContinuousSystem`.

### Input

- `system`            -- `AbstractContinuousSystem`
- `x`                 -- state (it should be any vector type)
- `u`                 -- input (it should be any vector type)
- `w`                 -- noise (it should be any vector type)
- `check_constraints` -- (optional, default: `true`) check if the state belongs to
                         the state set

### Output

The vector field of the system at state `x` and applying input `u` and noise `w`.
"""
vector_field(system::AbstractContinuousSystem, x::AbstractVector, u::AbstractVector, w::AbstractVector; kwargs...) =
    _instantiate(system, x, u, w; kwargs...)

# =============================
# VectorField type for continuous system
# =============================
"""
    VectorField{T<:Function}

Type that computes the vector field of an `AbstractContinuousSystem`.

### Fields

- `field`  -- function for calculating the vector field
"""
struct VectorField{T<:Function}
    field::T
end

# function-like evaluation
@inline function (V::VectorField)(args...)
    evaluate(V, args...)
end

function evaluate(V::VectorField, args...)
    return V.field(args...)
end

"""
    VectorField(sys::AbstractContinuousSystem)

Constructor for creating a `VectorField` from an `AbstractContinuousSystem`.

### Input
- `sys` -- `AbstractContinuousSystem`

### Ouptut
The `VectorField` for the continuous system `sys`.
"""
function VectorField(sys::AbstractContinuousSystem)
    if inputdim(sys) == 0 && noisedim(sys) == 0
        field = (x) -> vector_field(sys, x)
    elseif inputdim(sys) == 0 || noisedim(sys) == 0
        field = (x, u) -> vector_field(sys, x, u)
    else
        field = (x, u, w) -> vector_field(sys, x, u, w)
    end
    return VectorField(field)
end


# ====================
# Generic _instantiate method
# ====================


"""
    _instantiate(system::AbstractSystem, x::AbstractVector;
                [check_constraints]=true)

Return the result of instantiating an `AbstractSystem` at the current state.

### Input

- `system`            -- `AbstractSystem`
- `x`                 -- state (it should be any vector type)
- `check_constraints` -- (optional, default: `true`) check if the state belongs to
                         the state set

### Output

The result of applying the system to state `x`.
"""
function _instantiate(system::AbstractSystem, x::AbstractVector;
                     check_constraints::Bool=true)
    !_is_conformable_state(system, x) && _argument_error(:x)
    if isconstrained(system) && check_constraints
        !_in_stateset(system, x) && _argument_error(:x,:X)
    end

    if islinear(system)
        return state_matrix(system) * x

    elseif isaffine(system)
        return state_matrix(system) * x + affine_term(system)

    elseif ispolynomial(system) || isblackbox(system)
        return mapping(system)(x)

    else
        throw(ArgumentError("_instantiate not defined for type `$(typename(sys))`"))
    end
end

"""
    _instantiate(system::AbstractSystem, x::AbstractVector, u::AbstractVector;
                [check_constraints]=true)

Return the result of instantiating an `AbstractSystem` at the current state and
applying one input.

### Input

- `system`            -- `AbstractSystem`
- `x`                 -- state (it should be any vector type)
- `u`                 -- input (it should be any vector type) or noise, if `system`
                         is not controlled
- `check_constraints` -- (optional, default: `true`) check if the state belongs to
                         the state set

### Output

The result of applying the system to state `x` and input `u`.

### Notes

If the system is not controlled but noisy, the input `u` is interpreted as noise.
"""
function _instantiate(system::AbstractSystem, x::AbstractVector, u::AbstractVector;
                     check_constraints::Bool=true)
    # Figure out if `system` is a controlled or noisy system and set the function
    # `matrix` to either `input_matix` or `noise_matrix`
    if iscontrolled(system) && !isnoisy(system)
        input_var = :u; input_set = :U; matrix = input_matrix
        _is_conformable = _is_conformable_input
        _in_set = _in_inputset
    elseif isnoisy(system) && !iscontrolled(system)
        input_var = :w; input_set = :W; matrix = noise_matrix
        _is_conformable = _is_conformable_noise
        _in_set = _in_noiseset
    else
        throw(ArgumentError("successor function for $(typeof(system)) does not have 2 arguments"))
    end

    !_is_conformable_state(system, x) && _argument_error(:x)
    !_is_conformable(system, u) && _argument_error(input_var)

    if isconstrained(system) && check_constraints
        !_in_stateset(system, x) && _argument_error(:x,:X)
        !_in_set(system, u) && _argument_error(input_var, input_set)
    end

    if islinear(system)
        return state_matrix(system) * x + matrix(system) * u

    elseif isaffine(system)
        return state_matrix(system) * x + affine_term(system) + matrix(system) * u

    elseif ispolynomial(system) || isblackbox(system)
        return mapping(system)(x, u)

    else
        throw(ArgumentError("_instantiate not defined for type `$(typename(system))`"))
    end
end

"""
    _instantiate(system::AbstractSystem,
                x::AbstractVector, u::AbstractVector, w::AbstractVector; [check_constraints]=true)

Return the result of instantiating an `AbstractSystem` at the current state and
applying two inputs to an `AbstractSystem`.

### Input

- `system`            -- `AbstractSystem`
- `x`                 -- state (it should be any vector type)
- `u`                 -- input (it should be any vector type)
- `w`                 -- noise (it should be any vector type)
- `check_constraints` -- (optional, default: `true`) check if the state belongs to
                         the state set

### Output

The result of applying the system to state `x`, input `u` and noise `w`.
"""
function _instantiate(system::AbstractSystem, x::AbstractVector, u::AbstractVector, w::AbstractVector;
                     check_constraints::Bool=true)
    !_is_conformable_state(system, x) && _argument_error(:x)
    !_is_conformable_input(system, u) && _argument_error(:u)
    !_is_conformable_noise(system, w) && _argument_error(:w)

    if isconstrained(system) && check_constraints
        !_in_stateset(system, x) && _argument_error(:x,:X)
        !_in_inputset(system, u) && _argument_error(:u,:U)
        !_in_noiseset(system, w) && _argument_error(:w,:W)
    end

    if islinear(system)
        return state_matrix(system) * x + input_matrix(system) * u + noise_matrix(system) * w

    elseif isaffine(system)
        return state_matrix(system) * x + affine_term(system) + input_matrix(system) * u + noise_matrix(system) * w

    elseif ispolynomial(system) || isblackbox(system)
        return mapping(system)(x, u, w)

    else
        throw(ArgumentError("_instantiate not defined for type `$(typename(system))`"))

    end
end
