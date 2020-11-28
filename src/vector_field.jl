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

function _position_value_list(V::VectorField, x, y)
    x1 = x[1]
    y1 = y[1]
    N_POS = typeof(x1)
    N_VAL = typeof(V([x1, y1])[1])
    m = length(x) * length(y)

    sx = Vector{N_POS}(undef, m)
    sy = similar(sx)
    tx = Vector{N_VAL}(undef, m)
    ty = similar(tx)
    k = 1
    max_entry = N_VAL(-Inf)
    for xi in x
        for yj in y
            sx[k] = xi
            sy[k] = yj
            tx_k, ty_k = V([xi, yj])
            max_entry = max(max_entry, abs(tx_k), abs(ty_k))
            tx[k] = tx_k
            ty[k] = ty_k
            k += 1
        end
    end

    # normalize
    if max_entry > zero(N_VAL)
        step_x = (maximum(x) - minimum(x)) / length(x)
        step_y = (maximum(y) - minimum(y)) / length(y)
        max_entry_x = max_entry / step_x
        max_entry_y = max_entry / step_y
        for k in 1:m
            tx[k] /= max_entry_x
            ty[k] /= max_entry_y
        end
    end

    # filter out (0, 0) entries
    for k in m:-1:1
        if tx[k] == ty[k] == zero(N_VAL)
            deleteat!(sx, k)
            deleteat!(sy, k)
            deleteat!(tx, k)
            deleteat!(ty, k)
        end
    end

    # center arrows in the grid points
    for k in 1:length(sx)
        sx[k] -= tx[k] / 2
        sy[k] -= ty[k] / 2
    end

    return sx, sy, tx, ty
end

### plot recipe
@recipe function plot(V::VectorField;
                      x=range(-3, stop=3, length=21),
                      y=range(-3, stop=3, length=21))
    seriestype := :quiver

    sx, sy, tx, ty = _position_value_list(V, x, y)
    quiver := (tx, ty)

    (sx, sy)
end
