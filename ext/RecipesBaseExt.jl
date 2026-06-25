module RecipesBaseExt

using MathematicalSystems: VectorField

using RecipesBase: @recipe

### plot recipe
# arguments:
# - grid_points: pair containing the x and y coordinates of the grid points
#   example: the pair `([-1, 0, 1], [2, 3])` represents the grid of points
#   `[-1, 2], [0, 2], [1, 2], [-1, 3], [0, 3], [1, 3]`
# - dims: the two dimensions to plot
@recipe function plot(V::VectorField;  # COV_EXCL_LINE
                      grid_points=[range(-3; stop=3, length=21),
                                   range(-3; stop=3, length=21)],
                      dims=[1, 2])
    seriestype := :quiver

    x, y, vx, vy = _position_value_list(V, grid_points, dims[1], dims[2])
    quiver := (vx, vy)

    return (x, y)
end

function _position_value_list(V::VectorField, grid, dimx, dimy)
    X, Y = grid
    x1 = X[1]
    y1 = Y[1]
    N_POS = typeof(x1)
    N_VAL = typeof(V([x1, y1])[dimx])
    m = length(X) * length(Y)

    x = Vector{N_POS}(undef, m)  # x coordinates of each point
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
    for k in eachindex(x)
        x[k] -= vx[k] / 2
        y[k] -= vy[k] / 2
    end

    return x, y, vx, vy
end

end  # module
