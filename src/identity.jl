"""
    IdentityMultiple{T} < AbstractMatrix{T} where T

A scalar multiple of the identity matrix of given order and numeric type.

### Fields

`M` -- uniform scaling operator of type `T`
`n` -- size of the identity matrix

### Notes

This is a wrapper type around Julia's lazy multiple of the identity operator,
`UniformScaling`, such that `IdentityMultiple` can be used where abstract matrix
is needed for dispatch. The difference between `UniformScaling` and a
`IdentityMultiple` is that while the size of the former is generic, the size of
the latter is fixed.
"""
struct IdentityMultiple{T} <: AbstractMatrix{T}
    M::UniformScaling{T}
    n::Int
end

Base.IndexStyle(::Type{<:IdentityMultiple}) = IndexLinear()
Base.size(𝐼::IdentityMultiple) = 𝐼.n
Base.getindex(𝐼::IdentityMultiple, inds...) = getindex(𝐼, inds...)
Base.setindex!(𝐼::IdentityMultiple, X, inds...) = error("cannot store a value in an `Identity`")

Base.:(*)(x::Number, 𝐼::IdentityMultiple) = IdentityMultiple(x * 𝐼.M, size(𝐼))

function Base.:(+)(𝐼1::IdentityMultiple, 𝐼2::IdentityMultiple)
    @assert size(𝐼1) == size(𝐼2)
    return IdentityMultiple(𝐼1.M + 𝐼2.M, size(𝐼1))
end

function Base.:(*)(𝐼1::IdentityMultiple, 𝐼2::IdentityMultiple)
    @assert size(𝐼1) == size(𝐼2)
    return IdentityMultiple(𝐼1.M * 𝐼2.M, size(𝐼1))
end

function Base.show(io::IO, ::MIME"text/plain", 𝐼::IdentityMultiple{T}) where T
    print(io, "Scalar multiple of the identity matrix of order $(𝐼.n):\n   ", 𝐼.M)
end
