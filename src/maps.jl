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
outputdim(m::LinearMap) = size(m.A, 1)

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
outputdim(m::AffineMap) = length(m.b)

"""
    LinearControlMap

A linear control map
```math
x ↦ Ax + Bu.
```

### Fields

- `A` -- matrix
- `B` -- matrix
"""
struct LinearControlMap{T, MT<:AbstractMatrix{T}} <: AbstractMap
    A::MT
    B::MT
    function LinearControlMap(A::MT, B::MT) where {T, MT<:AbstractMatrix{T}}
        @assert size(A, 1) == size(B, 1)
        return new{T, MT}(A, B)
    end
end
outputdim(m::LinearControlMap) = size(m.A, 1)

"""
    ConstrainedLinearControlMap

A linear control map with input constraints,
```math
x ↦ Ax + Bu, u ∈ \\mathcal{U}.
```

### Fields

- `A` -- matrix
- `B` -- matrix
- `U` -- input constraints
"""
struct ConstrainedLinearControlMap{T, MT<:AbstractMatrix{T}, UT} <: AbstractMap
    A::MT
    B::MT
    U::UT
    function ConstrainedLinearControlMap(A::MT, B::MT, U::UT) where {T, MT<:AbstractMatrix{T}, UT}
        @assert size(A, 1) == size(B, 1)
        return new{T, MT, UT}(A, B, U)
    end
end
outputdim(m::ConstrainedLinearControlMap) = size(m.A, 1)

"""
    AffineControlMap

An affine control map
```math
x ↦ Ax + Bu + c.
```

### Fields

- `A` -- matrix
- `B` -- matrix
- `c` -- vector
"""
struct AffineControlMap{T, MT<:AbstractMatrix{T}, VT<:AbstractVector{T}} <: AbstractMap
    A::MT
    B::MT
    c::VT
    function AffineControlMap(A::MT, B::MT, c::VT) where {T, MT<:AbstractMatrix{T}, VT<:AbstractVector{T}}
        @assert size(A, 1) == size(B, 1) == length(c)
        return new{T, MT, VT}(A, B, c)
    end
end
outputdim(m::AffineControlMap) = size(m.A, 1)

"""
    ConstrainedAffineControlMap

An affine control map with input constraints,
```math
x ↦ Ax + Bu + c, u ∈ \\mathcal{U}.
```

### Fields

- `A` -- matrix
- `B` -- matrix
- `c` -- vector
- `U` -- input constraints
"""
struct ConstrainedAffineControlMap{T, MT<:AbstractMatrix{T}, VT<:AbstractVector{T}, UT} <: AbstractMap
    A::MT
    B::MT
    c::VT
    U::UT
    function ConstrainedAffineControlMap(A::MT, B::MT, c::VT, U::UT) where {T, MT<:AbstractMatrix{T}, VT<:AbstractVector{T}, UT}
        @assert size(A, 1) == size(B, 1) == length(c)
        return new{T, MT, VT, UT}(A, B, c, U)
    end
end
outputdim(m::ConstrainedAffineControlMap) = size(m.A, 1)
