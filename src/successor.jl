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
    @assert statedim(system) == length(x)
    return x
end

"""
    successor(system::ConstrainedDiscreteIdentitySystem, x::AbstractVector)

Return the successor state of a `ConstrainedDiscreteIdentitySystem`.

### Input

- `system` -- `ConstrainedDiscreteIdentitySystem`
- `x`      -- state (it should be any vector type)

### Output

The same state `x`.
"""
function successor(system::ConstrainedDiscreteIdentitySystem, x::AbstractVector)
    @assert statedim(system) == length(x)
    @assert x ∈ stateset(system)
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
    @assert statedim(system) == length(x)
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
    @assert statedim(system) == length(x)
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
    @assert statedim(system) == length(x)
    @assert inputdim(system) == length(u)
    return system.A * x + system.B * u
end

"""
    successor(system::ConstrainedLinearDiscreteSystem, x::AbstractVector)

Return the successor state of a `ConstrainedLinearDiscreteSystem`.

### Input

- `system` -- `ConstrainedLinearDiscreteSystem`
- `x`      -- state (it should be any vector type)

### Output

The result of applying the system to `x`.
"""
function successor(system::ConstrainedLinearDiscreteSystem, x::AbstractVector)
    @assert statedim(system) == length(x)
    @assert x ∈ stateset(system)
    return system.A * x
end

"""
    successor(system::ConstrainedAffineDiscreteSystem, x::AbstractVector)

Return the successor state of a `ConstrainedAffineDiscreteSystem`.

### Input

- `system` -- `ConstrainedAffineDiscreteSystem`
- `x`      -- state (it should be any vector type)

### Output

The result of applying the system to `x`.
"""
function successor(system::ConstrainedAffineDiscreteSystem, x)
    @assert statedim(system) == length(x)
    @assert x ∈ stateset(system)
    return system.A * x + system.b
end

"""
    successor(system::ConstrainedLinearControlDiscreteSystem, x::AbstractVector, u::AbstractVector)

Return the successor state of a `ConstrainedLinearControlDiscreteSystem`.

### Input

- `system` -- `ConstrainedLinearControlDiscreteSystem`
- `x`      -- state (it should be any vector type)
- `u`      -- input (it should be any vector type)

### Output

The result of applying the system to `x`, with input `u`.
"""
function successor(system::ConstrainedLinearControlDiscreteSystem, x::AbstractVector, u::AbstractVector)
    @assert statedim(system) == length(x)
    @assert x ∈ stateset(system)
    @assert inputdim(system) == length(u)
    @assert u ∈ inputset(system)
    return system.A * x + system.B * u
end

"""
    successor(system::ConstrainedAffineControlDiscreteSystem, x::AbstractVector, u::AbstractVector)

Return the successor state of a `ConstrainedAffineControlDiscreteSystem`.

### Input

- `system` -- `ConstrainedAffineControlDiscreteSystem`
- `x`      -- state (it should be any vector type)
- `u`      -- input (it should be any vector type)

### Output

The result of applying the system to `x`, with input `u`.
"""
function successor(system::ConstrainedAffineControlDiscreteSystem, x::AbstractVector, u::AbstractVector)
    @assert statedim(system) == length(x)
    @assert x ∈ stateset(system)
    @assert inputdim(system) == length(u)
    @assert u ∈ inputset(system)
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
    @assert statedim(system) == length(x)
    return system.f(x)
end

"""
    successor(system::ConstrainedBlackBoxDiscreteSystem, x::AbstractVector)

Return the successor state of a `ConstrainedBlackBoxDiscreteSystem`.

### Input

- `system` -- `ConstrainedBlackBoxDiscreteSystem`
- `x`      -- state (it should be any vector type)

### Output

The result of applying the system to `x`.
"""
function successor(system::ConstrainedBlackBoxDiscreteSystem, x::AbstractVector)
    @assert statedim(system) == length(x)
    @assert x ∈ stateset(system)
    return system.f(x)
end
