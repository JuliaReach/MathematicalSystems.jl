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

function _position_value_list(V::VectorField, grid, dimx, dimy)
    X, Y = grid
    x1 = X[1]
    y1 = Y[1]
    N_POS = typeof(x1)
    N_VAL = typeof(V([x1, y1])[dimx])
    m = length(X) * length(Y)

    x = Vector{N_POS}(undef, m)  # x coordinates of each 
    y = similar(x)
    vx = Vector{N_VAL}(undef, m)
    vy = similar(vx)
    k = 1
    max_entry = N_VAL(-Inf)
    for xi in X
        for yj in Y
            x[k] = xi
            y[k] = yj
            val = V([xi, yj])
            vx_k = val[dimx]
            vy_k = val[dimy]
            max_entry = max(max_entry, abs(vx_k), abs(vy_k))
            vx[k] = vx_k
            vy[k] = vy_k
            k += 1
        end
    end

    # normalize
    if max_entry > zero(N_VAL)
        step_x = (maximum(X) - minimum(X)) / length(X)
        step_y = (maximum(Y) - minimum(Y)) / length(Y)
        max_entry_x = max_entry / step_x
        max_entry_y = max_entry / step_y
        max_entry = max(max_entry_x, max_entry_y)
        for k in 1:m
            vx[k] /= max_entry
            vy[k] /= max_entry
        end
    end

    # filter out (0, 0) entries
    for k in m:-1:1
        if vx[k] == vy[k] == zero(N_VAL)
            deleteat!(x, k)
            deleteat!(y, k)
            deleteat!(vx, k)
            deleteat!(vy, k)
        end
    end

    # center arrows in the grid points
    for k in 1:length(x)
        x[k] -= vx[k] / 2
        y[k] -= vy[k] / 2
    end

    return x, y, vx, vy
end

### plot recipe
# arguments:
# - grid_points: pair containing the x and y coordinates of the grid points
#   example: the pair `([-1, 0, 1], [2, 3])` represents the grid of points
#   `[-1, 2], [0, 2], [1, 2], [-1, 3], [0, 3], [1, 3]`
# - dims: the two dimensions to plot
@recipe function plot(V::VectorField;
                      grid_points=[range(-3, stop=3, length=21),
                                   range(-3, stop=3, length=21)],
                      dims=[1, 2])
    seriestype := :quiver

    x, y, vx, vy = _position_value_list(V, grid_points, dims[1], dims[2])
    quiver := (vx, vy)

    (x, y)
end
