# helper functions to check that the given system can be applied to the states/inputs
@inline _is_conformable_state(system, x) = statedim(system) == length(x)
@inline _is_conformable_input(system, u) = inputdim(system) == length(u)
@inline _in_stateset(system, x) = x ∈ stateset(system)
@inline _in_inputset(system, u) = u ∈ inputset(system)

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
    !_is_conformable_state(system, x) && throw(ArgumentError())
    return x
end

"""
    successor(system::ConstrainedDiscreteIdentitySystem, x::AbstractVector;
              [check_invariant]=true)

Return the successor state of a `ConstrainedDiscreteIdentitySystem`.

### Input

- `system`          -- `ConstrainedDiscreteIdentitySystem`
- `x`               -- state (it should be any vector type)
- `check_invariant` -- (optional, default: `true`) check if the state belongs to
                       the state set

### Output

The same state `x`.
"""
function successor(system::ConstrainedDiscreteIdentitySystem, x::AbstractVector;
                   check_invariant::Bool=true)
    !_is_conformable_state(system, x) && throw(ArgumentError())
    if check_invariant
        !_in_stateset(system, x) && throw(ArgumentError())
    end
    return x
end

"""
    successor(system::LinearDiscreteSystem, x::AbstractVector)

Return the successor state of a `LinearDiscreteSystem`.

### Input

- `system` -- `LinearDiscreteSystem`
- `x`      -- state (it should be any vector type)

### Output

The result of applying the system to `x`.
"""
function successor(system::LinearDiscreteSystem, x::AbstractVector)
    !_is_conformable_state(system, x) && throw(ArgumentError())
    return system.A * x
end

"""
    successor(system::AffineDiscreteSystem, x::AbstractVector)

Return the successor state of a `AffineDiscreteSystem`.

### Input

- `system` -- `AffineDiscreteSystem`
- `x`      -- state (it should be any vector type)

### Output

The result of applying the system to `x`.
"""
function successor(system::AffineDiscreteSystem, x::AbstractVector)
    !_is_conformable_state(system, x) && throw(ArgumentError())
    return system.A * x + system.b
end

"""
    successor(system::LinearControlDiscreteSystem, x::AbstractVector, u::AbstractVector)

Return the successor state of a `LinearControlDiscreteSystem`.

### Input

- `system` -- `LinearControlDiscreteSystem`
- `x`      -- state (it should be any vector type)
- `u`      -- input (it should be any vector type)

### Output

The result of applying the system to `x`, with input `u`.
"""
function successor(system::LinearControlDiscreteSystem, x::AbstractVector, u::AbstractVector)
    (!_is_conformable_state(system, x) || !_is_conformable_input(system, u)) && throw(ArgumentError())
    return system.A * x + system.B * u
end

"""
    successor(system::ConstrainedLinearDiscreteSystem, x::AbstractVector;
              [check_invariant]=true)

Return the successor state of a `ConstrainedLinearDiscreteSystem`.

### Input

- `system`          -- `ConstrainedLinearDiscreteSystem`
- `x`               -- state (it should be any vector type)
- `check_invariant` -- (optional, default: `true`) check if the state belongs to
                       the state set

### Output

The result of applying the system to `x`.
"""
function successor(system::ConstrainedLinearDiscreteSystem, x::AbstractVector;
                   check_invariant::Bool=true)
    !_is_conformable_state(system, x) && throw(ArgumentError())
    if check_invariant
        !_in_stateset(system, x) && throw(ArgumentError())
    end
    return system.A * x
end

"""
    successor(system::ConstrainedAffineDiscreteSystem, x::AbstractVector;
              [check_invariant])

Return the successor state of a `ConstrainedAffineDiscreteSystem`.

### Input

- `system`          -- `ConstrainedAffineDiscreteSystem`
- `x`               -- state (it should be any vector type)
- `check_invariant` -- (optional, default: `true`) check if the state belongs to
                       the state set

### Output

The result of applying the system to `x`.
"""
function successor(system::ConstrainedAffineDiscreteSystem, x::AbstractVector;
                   check_invariant::Bool=true)
    !_is_conformable_state(system, x) && throw(ArgumentError())
    if check_invariant
        !_in_stateset(system, x) && throw(ArgumentError())
    end
    return system.A * x + system.b
end

"""
    successor(system::ConstrainedLinearControlDiscreteSystem, x::AbstractVector,
              u::AbstractVector; [check_invariant]=true)

Return the successor state of a `ConstrainedLinearControlDiscreteSystem`.

### Input

- `system`          -- `ConstrainedLinearControlDiscreteSystem`
- `x`               -- state (it should be any vector type)
- `u`               -- input (it should be any vector type)
- `check_invariant` -- (optional, default: `true`) check if the state belongs to
                       the state set

### Output

The result of applying the system to `x`, with input `u`.
"""
function successor(system::ConstrainedLinearControlDiscreteSystem, x::AbstractVector,
                   u::AbstractVector; check_invariant::Bool=true)
    (!_is_conformable_state(system, x) || !_is_conformable_input(system, u)) && throw(ArgumentError())
    if check_invariant
        (!_in_stateset(system, x) || !_in_inputset(system, u)) && throw(ArgumentError())
    end
    return system.A * x + system.B * u
end

"""
    successor(system::ConstrainedAffineControlDiscreteSystem, x::AbstractVector,
              u::AbstractVector; [check_invariant]=true)

Return the successor state of a `ConstrainedAffineControlDiscreteSystem`.

### Input

- `system`          -- `ConstrainedAffineControlDiscreteSystem`
- `x`               -- state (it should be any vector type)
- `u`               -- input (it should be any vector type)
- `check_invariant` -- (optional, default: `true`) check if the state belongs to
                       the state set

### Output

The result of applying the system to `x`, with input `u`.
"""
function successor(system::ConstrainedAffineControlDiscreteSystem, x::AbstractVector,
                   u::AbstractVector; check_invariant::Bool=true)
    (!_is_conformable_state(system, x) || !_is_conformable_input(system, u)) && throw(ArgumentError())
    if check_invariant
        (!_in_stateset(system, x) || !_in_inputset(system, u)) && throw(ArgumentError())
    end
    return system.A * x + system.B * u + system.c
end

"""
    successor(system::BlackBoxDiscreteSystem, x::AbstractVector)

Return the successor state of a `BlackBoxDiscreteSystem`.

### Input

- `system` -- `BlackBoxDiscreteSystem`
- `x`      -- state (it should be any vector type)

### Output

The result of applying the system to `x`.
"""
function successor(system::BlackBoxDiscreteSystem, x::AbstractVector)
    !_is_conformable_state(system, x) && throw(ArgumentError())
    return system.f(x)
end

"""
    successor(system::ConstrainedBlackBoxDiscreteSystem, x::AbstractVector;
              [check_invariant]=true)

Return the successor state of a `ConstrainedBlackBoxDiscreteSystem`.

### Input

- `system`          -- `ConstrainedBlackBoxDiscreteSystem`
- `x`               -- state (it should be any vector type)
- `check_invariant` -- (optional, default: `true`) check if the state belongs to
                       the state set

### Output

The result of applying the system to `x`.
"""
function successor(system::ConstrainedBlackBoxDiscreteSystem, x::AbstractVector;
                   check_invariant::Bool=true)
    !_is_conformable_state(system, x) && throw(ArgumentError())
    if check_invariant
        !_in_stateset(system, x) && throw(ArgumentError())
    end
    return system.f(x)
end
