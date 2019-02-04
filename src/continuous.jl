import MultivariatePolynomials
import MultivariatePolynomials: AbstractPolynomialLike

"""
    ContinuousIdentitySystem <: AbstractContinuousSystem

Trivial identity continuous-time system of the form
```math
x' = 0.
```
"""
struct ContinuousIdentitySystem <: AbstractContinuousSystem
    statedim::Int
end
statedim(s::ContinuousIdentitySystem) = s.statedim
inputdim(s::ContinuousIdentitySystem) = 0
islinear(::ContinuousIdentitySystem) = true
isaffine(::ContinuousIdentitySystem) = true

"""
    ConstrainedContinuousIdentitySystem <: AbstractContinuousSystem

Trivial identity continuous-time system with state constraints of the form
```math
x' = 0, x(t) ∈ \\mathcal{X}.
```
"""
struct ConstrainedContinuousIdentitySystem{ST} <: AbstractContinuousSystem
    statedim::Int
    X::ST
end
statedim(s::ConstrainedContinuousIdentitySystem) = s.statedim
stateset(s::ConstrainedContinuousIdentitySystem) = s.X
inputdim(s::ConstrainedContinuousIdentitySystem) = 0
islinear(::ConstrainedContinuousIdentitySystem) = true
isaffine(::ConstrainedContinuousIdentitySystem) = true

"""
    LinearContinuousSystem

Continuous-time linear system of the form
```math
x' = A x.
```

### Fields

- `A` -- square matrix
"""
struct LinearContinuousSystem{T, MT <: AbstractMatrix{T}} <: AbstractContinuousSystem
    A::MT
end
@static if VERSION < v"0.7-"
    LinearContinuousSystem{T, MT <: AbstractMatrix{T}}(A::MT) = LinearContinuousSystem{T, MT}(A)
end
statedim(s::LinearContinuousSystem) = checksquare(s.A)
inputdim(s::LinearContinuousSystem) = 0
islinear(::LinearContinuousSystem) = true
isaffine(::LinearContinuousSystem) = true

"""
    AffineContinuousSystem

Continuous-time affine system of the form
```math
x' = A x + b.
```

### Fields

- `A` -- square matrix
- `b` -- vector
"""
struct AffineContinuousSystem{T, MT <: AbstractMatrix{T}, VT <: AbstractVector{T}} <: AbstractContinuousSystem
    A::MT
    b::VT
    function AffineContinuousSystem(A::MT, b::VT) where {T, MT <: AbstractMatrix{T}, VT <: AbstractVector{T}}
        @assert checksquare(A) == length(b)
        return new{T, MT, VT}(A, b)
    end
end
statedim(s::AffineContinuousSystem) = length(s.b)
inputdim(s::AffineContinuousSystem) = 0
islinear(::AffineContinuousSystem) = false
isaffine(::AffineContinuousSystem) = true

"""
    LinearControlContinuousSystem

Continuous-time linear control system of the form
```math
x' = A x + B u.
```

### Fields

- `A` -- square matrix
- `B` -- matrix
"""
struct LinearControlContinuousSystem{T, MTA <: AbstractMatrix{T}, MTB <: AbstractMatrix{T}} <: AbstractContinuousSystem
    A::MTA
    B::MTB
    function LinearControlContinuousSystem(A::MTA, B::MTB) where {T, MTA <: AbstractMatrix{T}, MTB <: AbstractMatrix{T}}
        @assert checksquare(A) == size(B, 1)
        return new{T, MTA, MTB}(A, B)
    end
end
statedim(s::LinearControlContinuousSystem) = checksquare(s.A)
inputdim(s::LinearControlContinuousSystem) = size(s.B, 2)
islinear(::LinearControlContinuousSystem) = true
isaffine(::LinearControlContinuousSystem) = true

"""
    ConstrainedLinearContinuousSystem

Continuous-time linear system with state constraints of the form
```math
x' = A x, x(t) ∈ \\mathcal{X}.
```

### Fields

- `A` -- square matrix
- `X` -- state constraints
"""
struct ConstrainedLinearContinuousSystem{T, MT <: AbstractMatrix{T}, ST} <: AbstractContinuousSystem
    A::MT
    X::ST
end
@static if VERSION < v"0.7-"
    ConstrainedLinearContinuousSystem{T, MT <: AbstractMatrix{T}, ST}(A::MT, X::ST) = ConstrainedLinearContinuousSystem{T, MT, ST}(A, X)
end
statedim(s::ConstrainedLinearContinuousSystem) = checksquare(s.A)
stateset(s::ConstrainedLinearContinuousSystem) = s.X
inputdim(s::ConstrainedLinearContinuousSystem) = 0
islinear(::ConstrainedLinearContinuousSystem) = true
isaffine(::ConstrainedLinearContinuousSystem) = true

"""
    ConstrainedAffineContinuousSystem

Continuous-time affine system with state constraints of the form
```math
x' = A x + b, x(t) ∈ \\mathcal{X}.
```

### Fields

- `A` -- square matrix
- `b` -- vector
- `X` -- state constraints
"""
struct ConstrainedAffineContinuousSystem{T, MT <: AbstractMatrix{T}, VT <: AbstractVector{T}, ST} <: AbstractContinuousSystem
    A::MT
    b::VT
    X::ST
    function ConstrainedAffineContinuousSystem(A::MT, b::VT, X::ST) where {T, MT <: AbstractMatrix{T}, VT <: AbstractVector{T}, ST}
        @assert checksquare(A) == length(b)
        return new{T, MT, VT, ST}(A, b, X)
    end
end
statedim(s::ConstrainedAffineContinuousSystem) = length(s.b)
stateset(s::ConstrainedAffineContinuousSystem) = s.X
inputdim(s::ConstrainedAffineContinuousSystem) = 0
islinear(::ConstrainedAffineContinuousSystem) = false
isaffine(::ConstrainedAffineContinuousSystem) = true

"""
    ConstrainedAffineControlContinuousSystem

Continuous-time affine control system with state constraints of the form
```math
x' = A x + B u + c, x(t) ∈ \\mathcal{X}, u(t) ∈ \\mathcal{U} \\text{ for all } t,
```
and ``c`` a vector.

### Fields

- `A` -- square matrix
- `B` -- matrix
- `c` -- vector
- `X` -- state constraints
- `U` -- input constraints
"""
struct ConstrainedAffineControlContinuousSystem{T, MTA <: AbstractMatrix{T}, MTB <: AbstractMatrix{T}, VT <: AbstractVector{T}, ST, UT} <: AbstractContinuousSystem
    A::MTA
    B::MTB
    c::VT
    X::ST
    U::UT
    function ConstrainedAffineControlContinuousSystem(A::MTA, B::MTB, c::VT, X::ST, U::UT) where {T, MTA <: AbstractMatrix{T}, MTB <: AbstractMatrix{T}, VT <: AbstractVector{T}, ST, UT}
        @assert checksquare(A) == length(c) == size(B, 1) 
        return new{T, MTA, MTB, VT, ST, UT}(A, B, c, X, U)
    end
end
statedim(s::ConstrainedAffineControlContinuousSystem) = length(s.c)
stateset(s::ConstrainedAffineControlContinuousSystem) = s.X
inputdim(s::ConstrainedAffineControlContinuousSystem) = size(s.B, 2)
inputset(s::ConstrainedAffineControlContinuousSystem) = s.U
islinear(::ConstrainedAffineControlContinuousSystem) = false
isaffine(::ConstrainedAffineControlContinuousSystem) = true

"""
    ConstrainedLinearControlContinuousSystem

Continuous-time linear control system with state constraints of the form
```math
x' = A x + B u, x(t) ∈ \\mathcal{X}, u(t) ∈ \\mathcal{U} \\text{ for all } t.
```

### Fields

- `A` -- square matrix
- `B` -- matrix
- `X` -- state constraints
- `U` -- input constraints
"""
struct ConstrainedLinearControlContinuousSystem{T, MTA <: AbstractMatrix{T}, MTB <: AbstractMatrix{T}, ST, UT} <: AbstractContinuousSystem
    A::MTA
    B::MTB
    X::ST
    U::UT
    function ConstrainedLinearControlContinuousSystem(A::MTA, B::MTB, X::ST, U::UT) where {T, MTA <: AbstractMatrix{T}, MTB <: AbstractMatrix{T}, ST, UT}
        @assert checksquare(A) == size(B, 1)
        return new{T, MTA, MTB, ST, UT}(A, B, X, U)
    end
end
statedim(s::ConstrainedLinearControlContinuousSystem) = checksquare(s.A)
stateset(s::ConstrainedLinearControlContinuousSystem) = s.X
inputdim(s::ConstrainedLinearControlContinuousSystem) = size(s.B, 2)
inputset(s::ConstrainedLinearControlContinuousSystem) = s.U
islinear(::ConstrainedLinearControlContinuousSystem) = true
isaffine(::ConstrainedLinearControlContinuousSystem) = true

"""
    LinearAlgebraicContinuousSystem

Continuous-time linear algebraic system of the form
```math
E x' = A x.
```

### Fields

- `A` -- matrix
- `E` -- matrix, same size as `A`
"""
struct LinearAlgebraicContinuousSystem{T, MTA <: AbstractMatrix{T}, MTE <: AbstractMatrix{T}} <: AbstractContinuousSystem
    A::MTA
    E::MTE
    function LinearAlgebraicContinuousSystem(A::MTA, E::MTE) where {T, MTA <: AbstractMatrix{T}, MTE <: AbstractMatrix{T}}
        @assert size(A) == size(E)
        return new{T, MTA, MTE}(A, E)
    end
end
statedim(s::LinearAlgebraicContinuousSystem) = size(s.A, 1)
inputdim(s::LinearAlgebraicContinuousSystem) = 0
islinear(::LinearAlgebraicContinuousSystem) = true
isaffine(::LinearAlgebraicContinuousSystem) = true

"""
    ConstrainedLinearAlgebraicContinuousSystem

Continuous-time linear system with state constraints of the form
```math
E x' = A x, x(t) ∈ \\mathcal{X}.
```

### Fields

- `A` -- matrix
- `E` -- matrix, same size as `A`
- `X` -- state constraints
"""
struct ConstrainedLinearAlgebraicContinuousSystem{T, MTA <: AbstractMatrix{T}, MTE <: AbstractMatrix{T}, ST} <: AbstractContinuousSystem
    A::MTA
    E::MTE
    X::ST
    function ConstrainedLinearAlgebraicContinuousSystem(A::MTA, E::MTE, X::ST) where {T, MTA <: AbstractMatrix{T}, MTE <: AbstractMatrix{T}, ST}
        @assert size(A) == size(E)
        return new{T, MTA, MTE, ST}(A, E, X)
    end
end
statedim(s::ConstrainedLinearAlgebraicContinuousSystem) = size(s.A, 1)
stateset(s::ConstrainedLinearAlgebraicContinuousSystem) = s.X
inputdim(s::ConstrainedLinearAlgebraicContinuousSystem) = 0
islinear(::ConstrainedLinearAlgebraicContinuousSystem) = true
isaffine(::ConstrainedLinearAlgebraicContinuousSystem) = true

"""
    PolynomialContinuousSystem

Continuous-time polynomial system of the form
```math
x' = p(x).
```

### Fields

- `p`        -- polynomial vector field
- `statedim` -- number of state variables
"""
struct PolynomialContinuousSystem{T, PT <: AbstractPolynomialLike{T}, VPT <: AbstractVector{PT}} <: AbstractContinuousSystem
    p::VPT
    statedim::Int
    function PolynomialContinuousSystem(p::VPT, statedim::Int) where {T, PT <: AbstractPolynomialLike{T}, VPT <: AbstractVector{PT}}
        @assert statedim == MultivariatePolynomials.nvariables(p) "the state dimension $(statedim) does not match the number of state variables"
        return new{T, PT, VPT}(p, statedim)
    end
end
statedim(s::PolynomialContinuousSystem) = s.statedim
inputdim(s::PolynomialContinuousSystem) = 0
islinear(::PolynomialContinuousSystem) = false
isaffine(::PolynomialContinuousSystem) = false

MultivariatePolynomials.variables(s::PolynomialContinuousSystem) = MultivariatePolynomials.variables(s.p)
MultivariatePolynomials.nvariables(s::PolynomialContinuousSystem) = s.statedim

PolynomialContinuousSystem(p::AbstractVector{<:AbstractPolynomialLike}) = PolynomialContinuousSystem(p, MultivariatePolynomials.nvariables(p))
PolynomialContinuousSystem(p::AbstractPolynomialLike) = PolynomialContinuousSystem([p])

"""
    ConstrainedPolynomialContinuousSystem

Continuous-time polynomial system with state constraints,
```math
x' = p(x), x(t) ∈ \\mathcal{X}
```

### Fields

- `p`        -- polynomial vector field
- `X`        -- constraint set
- `statedim` -- number of state variables
"""
struct ConstrainedPolynomialContinuousSystem{T, PT <: AbstractPolynomialLike{T}, VPT <: AbstractVector{PT}, ST} <: AbstractContinuousSystem
    p::VPT
    statedim::Int
    X::ST
    function ConstrainedPolynomialContinuousSystem(p::VPT, statedim::Int, X::ST) where {T, PT <: AbstractPolynomialLike{T}, VPT <: AbstractVector{PT}, ST}
        @assert statedim == MultivariatePolynomials.nvariables(p) "the state dimension $(statedim) does not match the number of state variables"
        return new{T, PT, VPT, ST}(p, statedim, X)
    end
end
statedim(s::ConstrainedPolynomialContinuousSystem) = s.statedim
stateset(s::ConstrainedPolynomialContinuousSystem) = s.X
inputdim(s::ConstrainedPolynomialContinuousSystem) = 0
islinear(::ConstrainedPolynomialContinuousSystem) = false
isaffine(::ConstrainedPolynomialContinuousSystem) = false

MultivariatePolynomials.variables(s::ConstrainedPolynomialContinuousSystem) = MultivariatePolynomials.variables(s.p)
MultivariatePolynomials.nvariables(s::ConstrainedPolynomialContinuousSystem) = s.statedim

ConstrainedPolynomialContinuousSystem(p::AbstractVector{<:AbstractPolynomialLike}, X::ST) where {ST} = ConstrainedPolynomialContinuousSystem(p, MultivariatePolynomials.nvariables(p), X)
ConstrainedPolynomialContinuousSystem(p::AbstractPolynomialLike, X::ST) where {ST} = ConstrainedPolynomialContinuousSystem([p], X)
