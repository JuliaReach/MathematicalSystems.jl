"""
    IdentityMap

An identity map

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
apply(::IdentityMap, x) = x

"""
    ConstrainedIdentityMap

An identity map with state constraints of the form

```math
    x ↦ x, x ∈ \\mathcal{X}.
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
stateset(m::ConstrainedIdentityMap) = m.X
outputdim(m::ConstrainedIdentityMap) = m.dim
inputdim(::ConstrainedIdentityMap) = 0
islinear(::ConstrainedIdentityMap) = true
isaffine(::ConstrainedIdentityMap) = true
apply(::ConstrainedIdentityMap, x) = x

"""
    LinearMap

A linear map

```math
    x ↦ Ax
```

### Fields

- `A` -- matrix
"""
struct LinearMap{T,MT<:AbstractMatrix{T}} <: AbstractMap
    A::MT
end
statedim(m::LinearMap) = size(m.A, 2)
outputdim(m::LinearMap) = size(m.A, 1)
inputdim(::LinearMap) = 0
islinear(::LinearMap) = true
isaffine(::LinearMap) = true
apply(m::LinearMap, x) = m.A * x

"""
    ConstrainedLinearMap

A linear map with state constraints of the form

```math
    x ↦ Ax, x ∈ \\mathcal{X}.
```

### Fields

- `A` -- matrix
- `X` -- state constraints
"""
struct ConstrainedLinearMap{T,MT<:AbstractMatrix{T},ST} <: AbstractMap
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

An affine map

```math
    x ↦ Ax + c.
```

### Fields

- `A` -- matrix
- `c` -- vector
"""
struct AffineMap{T,MT<:AbstractMatrix{T},VT<:AbstractVector{T}} <: AbstractMap
    A::MT
    c::VT
    function AffineMap(A::MT, c::VT) where {T,MT<:AbstractMatrix{T},VT<:AbstractVector{T}}
        @assert size(A, 1) == length(c)
        return new{T,MT,VT}(A, c)
    end
end
statedim(m::AffineMap) = size(m.A, 2)
outputdim(m::AffineMap) = length(m.c)
inputdim(::AffineMap) = 0
islinear(::AffineMap) = false
isaffine(::AffineMap) = true
apply(m::AffineMap, x) = m.A * x + m.c

"""
    ConstrainedAffineMap

An affine map with state constraints of the form

```math
    x ↦ Ax + c, x ∈ \\mathcal{X}.
```

### Fields

- `A` -- matrix
- `c` -- vector
- `X` -- state constraints
"""
struct ConstrainedAffineMap{T,MT<:AbstractMatrix{T},VT<:AbstractVector{T},ST} <: AbstractMap
    A::MT
    c::VT
    X::ST
    function ConstrainedAffineMap(A::MT, c::VT,
                                  X::ST) where {T,MT<:AbstractMatrix{T},VT<:AbstractVector{T},ST}
        @assert size(A, 1) == length(c)
        return new{T,MT,VT,ST}(A, c, X)
    end
end
statedim(m::ConstrainedAffineMap) = size(m.A, 2)
stateset(m::ConstrainedAffineMap) = m.X
outputdim(m::ConstrainedAffineMap) = length(m.c)
inputdim(::ConstrainedAffineMap) = 0
islinear(::ConstrainedAffineMap) = false
isaffine(::ConstrainedAffineMap) = true
apply(m::ConstrainedAffineMap, x) = m.A * x + m.c

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
struct LinearControlMap{T,MTA<:AbstractMatrix{T},MTB<:AbstractMatrix{T}} <: AbstractMap
    A::MTA
    B::MTB
    function LinearControlMap(A::MTA,
                              B::MTB) where {T,MTA<:AbstractMatrix{T},MTB<:AbstractMatrix{T}}
        @assert size(A, 1) == size(B, 1)
        return new{T,MTA,MTB}(A, B)
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

A linear control map with state and input constraints

```math
    (x, u) ↦ Ax + Bu, x ∈ \\mathcal{X}, u ∈ \\mathcal{U}.
```

### Fields

- `A` -- matrix
- `B` -- matrix
- `X` -- state constraints
- `U` -- input constraints
"""
struct ConstrainedLinearControlMap{T,MTA<:AbstractMatrix{T},MTB<:AbstractMatrix{T},ST,UT} <:
       AbstractMap
    A::MTA
    B::MTB
    X::ST
    U::UT
    function ConstrainedLinearControlMap(A::MTA, B::MTB, X::ST,
                                         U::UT) where {T,MTA<:AbstractMatrix{T},
                                                       MTB<:AbstractMatrix{T},ST,UT}
        @assert size(A, 1) == size(B, 1)
        return new{T,MTA,MTB,ST,UT}(A, B, X, U)
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

An affine control map

```math
    (x, u) ↦ Ax + Bu + c.
```

### Fields

- `A` -- matrix
- `B` -- matrix
- `c` -- vector
"""
struct AffineControlMap{T,MTA<:AbstractMatrix{T},MTB<:AbstractMatrix{T},VT<:AbstractVector{T}} <:
       AbstractMap
    A::MTA
    B::MTB
    c::VT
    function AffineControlMap(A::MTA, B::MTB,
                              c::VT) where {T,MTA<:AbstractMatrix{T},MTB<:AbstractMatrix{T},
                                            VT<:AbstractVector{T}}
        @assert size(A, 1) == size(B, 1) == length(c)
        return new{T,MTA,MTB,VT}(A, B, c)
    end
end
statedim(m::AffineControlMap) = size(m.A, 2)
outputdim(m::AffineControlMap) = size(m.A, 1)
inputdim(m::AffineControlMap) = size(m.B, 2)
islinear(::AffineControlMap) = false
isaffine(::AffineControlMap) = true
apply(m::AffineControlMap, x, u) = m.A * x + m.B * u + m.c

"""
    ConstrainedAffineControlMap

An affine control map with state and input constraints

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
struct ConstrainedAffineControlMap{T,MTA<:AbstractMatrix{T},MTB<:AbstractMatrix{T},
                                   VT<:AbstractVector{T},ST,UT} <: AbstractMap
    A::MTA
    B::MTB
    c::VT
    X::ST
    U::UT
    function ConstrainedAffineControlMap(A::MTA, B::MTB, c::VT, X::ST,
                                         U::UT) where {T,MTA<:AbstractMatrix{T},
                                                       MTB<:AbstractMatrix{T},VT<:AbstractVector{T},
                                                       ST,UT}
        @assert size(A, 1) == size(B, 1) == length(c)
        return new{T,MTA,MTB,VT,ST,UT}(A, B, c, X, U)
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

A reset map

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
    dict::Dict{Int,N}
end
statedim(m::ResetMap) = m.dim
inputdim(::ResetMap) = 0
outputdim(m::ResetMap) = m.dim
islinear(::ResetMap) = false
isaffine(::ResetMap) = true

# convenience constructor for a list of pairs instead of a dictionary
ResetMap(dim::Int, args::Pair{Int}...) = ResetMap(dim, Dict(args))

"""
    ConstrainedResetMap

A reset map with state constraints of the form

```math
    x ↦ R(x), x ∈ \\mathcal{X},
```
such that the specified variables are assigned a given value, and the remaining
variables are unchanged.

### Fields

- `dim`  -- dimension
- `X`    -- state constraints
- `dict` -- dictionary whose keys are the indices of the variables that are
            reset, and whose values are the new values
"""
struct ConstrainedResetMap{N,ST} <: AbstractMap
    dim::Int
    X::ST
    dict::Dict{Int,N}
end
statedim(m::ConstrainedResetMap) = m.dim
stateset(m::ConstrainedResetMap) = m.X
inputdim(::ConstrainedResetMap) = 0
outputdim(m::ConstrainedResetMap) = m.dim
islinear(::ConstrainedResetMap) = false
isaffine(::ConstrainedResetMap) = true

# convenience constructor for a list of pairs instead of a dictionary
function ConstrainedResetMap(dim::Int, X, args::Pair{Int}...)
    return ConstrainedResetMap(dim, X, Dict(args))
end

function apply(m::Union{ResetMap,ConstrainedResetMap}, x)
    y = copy(x)
    for (index, value) in pairs(m.dict)
        y[index] = value
    end
    return y
end

"""
    BlackBoxMap

A black-box map of the form

```math
    x ↦ h(x).
```

### Fields

- `dim`  -- state dimension
- `output_dim` -- output dimension
- `h` -- output function
"""
struct BlackBoxMap{FT} <: AbstractMap
    dim::Int
    output_dim::Int
    h::FT
end

statedim(m::BlackBoxMap) = m.dim
inputdim(::BlackBoxMap) = 0
outputdim(m::BlackBoxMap) = m.output_dim
islinear(::BlackBoxMap) = false
isaffine(::BlackBoxMap) = false
apply(m::BlackBoxMap, x) = m.h(x)

"""
    ConstrainedBlackBoxMap

A constrained black-box map of the form

```math
    x ↦ h(x), x ∈ \\mathcal{X}.
```

### Fields

- `dim`  -- state dimension
- `output_dim` -- output dimension
- `h` -- output function
- `X` -- state constraints
"""
struct ConstrainedBlackBoxMap{FT,ST} <: AbstractMap
    dim::Int
    output_dim::Int
    h::FT
    X::ST
end

statedim(m::ConstrainedBlackBoxMap) = m.dim
stateset(m::ConstrainedBlackBoxMap) = m.X
inputdim(::ConstrainedBlackBoxMap) = 0
outputdim(m::ConstrainedBlackBoxMap) = m.output_dim
islinear(::ConstrainedBlackBoxMap) = false
isaffine(::ConstrainedBlackBoxMap) = false
apply(m::ConstrainedBlackBoxMap, x) = m.h(x)

"""
    BlackBoxControlMap

A black-box control map of the form

```math
    (x, u) ↦ h(x, u).
```

### Fields

- `dim`  -- state dimension
- `input_dim` -- input dimension
- `output_dim` -- output dimension
- `h` -- output function
"""
struct BlackBoxControlMap{FT} <: AbstractMap
    dim::Int
    input_dim::Int
    output_dim::Int
    h::FT
end

statedim(m::BlackBoxControlMap) = m.dim
inputdim(m::BlackBoxControlMap) = m.input_dim
outputdim(m::BlackBoxControlMap) = m.output_dim
islinear(::BlackBoxControlMap) = false
isaffine(::BlackBoxControlMap) = false
apply(m::BlackBoxControlMap, x, u) = m.h(x, u)

"""
    ConstrainedBlackBoxControlMap

A constrained black-box control map of the form

```math
    (x, u) ↦ h(x, u), x ∈ \\mathcal{X}, u ∈ \\mathcal{U}.
```

### Fields

- `dim`  -- state dimension
- `input_dim` -- input dimension
- `output_dim` -- output dimension
- `h` -- output function
- `X` -- state constraints
- `U` -- input constraints
"""
struct ConstrainedBlackBoxControlMap{FT,ST,UT} <: AbstractMap
    dim::Int
    input_dim::Int
    output_dim::Int
    h::FT
    X::ST
    U::UT
end

statedim(m::ConstrainedBlackBoxControlMap) = m.dim
stateset(m::ConstrainedBlackBoxControlMap) = m.X
inputdim(m::ConstrainedBlackBoxControlMap) = m.input_dim
inputset(m::ConstrainedBlackBoxControlMap) = m.U
outputdim(m::ConstrainedBlackBoxControlMap) = m.output_dim
islinear(::ConstrainedBlackBoxControlMap) = false
isaffine(::ConstrainedBlackBoxControlMap) = false
apply(m::ConstrainedBlackBoxControlMap, x, u) = m.h(x, u)
