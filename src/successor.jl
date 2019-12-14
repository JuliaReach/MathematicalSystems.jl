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
    successor(system::LinearDiscreteSystem, x::AbstractVector)

Return the successor state of a `LinearDiscreteSystem`.

### Input

- `system` -- `LinearDiscreteSystem`
- `x`      -- state (it should be any vector type)

### Output

The result of applying the system to `x`.
"""
function successor(system::LinearDiscreteSystem, x::AbstractVector)
    !_is_conformable_state(system, x) && _argument_error(:x)
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
    !_is_conformable_state(system, x) && _argument_error(:x)
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
    !_is_conformable_state(system, x) && _argument_error(:x)
    !_is_conformable_input(system, u) && _argument_error(:u)
    return system.A * x + system.B * u
end

"""
    successor(system::ConstrainedLinearDiscreteSystem, x::AbstractVector;
              [check_constraints]=true)

Return the successor state of a `ConstrainedLinearDiscreteSystem`.

### Input

- `system`            -- `ConstrainedLinearDiscreteSystem`
- `x`                 -- state (it should be any vector type)
- `check_constraints` -- (optional, default: `true`) check if the state belongs to
                         the state set

### Output

The result of applying the system to `x`.
"""
function successor(system::ConstrainedLinearDiscreteSystem, x::AbstractVector;
                   check_constraints::Bool=true)
   !_is_conformable_state(system, x) && _argument_error(:x)
    if check_constraints
        !_in_stateset(system, x) && _argument_error(:x,:X)
    end
    return system.A * x
end

"""
    successor(system::ConstrainedAffineDiscreteSystem, x::AbstractVector;
              [check_constraints])

Return the successor state of a `ConstrainedAffineDiscreteSystem`.

### Input

- `system`            -- `ConstrainedAffineDiscreteSystem`
- `x`                 -- state (it should be any vector type)
- `check_constraints` -- (optional, default: `true`) check if the state belongs to
                         the state set

### Output

The result of applying the system to `x`.
"""
function successor(system::ConstrainedAffineDiscreteSystem, x::AbstractVector;
                   check_constraints::Bool=true)
    !_is_conformable_state(system, x) && _argument_error(:x)
    if check_constraints
        !_in_stateset(system, x) && _argument_error(:x,:X)
    end
    return system.A * x + system.b
end

"""
    successor(system::ConstrainedLinearControlDiscreteSystem, x::AbstractVector,
              u::AbstractVector; [check_constraints]=true)

Return the successor state of a `ConstrainedLinearControlDiscreteSystem`.

### Input

- `system`            -- `ConstrainedLinearControlDiscreteSystem`
- `x`                 -- state (it should be any vector type)
- `u`                 -- input (it should be any vector type)
- `check_constraints` -- (optional, default: `true`) check if the state (resp. input)
                         belongs to the state set (resp. input set)

### Output

The result of applying the system to `x`, with input `u`.
"""
function successor(system::ConstrainedLinearControlDiscreteSystem, x::AbstractVector,
                   u::AbstractVector; check_constraints::Bool=true)
    !_is_conformable_state(system, x) && _argument_error(:x)
    !_is_conformable_input(system, u) && _argument_error(:u)
    if check_constraints
        !_in_stateset(system, x) &&_argument_error(:x,:X)
        !_in_inputset(system, u) && _argument_error(:u,:U)
    end
    return system.A * x + system.B * u
end

"""
    successor(system::ConstrainedAffineControlDiscreteSystem, x::AbstractVector,
              u::AbstractVector; [check_constraints]=true)

Return the successor state of a `ConstrainedAffineControlDiscreteSystem`.

### Input

- `system`            -- `ConstrainedAffineControlDiscreteSystem`
- `x`                 -- state (it should be any vector type)
- `u`                 -- input (it should be any vector type)
- `check_constraints` -- (optional, default: `true`) check if the state (resp. input)
                         belongs to the state set (resp. input set)

### Output

The result of applying the system to `x`, with input `u`.
"""
function successor(system::ConstrainedAffineControlDiscreteSystem,
                   x::AbstractVector, u::AbstractVector; check_constraints::Bool=true)
    !_is_conformable_state(system, x) && _argument_error(:x)
    !_is_conformable_input(system, u) && _argument_error(:u)
    if check_constraints
        !_in_stateset(system, x) && _argument_error(:x,:X)
        !_in_inputset(system, u) && _argument_error(:u,:U)
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
    !_is_conformable_state(system, x) && _argument_error(:x)
    return system.f(x)
end

"""
    successor(system::ConstrainedBlackBoxDiscreteSystem, x::AbstractVector;
              [check_constraints]=true)

Return the successor state of a `ConstrainedBlackBoxDiscreteSystem`.

### Input

- `system`            -- `ConstrainedBlackBoxDiscreteSystem`
- `x`                 -- state (it should be any vector type)
- `check_constraints` -- (optional, default: `true`) check if the state belongs to
                         the state set

### Output

The result of applying the system to `x`.
"""
function successor(system::ConstrainedBlackBoxDiscreteSystem, x::AbstractVector;
                   check_constraints::Bool=true)
    !_is_conformable_state(system, x) && _argument_error(:x)
    if check_constraints
        !_in_stateset(system, x) && _argument_error(:x,:X)
    end
    return system.f(x)
end

"""
    successor(system::ConstrainedBlackBoxControlDiscreteSystem, x::AbstractVector,
              u::AbstractVector; [check_constraints]=true)

Return the successor state of a `ConstrainedBlackBoxControlDiscreteSystem`.

### Input

- `system`            -- `ConstrainedBlackBoxControlDiscreteSystem`
- `x`                 -- state (it should be any vector type)
- `u`                 -- input (it should be any vector type)
- `check_constraints` -- (optional, default: `true`) check if the state belongs to
                         the state set

### Output

The result of applying the system to `x`, with input `u`.
"""
function successor(system::ConstrainedBlackBoxControlDiscreteSystem, x::AbstractVector,
                   u::AbstractVector; check_constraints::Bool=true)
    !_is_conformable_state(system, x) && _argument_error(:x)
    !_is_conformable_input(system, u) && _argument_error(:u)
    if check_constraints
        !_in_stateset(system, x) && _argument_error(:x,:X)
        !_in_inputset(system, u) &&_argument_error(:u,:U)
    end
    return system.f(x, u)
end


"""
    successor(system::NoisyConstrainedLinearDiscreteSystem, x::AbstractVector,
              w::AbstractVector; [check_constraints]=true)

Return the successor state of a `NoisyConstrainedLinearDiscreteSystem`.

### Input

- `system`            -- `NoisyConstrainedLinearDiscreteSystem`
- `x`                 -- state (it should be any vector type)
- `w`                 -- noise (it should be any vector type)
- `check_constraints` -- (optional, default: `true`) check if the state belongs to
                         the state set

### Output

The result of applying the system to `x`.
"""
function successor(system::NoisyConstrainedLinearDiscreteSystem, x::AbstractVector,
                   w::AbstractVector; check_constraints::Bool=true)
   !_is_conformable_state(system, x) && _argument_error(:x)
   !_is_conformable_noise(system, w) && _argument_error(:w)
    if check_constraints
        !_in_stateset(system, x) && _argument_error(:x,:X)
        !_in_noiseset(system, w) &&_argument_error(:w,:W)
    end
    return system.A * x + system.D * w
end


"""
    successor(system::NoisyConstrainedLinearControlDiscreteSystem,
              x::AbstractVector, u::AbstractVector, w::AbstractVector; [check_constraints]=true)

Return the successor state of a `NoisyConstrainedLinearControlDiscreteSystem`.

### Input

- `system`            -- `NoisyConstrainedLinearControlDiscreteSystem`
- `x`                 -- state (it should be any vector type)
- `u`                 -- input (it should be any vector type)
- `w`                 -- noise (it should be any vector type)
- `check_constraints` -- (optional, default: `true`) check if the state (resp. input)
                         belongs to the state set (resp. input set)

### Output

The result of applying the system to `x`, with input `u`.
"""
function successor(system::NoisyConstrainedLinearControlDiscreteSystem,
                   x::AbstractVector, u::AbstractVector, w::AbstractVector; check_constraints::Bool=true)
    !_is_conformable_state(system, x) && _argument_error(:x)
    !_is_conformable_input(system, u) && _argument_error(:u)
    !_is_conformable_noise(system, w) && _argument_error(:w)
    if check_constraints
        !_in_stateset(system, x) &&_argument_error(:x,:X)
        !_in_inputset(system, u) && _argument_error(:u,:U)
        !_in_noiseset(system, w) &&_argument_error(:w,:W)
    end
    return system.A * x + system.B * u + system.D * w
end


"""
    successor(system::NoisyConstrainedAffineControlDiscreteSystem, x::AbstractVector,
              u::AbstractVector; [check_constraints]=true)

Return the successor state of a `NoisyConstrainedAffineControlDiscreteSystem`.

### Input

- `system`            -- `NoisyConstrainedAffineControlDiscreteSystem`
- `x`                 -- state (it should be any vector type)
- `u`                 -- input (it should be any vector type)
- `w`                 -- noise (it should be any vector type)
- `check_constraints` -- (optional, default: `true`) check if the state (resp. input)
                         belongs to the state set (resp. input set)

### Output

The result of applying the system to `x`, with input `u`.
"""
function successor(system::NoisyConstrainedAffineControlDiscreteSystem,
                   x::AbstractVector, u::AbstractVector, w::AbstractVector;
                   check_constraints::Bool=true)
    !_is_conformable_state(system, x) && _argument_error(:x)
    !_is_conformable_input(system, u) && _argument_error(:u)
    !_is_conformable_noise(system, w) && _argument_error(:w)
    if check_constraints
        !_in_stateset(system, x) && _argument_error(:x,:X)
        !_in_inputset(system, u) && _argument_error(:u,:U)
        !_in_noiseset(system, w) && _argument_error(:w,:W)
    end
    return system.A * x + system.B * u + system.c + system.D * w
end

"""
    successor(system::NoisyConstrainedBlackBoxControlDiscreteSystem, x::AbstractVector,
              u::AbstractVector, w::AbstractVector; [check_constraints]=true)

Return the successor state of a `NoisyConstrainedBlackBoxControlDiscreteSystem`.

### Input

- `system`            -- `NoisyConstrainedBlackBoxControlDiscreteSystem`
- `x`                 -- state (it should be any vector type)
- `u`                 -- input (it should be any vector type)
- `w`                 -- noise (it should be any vector type)
- `check_constraints` -- (optional, default: `true`) check if the state belongs to
                         the state set

### Output

The result of applying the system to `x`.
"""
function successor(system::NoisyConstrainedBlackBoxControlDiscreteSystem,
                   x::AbstractVector, u::AbstractVector, w::AbstractVector; check_constraints::Bool=true)
    !_is_conformable_state(system, x) && _argument_error(:x)
    !_is_conformable_input(system, u) && _argument_error(:u)
    !_is_conformable_noise(system, w) && _argument_error(:w)
    if check_constraints
        !_in_stateset(system, x) && _argument_error(:x,:X)
        !_in_inputset(system, u) && _argument_error(:u,:U)
        !_in_noiseset(system, w) && _argument_error(:w,:W)
    end
    return system.f(x, u, w)
end
