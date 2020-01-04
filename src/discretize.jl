using LinearAlgebra: inv, rank
using SparseArrays: spzeros

"""
    typename(system::AbstractSystem)

Returns the base type of `system` without parameter information.

### Input

- `system` -- `AbstractSystem`

### Output

Returns base-type of `system`.

"""
function typename(system::AbstractSystem)
    return Base.typename(typeof(system)).wrapper
end

"""
    _complementary_type(system_type::Type{<:AbstractSystem})

Return the complementary type of a system type `system_type`.

There are two main subclasses of abstract types continuous types and discrete
types. A complementary type of `system_type` has the same fields as `system_type`
but belongs to the other subclass, e.g. for a `LinearContinuousSystem` which is
a subtype of `AbstractContinuousSystem` and has the field `:A`, the subtype of
`AbstractDiscreteSystem` with the field `:A`, i.e.`LinearDiscreteSystem`,
is returned.

### Input

- `system_type` -- type of `AbstractSystem`

### Ouput

Return complementary type of `system_type`.

### Note
To get the `_complementary_type` of a `system<:AbstractSystem` use
`_complementary_type(typename(system))`.
"""
@generated function _complementary_type(type::Type{<:AbstractSystem})
    system_type = type.parameters[1]
    type_string = string(system_type)
    if supertype(system_type) == AbstractDiscreteSystem
        type_string = replace(type_string, "Discrete"=>"Continuous")
    elseif supertype(system_type) == AbstractContinuousSystem
        type_string = replace(type_string, "Continuous"=>"Discrete")
    else
        error("$system_type <: $(supertype(system_type)) is neither discrete nor continuous")
    end
    return Meta.parse(type_string)
end

"""
     discretize(system::AbstractContinuousSystem, ΔT::Real; algorithm=:default)

Discretization of a `isaffine` `AbstractContinuousSystem` to a
`AbstractDiscreteSystem` with sampling time `ΔT` using the exact
discretization algorithm if possible.

### Input

- `system` -- an affine continuous system
- `ΔT` -- sampling time
- `algorithm` -- (optional, default: `:default`) discretization algorithm

### Output

Returns a discretization of the input system `system` with sampling time `ΔT`.

### Algorithm

Consider a `NoisyAffineControlledContinuousSystem` with system dynamics
``x' = Ax + Bu + c + Du``.

If A is invertible:
The exact discretization is calculated by solving the integral for
``t = [t, t + ΔT]`` for a fixed input `u` and fixed noise realisation `w`.
The resulting discretization writes as
``x^+ = A^d x + B^d u + c^d  + D^d u`` where
``A^d = \\exp^{A \\cdot ΔT}``,
``B^d = A^{-1}(A^d - I)B``,
``c^d = A^{-1}(A^d - I)c`` and
``D^d = A^{-1}(A^d - I)D``.

If A is not invertible:
A first order approximation of the exact discretiziation, the euler
discretization, can be applied, which writes as ``x^+ = A^d x + B^d u + c^d + D^d u``
where  ``A^d = I + ΔT \\cdot A``, ``B^d = ΔT \\cdot B``,
``c^d = ΔT \\cdot c`` and ``D^d = ΔT \\cdot D``.

The algorithms described above are a well known results from the literature.
Consider [1] as a source for further information.

[1] https://en.wikipedia.org/wiki/Discretization
"""
function discretize(system::AbstractContinuousSystem, ΔT::Real; algorithm=:default)
    sets(x) = x ∈ [:X,:U,:W]
    matrices(x) = x ∈ [:A,:B,:b,:c,:D]

    if algorithm == :default
        if rank(system.A) == size(system.A, 1)
            # A is invertible, use exact discretizaion
            algorithm = :exact
        else
            # A is not invertible, use approximative discretizaion
            algorithm = :euler
        end
    end

    # get all fields from system
    fields = collect(fieldnames(typeof(system)))

    # get the fields of `system` that are parameter of the affine system dynamics
    # i.e., all fields that need to be discretized
    values_cont = [getfield(system, f) for f in filter(matrices, fields)]

    # compute discretized values of dynamics_params_c
    values_disc = _discretize(values_cont..., ΔT; algorithm=algorithm)

    # get the fields of `system` that are sets
    set_values = [getfield(system, f) for f in filter(sets, fields)]

    # get corresponding discrete type of `system`
    discrete_type = _complementary_type(typename(system))

    # build the new discrete type with the discretized and set values
    return discrete_type(values_disc..., set_values...)
end

"""
    _discretize(A::AbstractMatrix, B::AbstractMatrix, c::AbstractVector,
                D::AbstractMatrix, ΔT::Real; algorithm=:exact)

Implementation of the discretization algorithm used in `discretize` with sampling
time `ΔT` and discretization method `algorithm`.

See [`discretize`](@ref) for more details.

### Input

- `A` -- state matrix
- `B` -- input matrix
- `c` -- vector
- `D` -- noise matrix
- `ΔT` -- sampling time
- `algorithm` -- (optional, default: `:exact`) discretization algorithm

### Output

Returns a vector containing the discretized input arguments `A`, `B`, `c` and `D`.
"""
function _discretize(A::AbstractMatrix,
                     B::AbstractMatrix,
                     c::AbstractVector,
                     D::AbstractMatrix, ΔT::Real; algorithm=:exact)
    if algorithm == :exact
        A_d = exp(A*ΔT)
        Matr = inv(A)*(A_d - I)
        B_d = Matr*B
        c_d = Matr*c
        D_d = Matr*D
    elseif algorithm == :euler
        A_d = I + ΔT*A
        B_d = ΔT*B
        c_d = ΔT*c
        D_d = ΔT*D
    else
        error("discretization algorithm $algorithm is not known")
    end
    return [A_d, B_d, c_d, D_d]
end

"""
    _discretize(A::AbstractMatrix, ΔT::Real; algorithm=:exact)

Discretize the state matrix `A` with sampling time `ΔT` and discretization method
`algorithm`.

See [`discretize`](@ref) for more details.

### Input

- `A` -- state matrix
- `ΔT` -- sampling time
- `algorithm` -- (optional, default: `:exact`) discretization algorithm

### Output

Returns a vector containing the discretized input argument `A`.
"""
function _discretize(A::AbstractMatrix, ΔT::Real; algorithm=:exact)
    n = size(A,1)
    mzero = spzeros(n, n)
    vzero = spzeros(n)
    A_d, _, _, _ = _discretize(A, mzero, vzero, mzero, ΔT; algorithm=algorithm)
    return [A_d]
end

"""
    _discretize(A::AbstractMatrix,
                B::AbstractMatrix, ΔT::Real; algorithm=:exact)

Discretize the state matrix `A` and input or noise matrix `B` with sampling time
`ΔT` and discretization method `algorithm`.

See [`discretize`](@ref) for more details.

### Input

- `A` -- state matrix
- `B` -- input or noise matrix
- `ΔT` -- sampling time
- `algorithm` -- (optional, default: `:exact`) discretization algorithm

### Output

Returns a vector containing the discretized input arguments `A` and `B`.

### Note

This method signature with two arguments of type `AbstractMatrix` works both for
a noisy system with fields `(:A,:D)` and a controlled system with fields `(:A,:B)`.
"""
function _discretize(A::AbstractMatrix,
                     B::AbstractMatrix, ΔT::Real; algorithm=:exact)
    n = size(A,1)
    mzero = spzeros(n, n)
    vzero = spzeros(n)
    A_d, B_d, _, _ = _discretize(A, B, vzero, mzero, ΔT; algorithm=algorithm)
    return [A_d, B_d]
end

"""
    _discretize(A::AbstractMatrix,
                c::AbstractVector, ΔT::Real; algorithm=:exact)

Discretize the state matrix `A` and vector `c` with sampling time `ΔT` and
discretization method `algorithm`.

See [`discretize`](@ref) for more details.

### Input

- `A` -- state matrix
- `c` -- vector
- `ΔT` -- sampling time
- `algorithm` -- (optional, default: `:exact`) discretization algorithm

### Output

Returns a vector containing the discretized input arguments `A` and `c`.
"""
function _discretize(A::AbstractMatrix,
                     c::AbstractVector, ΔT::Real; algorithm=:exact)
    n = size(A,1)
    mzero = spzeros(n, n)
    A_d, _, c_d, _ = _discretize(A, mzero, c, mzero, ΔT; algorithm=algorithm)
    return [A_d, c_d]
end

"""
    _discretize(A::AbstractMatrix,
                B::AbstractMatrix,
                c::AbstractVector, ΔT::Real; algorithm=:exact)

Discretize the state matrix `A`, input matrix `B` and vector `c` with sampling
time `ΔT` and discretization method `algorithm`.

See [`discretize`](@ref) for more details.

### Input

- `A` -- state matrix
- `B` -- input matrix
- `c` -- vector
- `ΔT` -- sampling time
- `algorithm` -- (optional, default: `:exact`) discretization algorithm

### Output

Returns a vector containing the discretized input arguments `A`, `B` and `c`.
"""
function _discretize(A::AbstractMatrix,
                     B::AbstractMatrix,
                     c::AbstractVector, ΔT::Real; algorithm=:exact)
    n = size(A,1)
    mzero = spzeros(n, n)
    A_d, B_d, c_d, _ = _discretize(A, B, c, mzero, ΔT; algorithm=algorithm)
    return [A_d, B_d, c_d]
end

"""
    _discretize(A::AbstractMatrix,
                B::AbstractMatrix,
                D::AbstractMatrix, ΔT::Real; algorithm=:exact)

Discretize the state matrix `A`, input matrix `B` and noise matrix `C` with
sampling time `ΔT` and discretization method `algorithm`.

See [`discretize`](@ref) for more details.

### Input

- `A` -- state matrix
- `B` -- input matrix
- `D` -- noise matrix
- `ΔT` -- sampling time
- `algorithm` -- (optional, default: `:exact`) discretization algorithm

### Output

Returns a vector containing the discretized input arguments `A`, `B` and `D`.
"""
function _discretize(A::AbstractMatrix,
                     B::AbstractMatrix,
                     D::AbstractMatrix, ΔT::Real; algorithm=:exact)
    n = size(A,1)
    vzero = spzeros(n)
    A_d, B_d, _, D_d = _discretize(A, B, vzero, D, ΔT; algorithm=algorithm)
    return [A_d, B_d, D_d]
end
