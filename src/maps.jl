"""
    IdentityMap

An identity map
```math
x ↦ x
```

### Fields

- `dim` -- dimension
"""
struct IdentityMap <: AbstractMap
    dim::Int
end
outputdim(m::IdentityMap) = m.dim
islinear(::IdentityMap) = true
isaffine(::IdentityMap) = true
apply(m::IdentityMap, x) = x

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
islinear(::LinearMap) = true
isaffine(::LinearMap) = true
apply(m::LinearMap, x) = m.A * x

@static if VERSION < v"0.7-"
    LinearMap{T, MT <: AbstractMatrix{T}}(A::MT) = LinearMap{T, MT}(A)
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
outputdim(m::AffineMap) = length(m.b)
islinear(::AffineMap) = false
isaffine(::AffineMap) = true
apply(m::AffineMap, x) = m.A * x + m.b

"""
    LinearControlMap

A linear control map
```math
(x, u) ↦ Ax + Bu.
```

### Fields

- `A` -- matrix
- `B` -- matrix
"""
struct LinearControlMap{T, MTA<:AbstractMatrix{T}, MTB<:AbstractMatrix{T}} <: AbstractMap
    A::MTA
    B::MTB
    function LinearControlMap(A::MTA, B::MTB) where {T, MTA<:AbstractMatrix{T}, MTB<:AbstractMatrix{T}}
        @assert size(A, 1) == size(B, 1)
        return new{T, MTA, MTB}(A, B)
    end
end
outputdim(m::LinearControlMap) = size(m.A, 1)
islinear(::LinearControlMap) = true
isaffine(::LinearControlMap) = true
apply(m::LinearControlMap, x, u) = m.A * x + m.B * u

"""
    ConstrainedLinearControlMap

A linear control map with input constraints,
```math
(x, u) ↦ Ax + Bu, u ∈ \\mathcal{U}.
```

### Fields

- `A` -- matrix
- `B` -- matrix
- `U` -- input constraints
"""
struct ConstrainedLinearControlMap{T, MTA <: AbstractMatrix{T}, MTB <: AbstractMatrix{T}, UT} <: AbstractMap
    A::MTA
    B::MTB
    U::UT
    function ConstrainedLinearControlMap(A::MTA, B::MTB, U::UT) where {T, MTA<:AbstractMatrix{T}, MTB<:AbstractMatrix{T}, UT}
        @assert size(A, 1) == size(B, 1)
        return new{T, MTA, MTB, UT}(A, B, U)
    end
end
outputdim(m::ConstrainedLinearControlMap) = size(m.A, 1)
islinear(::ConstrainedLinearControlMap) = true
isaffine(::ConstrainedLinearControlMap) = true
apply(m::ConstrainedLinearControlMap, x, u) = m.A * x + m.B * u

"""
    AffineControlMap

An affine control map
```math
(x, u) ↦ Ax + Bu + c.
```

### Fields

- `A` -- matrix
- `B` -- matrix
- `c` -- vector
"""
struct AffineControlMap{T, MTA <: AbstractMatrix{T}, MTB <: AbstractMatrix{T}, VT<:AbstractVector{T}} <: AbstractMap
    A::MTA
    B::MTB
    c::VT
    function AffineControlMap(A::MTA, B::MTB, c::VT) where {T, MTA<:AbstractMatrix{T}, MTB<:AbstractMatrix{T}, VT<:AbstractVector{T}}
        @assert size(A, 1) == size(B, 1) == length(c)
        return new{T, MTA, MTB, VT}(A, B, c)
    end
end
outputdim(m::AffineControlMap) = size(m.A, 1)
islinear(::AffineControlMap) = false
isaffine(::AffineControlMap) = true
apply(m::AffineControlMap, x, u) = m.A * x + m.B * u + m.c

"""
    ConstrainedAffineControlMap

An affine control map with input constraints,
```math
(x, u) ↦ Ax + Bu + c, u ∈ \\mathcal{U}.
```

### Fields

- `A` -- matrix
- `B` -- matrix
- `c` -- vector
- `U` -- input constraints
"""
struct ConstrainedAffineControlMap{T, MTA<:AbstractMatrix{T}, MTB<:AbstractMatrix{T}, VT<:AbstractVector{T}, UT} <: AbstractMap
    A::MTA
    B::MTB
    c::VT
    U::UT
    function ConstrainedAffineControlMap(A::MTA, B::MTB, c::VT, U::UT) where {T, MTA<:AbstractMatrix{T}, MTB<:AbstractMatrix{T}, VT<:AbstractVector{T}, UT}
        @assert size(A, 1) == size(B, 1) == length(c)
        return new{T, MTA, MTB, VT, UT}(A, B, c, U)
    end
end
outputdim(m::ConstrainedAffineControlMap) = size(m.A, 1)
islinear(::ConstrainedAffineControlMap) = false
isaffine(::ConstrainedAffineControlMap) = true
apply(m::ConstrainedAffineControlMap, x, u) = m.A * x + m.B * u + m.c

"""
    ResetMap

A reset map 
```math
x ↦ R(x)
```
such that a subset of the variables is given a specified value, and the rest
are unchanged.

### Fields

- `dim`  -- dimension
- `dict` -- dictionary whose keys are the indices of the variables that are reset,
            and whose values are the new values
"""
struct ResetMap{N} <: AbstractMap
    dim::Int
    dict::Dict{Int, N}
end
outputdim(m::ResetMap) = m.dim
islinear(::ResetMap) = false
isaffine(::ResetMap) = true

ResetMap(dim::Int, args::Pair{Int, <:N}...) where {N} = ResetMap(dim, Dict{Int, N}(args))

function apply(m::ResetMap, x)
    y = copy(x)
    for (index, value) in pairs(m.dict)
        y[index] = value
    end
    return y
end
