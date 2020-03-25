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
    apply(system, x; kwargs...)

"""
    successor(system::AbstractDiscreteSystem, x::AbstractVector, u::AbstractVector;
              [check_constraints]=true)

Return the successor state of an `AbstractDiscreteSystem`.

### Input

- `system`            -- `AbstractDiscreteSystem`
- `x`                 -- state (it should be any vector type)
- `u`                 -- input (it should be any vector type)
- `check_constraints` -- (optional, default: `true`) check if the state belongs to
                         the state set

### Output

The result of applying the system to state `x` and input `u`.

### Notes

If the system is not controlled but noisy, the input `u` is interpreted as noise.
    """
successor(system::AbstractDiscreteSystem, x::AbstractVector, u::AbstractVector; kwargs...) =
    apply(system, x, u; kwargs...)

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
    apply(system, x, u, w; kwargs...)

# =============================
# Vector Field for continuous system
# =============================

"""
    vector_field(system::AbstractContinuousSystem, x::AbstractVector;
              [check_constraints]=true)

Return the vector field of an `AbstractContinuousSystem`.

### Input

- `system`            -- `AbstractContinuousSystem`
- `x`                 -- state (it should be any vector type)
- `check_constraints` -- (optional, default: `true`) check if the state belongs to
                         the state set

### Output

The vector field of the system at state `x`.
"""
vector_field(system::AbstractContinuousSystem, x::AbstractVector; kwargs...) =
    apply(system, x; kwargs...)

"""
    vector_field(system::AbstractContinuousSystem, x::AbstractVector, u::AbstractVector;
              [check_constraints]=true)

Return the vector field state of an `AbstractContinuousSystem`.

### Input

- `system`            -- `AbstractContinuousSystem`
- `x`                 -- state (it should be any vector type)
- `u`                 -- input (it should be any vector type)
- `check_constraints` -- (optional, default: `true`) check if the state belongs to
                         the state set

### Output

The vector field of the system at state `x` and applying input `u`.

### Notes

If the system is not controlled but noisy, the input `u` is interpreted as noise.
    """
vector_field(system::AbstractContinuousSystem, x::AbstractVector, u::AbstractVector; kwargs...) =
    apply(system, x, u; kwargs...)

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
    apply(system, x, u, w; kwargs...)


struct VectorField{T}
    field::T
end

# function-like evaluation
@inline function (V::VectorField)(args...)
    evaluate(V, args...)
end

function evaluate(V::VectorField, args...)
    return V.field(args...)
end

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
# Generic apply method
# ====================


"""
    apply(system::AbstractSystem, x::AbstractVector;
              [check_constraints]=true)

Return the result of applying the input to an `AbstractSystem`.

### Input

- `system`            -- `AbstractSystem`
- `x`                 -- state (it should be any vector type)
- `check_constraints` -- (optional, default: `true`) check if the state belongs to
                         the state set

### Output

The result of applying the system to state `x`.
"""
function apply(system::AbstractSystem, x::AbstractVector;
               check_constraints::Bool=true)
    !_is_conformable_state(system, x) && _argument_error(:x)
    if isconstrained(system) && check_constraints
        !_in_stateset(system, x) && _argument_error(:x,:X)
    end

    if islinear(system)
        return state_matrix(system) * x

    elseif isaffine(system)
        return state_matrix(system) * x + affine_term(system)

    else
        return mapping(sys)(x)
    end
end

"""
    apply(system::AbstractSystem, x::AbstractVector, u::AbstractVector;
              [check_constraints]=true)

Return the result of applying two inputs to an `AbstractSystem`.

### Input

- `system`            -- `AbstractSystem`
- `x`                 -- state (it should be any vector type)
- `u`                 -- input (it should be any vector type)
- `check_constraints` -- (optional, default: `true`) check if the state belongs to
                         the state set

### Output

The result of applying the system to state `x` and input `u`.

### Notes

If the system is not controlled but noisy, the input `u` is interpreted as noise.
"""
function apply(sys::AbstractSystem, x::AbstractVector, u::AbstractVector;
               check_constraints::Bool=true)

    if iscontrolled(sys) && !isnoisy(sys)
        input_var = :u; input_set = :U; matrix = input_matrix
        _is_conformable = _is_conformable_input
        _in_set = _in_inputset
    elseif isnoisy(sys) && !iscontrolled(sys)
        input_var = :w; input_set = :W; matrix = noise_matrix
        _is_conformable = _is_conformable_noise
        _in_set = _in_noiseset
    else
        throw(ArgumentError("successor function for $(typeof(sys)) does not have 2 arguments"))
    end

    !_is_conformable_state(sys, x) && _argument_error(:x)
    !_is_conformable(sys, u) && _argument_error(input_var)

    if isconstrained(sys) && check_constraints
        !_in_stateset(sys, x) && _argument_error(:x,:X)
        !_in_set(sys, u) && _argument_error(input_var, input_set)
    end

    if islinear(sys)
        return state_matrix(sys) * x + matrix(sys) * u

    elseif isaffine(sys)
        return state_matrix(sys) * x + affine_term(sys) + matrix(sys) * u

    else
        return mapping(sys)(x, u)
    end
end

"""
    apply(system::AbstractSystem,
              x::AbstractVector, u::AbstractVector, w::AbstractVector; [check_constraints]=true)

Return the result of applying three inputs to an `AbstractSystem`.

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
function apply(sys::AbstractSystem, x::AbstractVector, u::AbstractVector, w::AbstractVector;
               check_constraints::Bool=true)
    !_is_conformable_state(sys, x) && _argument_error(:x)
    !_is_conformable_input(sys, u) && _argument_error(:u)
    !_is_conformable_noise(sys, w) && _argument_error(:w)

    if isconstrained(sys) && check_constraints
        !_in_stateset(sys, x) && _argument_error(:x,:X)
        !_in_inputset(sys, u) && _argument_error(:u,:U)
        !_in_noiseset(sys, w) && _argument_error(:w,:W)
    end

    if islinear(sys)
        return state_matrix(sys) * x + input_matrix(sys) * u + noise_matrix(sys) * w

    elseif isaffine(sys)
        return state_matrix(sys) * x + affine_term(sys) + input_matrix(sys) * u + noise_matrix(sys) * w

    else
        return mapping(sys)(x, u, w)
    end
end
