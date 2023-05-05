"""
    IdentityMultiple{T} < AbstractMatrix{T} where T

A scalar multiple of the identity matrix of given order and numeric type.

### Fields

- `M` -- uniform scaling operator of type `T`
- `n` -- size of the identity matrix

### Notes

This type can be used to create multiples of the identity of given size. Since
only the multiple and the order are stored, the allocations are minimal.

Internally, the type wraps Julia's lazy multiple of the identity operator,
`UniformScaling`. `IdentityMultiple` subtypes `AbstractMatix`, hence it can be
used in usual matrix arithmetic and for dispatch on `AbstractMatrix`.

The difference between `UniformScaling` and `IdentityMultiple` is that while the
size of the former is generic, the size of the latter is fixed.

### Examples

Only specifying the matrix size represents an identity matrix:

```jldoctest identitymultiple
julia> using MathematicalSystems: IdentityMultiple

julia> I2 = Id(2)
IdentityMultiple{Float64} of value 1.0 and order 2

julia> I2 + I2
IdentityMultiple{Float64} of value 2.0 and order 2

julia> 4*I2
IdentityMultiple{Float64} of value 4.0 and order 2
```

The scaling (default `1.0`) can be passed as the second argument:

```jldoctest identitymultiple
julia> I2r = Id(2, 1//1)
IdentityMultiple{Rational{Int64}} of value 1//1 and order 2

julia> I2r + I2r
IdentityMultiple{Rational{Int64}} of value 2//1 and order 2

julia> 4*I2r
IdentityMultiple{Rational{Int64}} of value 4//1 and order 2
```

Alternatively, use the constructor passing the `UniformScaling` (`I`):

```jldoctest identitymultiple
julia> using LinearAlgebra

julia> I2 = IdentityMultiple(2.0*I, 2)
IdentityMultiple{Float64} of value 2.0 and order 2

julia> I2r = IdentityMultiple(2//1*I, 2)
IdentityMultiple{Rational{Int64}} of value 2//1 and order 2
```
"""
struct IdentityMultiple{T} <: AbstractMatrix{T}
    M::UniformScaling{T}
    n::Int
    function IdentityMultiple(M::UniformScaling{T}, n::Int) where {T}
        begin
            (n < 1) &&
                throw(ArgumentError("the dimension of `IdentityMultiple` cannot be negative or zero"))
            return new{T}(M, n)
        end
    end
end

Base.IndexStyle(::Type{<:IdentityMultiple}) = IndexLinear()
Base.size(𝐼::IdentityMultiple) = (𝐼.n, 𝐼.n)

function Base.getindex(𝐼::IdentityMultiple, inds...)
    any(idx -> idx > 𝐼.n, inds) && throw(BoundsError(𝐼, inds))
    return getindex(𝐼.M, inds...)
end

function Base.getindex(𝐼::IdentityMultiple{T}, ind) where {T}
    if 1 ≤ ind ≤ 𝐼.n^2
        return rem(ind - 1, 𝐼.n + 1) == 0 ? 𝐼.M.λ : zero(T)
    else
        throw(BoundsError(𝐼, ind))
    end
end

function Base.setindex!(𝐼::IdentityMultiple, X, inds...)
    return error("cannot store a value in an `IdentityMultiple` because this type is immutable")
end

Base.:(-)(𝐼::IdentityMultiple) = IdentityMultiple(-𝐼.M, 𝐼.n)
Base.:(+)(𝐼::IdentityMultiple, M::AbstractMatrix) = 𝐼.M + M
Base.:(+)(M::AbstractMatrix, 𝐼::IdentityMultiple) = M + 𝐼.M
Base.:(*)(x::Number, 𝐼::IdentityMultiple) = IdentityMultiple(x * 𝐼.M, 𝐼.n)
Base.:(*)(𝐼::IdentityMultiple, x::Number) = IdentityMultiple(x * 𝐼.M, 𝐼.n)
Base.:(/)(𝐼::IdentityMultiple, x::Number) = IdentityMultiple(𝐼.M / x, 𝐼.n)

function Base.:(*)(𝐼::IdentityMultiple, v::AbstractVector)
    @assert 𝐼.n == length(v)
    return 𝐼.M.λ * v
end

function Base.:(*)(𝐼::IdentityMultiple, A::AbstractMatrix)
    @assert 𝐼.n == size(A, 1)
    return 𝐼.M.λ * A
end

function Base.:(*)(A::AbstractMatrix, 𝐼::IdentityMultiple)
    @assert size(A, 2) == 𝐼.n
    return A * 𝐼.M.λ
end

# right-division
function Base.:(/)(A::AbstractMatrix, 𝐼::IdentityMultiple)
    @assert size(A, 2) == 𝐼.n
    return A * inv(𝐼.M.λ)
end

function Base.:(+)(𝐼1::IdentityMultiple, 𝐼2::IdentityMultiple)
    @assert 𝐼1.n == 𝐼2.n
    return IdentityMultiple(𝐼1.M + 𝐼2.M, 𝐼1.n)
end

function Base.:(-)(𝐼1::IdentityMultiple, 𝐼2::IdentityMultiple)
    @assert 𝐼1.n == 𝐼2.n
    return IdentityMultiple(𝐼1.M - 𝐼2.M, 𝐼1.n)
end

function Base.:(*)(𝐼1::IdentityMultiple, 𝐼2::IdentityMultiple)
    @assert 𝐼1.n == 𝐼2.n
    return IdentityMultiple(𝐼1.M * 𝐼2.M, 𝐼1.n)
end

function Base.:(*)(𝐼::IdentityMultiple{T}, U::UniformScaling{S}) where {T<:Number,S<:Number}
    return IdentityMultiple(𝐼.M.λ * U, 𝐼.n)
end

function Base.:(*)(U::UniformScaling{T}, 𝐼::IdentityMultiple{S}) where {T<:Number,S<:Number}
    return IdentityMultiple(𝐼.M.λ * U, 𝐼.n)
end

function Base.:(/)(𝐼::IdentityMultiple{T}, U::UniformScaling{S}) where {T<:Number,S<:Number}
    @assert !iszero(U.λ)
    return IdentityMultiple(𝐼.M * inv(U.λ), 𝐼.n)
end

function Base.:(/)(U::UniformScaling{T}, 𝐼::IdentityMultiple{S}) where {T<:Number,S<:Number}
    @assert !iszero(𝐼.M.λ)
    return IdentityMultiple(U * inv(𝐼.M.λ), 𝐼.n)
end

function Base.show(io::IO, ::MIME"text/plain", 𝐼::IdentityMultiple{T}) where {T}
    return print(io, "$(typeof(𝐼)) of value $(𝐼.M.λ) and order $(𝐼.n)")
end

"""
    Id(n::Int, [λ]::Number=1.0)

Convenience constructor of an [`IdentityMultiple`](@ref).

### Input

- `n` -- dimension
- `λ` -- (optional; default: `1.0`) scaling factor

### Output

An `IdentityMultiple` of the given size and scaling factor.
"""
function Id(n::Int, λ::Number=1.0)
    return IdentityMultiple(λ * I, n)
end

# callable identity matrix given the scaling factor and the size
IdentityMultiple(λ::Number, n::Int) = IdentityMultiple(λ * I, n)

function LinearAlgebra.Hermitian(𝐼::IdentityMultiple)
    return Hermitian(Diagonal(fill(𝐼.M.λ, 𝐼.n)))
end

Base.exp(𝐼::IdentityMultiple) = IdentityMultiple(exp(𝐼.M.λ), 𝐼.n)
