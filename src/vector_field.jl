# =============================
# Vector Field for continuous system
# =============================

"""
    vector_field(system::ContinuousIdentitySystem, x::AbstractVector)

Return the vector field state of a `ContinuousIdentitySystem`.

### Input

- `system` -- `ContinuousIdentitySystem`
- `x`      -- state (it should be any vector type)

### Output

A zeros vector of dimension `statedim`.
"""
function vector_field(system::ContinuousIdentitySystem, x::AbstractVector)
    !_is_conformable_state(system, x) && _argument_error(:x)
    return zeros(statedim(system))
end

"""
    vector_field(system::ConstrainedContinuousIdentitySystem, x::AbstractVector;
              [check_constraints]=true)

Return the vector field state of a `ConstrainedContinuousIdentitySystem`.

### Input

- `system`            -- `ConstrainedContinuousIdentitySystem`
- `x`                 -- state (it should be any vector type)
- `check_constraints` -- (optional, default: `true`) check if the state belongs to
                         the state set

### Output

A zeros vector of dimension `statedim`.
"""
function vector_field(system::ConstrainedContinuousIdentitySystem, x::AbstractVector;
                   check_constraints::Bool=true)
    !_is_conformable_state(system, x) && _argument_error(:x)
    if check_constraints
        !_in_stateset(system, x) && _argument_error(:x,:X)
    end
    return zeros(statedim(system))
end

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
