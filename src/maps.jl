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
function statedim(m::IdentityMap)
    return m.dim
end
function outputdim(m::IdentityMap)
    return m.dim
end
function inputdim(::IdentityMap)
    return 0
end
function state_matrix(m::IdentityMap)
    return Id(m.dim)
end
function islinear(::IdentityMap)
    return true
end
function isaffine(::IdentityMap)
    return true
end
function apply(::IdentityMap, x)
    return x
end

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
function statedim(m::ConstrainedIdentityMap)
    return m.dim
end
function stateset(m::ConstrainedIdentityMap)
    return m.X
end
function outputdim(m::ConstrainedIdentityMap)
    return m.dim
end
function inputdim(::ConstrainedIdentityMap)
    return 0
end
function state_matrix(m::ConstrainedIdentityMap)
    return Id(m.dim)
end
function islinear(::ConstrainedIdentityMap)
    return true
end
function isaffine(::ConstrainedIdentityMap)
    return true
end
function apply(::ConstrainedIdentityMap, x)
    return x
end

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
function statedim(m::LinearMap)
    return size(m.A, 2)
end
function outputdim(m::LinearMap)
    return size(m.A, 1)
end
function inputdim(::LinearMap)
    return 0
end
function state_matrix(m::LinearMap)
    return m.A
end
function islinear(::LinearMap)
    return true
end
function isaffine(::LinearMap)
    return true
end
function apply(m::LinearMap, x)
    return m.A * x
end

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
function statedim(m::ConstrainedLinearMap)
    return size(m.A, 2)
end
function stateset(m::ConstrainedLinearMap)
    return m.X
end
function outputdim(m::ConstrainedLinearMap)
    return size(m.A, 1)
end
function inputdim(::ConstrainedLinearMap)
    return 0
end
function state_matrix(m::ConstrainedLinearMap)
    return m.A
end
function islinear(::ConstrainedLinearMap)
    return true
end
function isaffine(::ConstrainedLinearMap)
    return true
end
function apply(m::ConstrainedLinearMap, x)
    return m.A * x
end

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
        size(A, 1) != length(c) && throw(DimensionMismatch("incompatible dimensions"))
        return new{T,MT,VT}(A, c)
    end
end
function statedim(m::AffineMap)
    return size(m.A, 2)
end
function outputdim(m::AffineMap)
    return length(m.c)
end
function inputdim(::AffineMap)
    return 0
end
function state_matrix(m::AffineMap)
    return m.A
end
function affine_term(m::AffineMap)
    return m.c
end
function islinear(::AffineMap)
    return false
end
function isaffine(::AffineMap)
    return true
end
function apply(m::AffineMap, x)
    return m.A * x + m.c
end

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
        size(A, 1) != length(c) && throw(DimensionMismatch("incompatible dimensions"))
        return new{T,MT,VT,ST}(A, c, X)
    end
end
function statedim(m::ConstrainedAffineMap)
    return size(m.A, 2)
end
function stateset(m::ConstrainedAffineMap)
    return m.X
end
function outputdim(m::ConstrainedAffineMap)
    return length(m.c)
end
function inputdim(::ConstrainedAffineMap)
    return 0
end
function state_matrix(m::ConstrainedAffineMap)
    return m.A
end
function affine_term(m::ConstrainedAffineMap)
    return m.c
end
function islinear(::ConstrainedAffineMap)
    return false
end
function isaffine(::ConstrainedAffineMap)
    return true
end
function apply(m::ConstrainedAffineMap, x)
    return m.A * x + m.c
end

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
        size(A, 1) != size(B, 1) && throw(DimensionMismatch("incompatible dimensions"))
        return new{T,MTA,MTB}(A, B)
    end
end
function statedim(m::LinearControlMap)
    return size(m.A, 2)
end
function inputdim(m::LinearControlMap)
    return size(m.B, 2)
end
function outputdim(m::LinearControlMap)
    return size(m.A, 1)
end
function state_matrix(m::LinearControlMap)
    return m.A
end
function input_matrix(m::LinearControlMap)
    return m.B
end
function islinear(::LinearControlMap)
    return true
end
function isaffine(::LinearControlMap)
    return true
end
function apply(m::LinearControlMap, x, u)
    return m.A * x + m.B * u
end

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
        size(A, 1) != size(B, 1) && throw(DimensionMismatch("incompatible dimensions"))
        return new{T,MTA,MTB,ST,UT}(A, B, X, U)
    end
end
function statedim(m::ConstrainedLinearControlMap)
    return size(m.A, 2)
end
function stateset(m::ConstrainedLinearControlMap)
    return m.X
end
function outputdim(m::ConstrainedLinearControlMap)
    return size(m.A, 1)
end
function inputdim(m::ConstrainedLinearControlMap)
    return size(m.B, 2)
end
function inputset(m::ConstrainedLinearControlMap)
    return m.U
end
function state_matrix(m::ConstrainedLinearControlMap)
    return m.A
end
function input_matrix(m::ConstrainedLinearControlMap)
    return m.B
end
function islinear(::ConstrainedLinearControlMap)
    return true
end
function isaffine(::ConstrainedLinearControlMap)
    return true
end
function apply(m::ConstrainedLinearControlMap, x, u)
    return m.A * x + m.B * u
end

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
        if !(size(A, 1) == size(B, 1) == length(c))
            throw(DimensionMismatch("incompatible dimensions"))
        end
        return new{T,MTA,MTB,VT}(A, B, c)
    end
end
function statedim(m::AffineControlMap)
    return size(m.A, 2)
end
function outputdim(m::AffineControlMap)
    return size(m.A, 1)
end
function inputdim(m::AffineControlMap)
    return size(m.B, 2)
end
function state_matrix(m::AffineControlMap)
    return m.A
end
function input_matrix(m::AffineControlMap)
    return m.B
end
function affine_term(m::AffineControlMap)
    return m.c
end
function islinear(::AffineControlMap)
    return false
end
function isaffine(::AffineControlMap)
    return true
end
function apply(m::AffineControlMap, x, u)
    return m.A * x + m.B * u + m.c
end

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
        if !(size(A, 1) == size(B, 1) == length(c))
            throw(DimensionMismatch("incompatible dimensions"))
        end
        return new{T,MTA,MTB,VT,ST,UT}(A, B, c, X, U)
    end
end
function statedim(m::ConstrainedAffineControlMap)
    return size(m.A, 2)
end
function stateset(m::ConstrainedAffineControlMap)
    return m.X
end
function inputdim(m::ConstrainedAffineControlMap)
    return size(m.B, 2)
end
function inputset(m::ConstrainedAffineControlMap)
    return m.U
end
function outputdim(m::ConstrainedAffineControlMap)
    return size(m.A, 1)
end
function state_matrix(m::ConstrainedAffineControlMap)
    return m.A
end
function input_matrix(m::ConstrainedAffineControlMap)
    return m.B
end
function affine_term(m::ConstrainedAffineControlMap)
    return m.c
end
function islinear(::ConstrainedAffineControlMap)
    return false
end
function isaffine(::ConstrainedAffineControlMap)
    return true
end
function apply(m::ConstrainedAffineControlMap, x, u)
    return m.A * x + m.B * u + m.c
end

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
function statedim(m::ResetMap)
    return m.dim
end
function inputdim(::ResetMap)
    return 0
end
function outputdim(m::ResetMap)
    return m.dim
end
function state_matrix(m::ResetMap)
    return _state_matrix_resetmap(m.dim, m.dict)
end
function affine_term(m::ResetMap)
    return affine_term_resetmap(m.dim, m.dict)
end
function islinear(::ResetMap)
    return false
end
function isaffine(::ResetMap)
    return true
end

function _state_matrix_resetmap(dim, dict::Dict{Int,N}) where {N}
    v = ones(N, dim)
    @inbounds for i in keys(dict)
        v[i] = zero(N)
    end
    return Diagonal(v)
end

function affine_term_resetmap(dim, dict::Dict{Int,N}) where {N}
    b = sparsevec(Int[], N[], dim)
    @inbounds for (k, v) in dict
        b[k] = v
    end
    return b
end

# convenience constructor for a list of pairs instead of a dictionary
function ResetMap(dim::Int, args::Pair{Int}...)
    return ResetMap(dim, Dict(args))
end

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
function statedim(m::ConstrainedResetMap)
    return m.dim
end
function stateset(m::ConstrainedResetMap)
    return m.X
end
function inputdim(::ConstrainedResetMap)
    return 0
end
function outputdim(m::ConstrainedResetMap)
    return m.dim
end
function state_matrix(m::ConstrainedResetMap)
    return _state_matrix_resetmap(m.dim, m.dict)
end
function affine_term(m::ConstrainedResetMap)
    return affine_term_resetmap(m.dim, m.dict)
end
function islinear(::ConstrainedResetMap)
    return false
end
function isaffine(::ConstrainedResetMap)
    return true
end

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

function statedim(m::BlackBoxMap)
    return m.dim
end
function inputdim(::BlackBoxMap)
    return 0
end
function outputdim(m::BlackBoxMap)
    return m.output_dim
end
function islinear(::BlackBoxMap)
    return false
end
function isaffine(::BlackBoxMap)
    return false
end
function apply(m::BlackBoxMap, x)
    return m.h(x)
end

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

function statedim(m::ConstrainedBlackBoxMap)
    return m.dim
end
function stateset(m::ConstrainedBlackBoxMap)
    return m.X
end
function inputdim(::ConstrainedBlackBoxMap)
    return 0
end
function outputdim(m::ConstrainedBlackBoxMap)
    return m.output_dim
end
function islinear(::ConstrainedBlackBoxMap)
    return false
end
function isaffine(::ConstrainedBlackBoxMap)
    return false
end
function apply(m::ConstrainedBlackBoxMap, x)
    return m.h(x)
end

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

function statedim(m::BlackBoxControlMap)
    return m.dim
end
function inputdim(m::BlackBoxControlMap)
    return m.input_dim
end
function outputdim(m::BlackBoxControlMap)
    return m.output_dim
end
function islinear(::BlackBoxControlMap)
    return false
end
function isaffine(::BlackBoxControlMap)
    return false
end
function apply(m::BlackBoxControlMap, x, u)
    return m.h(x, u)
end

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

function statedim(m::ConstrainedBlackBoxControlMap)
    return m.dim
end
function stateset(m::ConstrainedBlackBoxControlMap)
    return m.X
end
function inputdim(m::ConstrainedBlackBoxControlMap)
    return m.input_dim
end
function inputset(m::ConstrainedBlackBoxControlMap)
    return m.U
end
function outputdim(m::ConstrainedBlackBoxControlMap)
    return m.output_dim
end
function islinear(::ConstrainedBlackBoxControlMap)
    return false
end
function isaffine(::ConstrainedBlackBoxControlMap)
    return false
end
function apply(m::ConstrainedBlackBoxControlMap, x, u)
    return m.h(x, u)
end
