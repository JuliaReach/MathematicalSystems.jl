"""
    LinearMap

A linear map
```math
x ↦ Ax
```

### Fields

- `A` -- matrix
"""
struct LinearMap{T, MT<:AbstractMatrix{T}} <: AbstractMap
    A::MT
end

"""
    AffineMap

An affine map
```math
x ↦ Ax + b
```

### Fields

- `A` -- matrix
- `b` -- vector
"""
struct AffineMap{T, MT<:AbstractMatrix{T}, VT<:AbstractVector{T}} <: AbstractMap
    A::MT
    b::VT
    function AffineMap(A::MT, b::VT) where {T, MT<:AbstractMatrix{T}, VT<:AbstractVector{T}}
        @assert size(A, 1) == length(b)
        return new{T, MT, VT}(A, b)
    end
end

"""
    LinearControlMap

A linear control map
```math
x ↦ Ax + Bu, u ∈ \\mathcal{U}.
```

### Fields

- `A` -- matrix
- `B` -- matrix
- `U` -- input constraints
"""
struct LinearControlMap{T, MT<:AbstractMatrix{T}, UT} <: AbstractMap
    A::MT
    B::MT
    U::UT
    function LinearControlMap(A::MT, B::MT, U::UT) where {T, MT<:AbstractMatrix{T}, UT}
        @assert size(A, 1) == size(B, 1)
        return new{T, MT, MT, UT}(A, B, U)
    end
end

"""
    AffineControlMap

An affine control map
```math
x ↦ Ax + Bu + c, u ∈ \\mathcal{U}.
```

### Fields

- `A` -- matrix
- `B` -- matrix
- `c` -- vector
- `U` -- input constraints
"""
struct AffineControlMap{T, MT<:AbstractMatrix{T}, VT<:AbstractVector{T}, UT} <: AbstractMap
    A::MT
    B::MT
    c::VT
    U::UT
    function AffineControlMap(A::MT, B::MT, c::VT, U::UT) where {T, MT<:AbstractMatrix{T}, VT<:AbstractVector{T}, UT}
        @assert size(A, 1) == size(B, 1) == length(c)
        return new{T, MT, MT, VT, UT}(A, B, c, U)
    end
end
