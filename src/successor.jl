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
