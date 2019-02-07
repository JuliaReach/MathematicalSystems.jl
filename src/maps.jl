"""
    IdentityMap

An identity map,

```math
    x ↦ x.
```

### Fields

- `dim` -- dimension
"""
struct IdentityMap <: AbstractMap
    dim::Int
end
statedim(m::IdentityMap) = m.dim
outputdim(m::IdentityMap) = m.dim
inputdim(::IdentityMap) = 0
islinear(::IdentityMap) = true
isaffine(::IdentityMap) = true
apply(m::IdentityMap, x) = x

"""
    ConstrainedIdentityMap

An identity map with state constraints of the form:

```math
    x ↦ x, x(t) ∈ \\mathcal{X}.
```

### Fields

- `dim` -- dimension
- `X`   -- state constraints
"""
struct ConstrainedIdentityMap{ST} <: AbstractMap
    dim::Int
    X::ST
end
statedim(m::ConstrainedIdentityMap) = m.dim
outputdim(m::ConstrainedIdentityMap) = m.dim
inputdim(::ConstrainedIdentityMap) = 0
islinear(::ConstrainedIdentityMap) = true
isaffine(::ConstrainedIdentityMap) = true
apply(::ConstrainedIdentityMap, x) = x

"""
    LinearMap

A linear map,

```math
    x ↦ Ax
```

### Fields

- `A` -- matrix
"""
struct LinearMap{T, MT<:AbstractMatrix{T}} <: AbstractMap
    A::MT
end
statedim(m::LinearMap) = size(m.A, 2)
outputdim(m::LinearMap) = size(m.A, 1)
inputdim(::LinearMap) = 0
islinear(::LinearMap) = true
isaffine(::LinearMap) = true
apply(m::LinearMap, x) = m.A * x

@static if VERSION < v"0.7-"
    LinearMap{T, MT <: AbstractMatrix{T}}(A::MT) = LinearMap{T, MT}(A)
end

"""
    ConstrainedLinearMap

A linear map with state constraints of the form:

```math
    x ↦ Ax, x(t) ∈ \\mathcal{X}.
```

### Fields

- `A` -- matrix
- `X` -- state constraints
"""
struct ConstrainedLinearMap{T, MT<:AbstractMatrix{T}, ST} <: AbstractMap
    A::MT
    X::ST
end
statedim(m::ConstrainedLinearMap) = size(m.A, 2)
stateset(m::ConstrainedLinearMap) = m.X
outputdim(m::ConstrainedLinearMap) = size(m.A, 1)
inputdim(::ConstrainedLinearMap) = 0
islinear(::ConstrainedLinearMap) = true
isaffine(::ConstrainedLinearMap) = true
apply(m::ConstrainedLinearMap, x) = m.A * x

"""
    AffineMap

An affine map,

```math
    x ↦ Ax + b.
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
statedim(m::AffineMap) = size(m.A, 2)
outputdim(m::AffineMap) = length(m.b)
inputdim(::AffineMap) = 0
islinear(::AffineMap) = false
isaffine(::AffineMap) = true
apply(m::AffineMap, x) = m.A * x + m.b

"""
    ConstrainedAffineMap

An affine map with state constraints of the form:

```math
    x ↦ Ax + b, x(t) ∈ \\mathcal{X}.
```

### Fields

- `A` -- matrix
- `b` -- vector
- `X` -- state constraints
"""
struct ConstrainedAffineMap{T, MT<:AbstractMatrix{T}, VT<:AbstractVector{T}, ST} <: AbstractMap
    A::MT
    b::VT
    X::ST
    function ConstrainedAffineMap(A::MT, b::VT, X::ST) where {T, MT<:AbstractMatrix{T}, VT<:AbstractVector{T}, ST}
        @assert size(A, 1) == length(b)
        return new{T, MT, VT, ST}(A, b, X)
    end
end
statedim(m::ConstrainedAffineMap) = size(m.A, 2)
stateset(m::ConstrainedAffineMap) = m.X
outputdim(m::ConstrainedAffineMap) = length(m.b)
inputdim(::ConstrainedAffineMap) = 0
islinear(::ConstrainedAffineMap) = false
isaffine(::ConstrainedAffineMap) = true
apply(m::ConstrainedAffineMap, x) = m.A * x + m.b

"""
    LinearControlMap

A linear control map,

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
statedim(m::LinearControlMap) = size(m.A, 2)
inputdim(m::LinearControlMap) = size(m.B, 2)
outputdim(m::LinearControlMap) = size(m.A, 1)
islinear(::LinearControlMap) = true
isaffine(::LinearControlMap) = true
apply(m::LinearControlMap, x, u) = m.A * x + m.B * u

"""
    ConstrainedLinearControlMap

A linear control map with state and input constraints,

```math
    (x, u) ↦ Ax + Bu, x ∈ \\mathcal{X}, u ∈ \\mathcal{U}.
```

### Fields

- `A` -- matrix
- `B` -- matrix
- `X` -- state constraints
- `U` -- input constraints
"""
struct ConstrainedLinearControlMap{T, MTA <: AbstractMatrix{T}, MTB <: AbstractMatrix{T}, ST, UT} <: AbstractMap
    A::MTA
    B::MTB
    X::ST
    U::UT
    function ConstrainedLinearControlMap(A::MTA, B::MTB, X::ST, U::UT) where {T, MTA<:AbstractMatrix{T}, MTB<:AbstractMatrix{T}, ST, UT}
        @assert size(A, 1) == size(B, 1)
        return new{T, MTA, MTB, ST, UT}(A, B, X, U)
    end
end
statedim(m::ConstrainedLinearControlMap) = size(m.A, 2)
stateset(m::ConstrainedLinearControlMap) = m.X
outputdim(m::ConstrainedLinearControlMap) = size(m.A, 1)
inputdim(m::ConstrainedLinearControlMap) = size(m.B, 2)
inputset(m::ConstrainedLinearControlMap) = m.U
islinear(::ConstrainedLinearControlMap) = true
isaffine(::ConstrainedLinearControlMap) = true
apply(m::ConstrainedLinearControlMap, x, u) = m.A * x + m.B * u

"""
    AffineControlMap

An affine control map,

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
statedim(m::AffineControlMap) = size(m.A, 2)
outputdim(m::AffineControlMap) = size(m.A, 1)
inputdim(m::LinearControlMap) = size(m.B, 1)
islinear(::AffineControlMap) = false
isaffine(::AffineControlMap) = true
apply(m::AffineControlMap, x, u) = m.A * x + m.B * u + m.c

"""
    ConstrainedAffineControlMap

An affine control map with state and input constraints,

```math
    (x, u) ↦ Ax + Bu + c, x ∈ \\mathcal{X}, u ∈ \\mathcal{U}.
```

### Fields

- `A` -- matrix
- `B` -- matrix
- `c` -- vector
- `X` -- state constraints
- `U` -- input constraints
"""
struct ConstrainedAffineControlMap{T, MTA<:AbstractMatrix{T}, MTB<:AbstractMatrix{T}, VT<:AbstractVector{T}, ST, UT} <: AbstractMap
    A::MTA
    B::MTB
    c::VT
    X::ST
    U::UT
    function ConstrainedAffineControlMap(A::MTA, B::MTB, c::VT, X::ST, U::UT) where {T, MTA<:AbstractMatrix{T}, MTB<:AbstractMatrix{T}, VT<:AbstractVector{T}, ST, UT}
        @assert size(A, 1) == size(B, 1) == length(c)
        return new{T, MTA, MTB, VT, ST, UT}(A, B, c, X, U)
    end
end
statedim(m::ConstrainedAffineControlMap) = size(m.A, 2)
stateset(m::ConstrainedAffineControlMap) = m.X
inputdim(m::ConstrainedAffineControlMap) = size(m.B, 2)
inputset(m::ConstrainedAffineControlMap) = m.U
outputdim(m::ConstrainedAffineControlMap) = size(m.A, 1)
islinear(::ConstrainedAffineControlMap) = false
isaffine(::ConstrainedAffineControlMap) = true
apply(m::ConstrainedAffineControlMap, x, u) = m.A * x + m.B * u + m.c

"""
    ResetMap

A reset map,

```math
    x ↦ R(x),
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
inputdim(m::ResetMap) = m.dim
outputdim(m::ResetMap) = m.dim
islinear(::ResetMap) = false
isaffine(::ResetMap) = true

# convenience constructor for a list of pairs instead of a dictionary
ResetMap(dim::Int, args::Pair{Int, <:N}...) where {N} = ResetMap(dim, Dict{Int, N}(args))

function apply(m::ResetMap, x)
    y = copy(x)
    for (index, value) in pairs(m.dict)
        y[index] = value
    end
    return y
end
