"""
    DiscreteIdentitySystem <: AbstractDiscreteSystem

Trivial identity discrete-time system of the form
```math
x_{k+1} = x_k.
```
"""
struct DiscreteIdentitySystem <: AbstractDiscreteSystem
    statedim::Int
end
statedim(s::DiscreteIdentitySystem) = s.statedim
inputdim(s::DiscreteIdentitySystem) = 0
islinear(::DiscreteIdentitySystem) = true
isaffine(::DiscreteIdentitySystem) = true

"""
    ConstrainedDiscreteIdentitySystem <: AbstractDiscreteSystem

Trivial identity discrete-time system with state constraints of the form
```math
x_{k+1} = x_k, x_k ∈ \\mathcal{X}.
```
"""
struct ConstrainedDiscreteIdentitySystem{ST} <: AbstractDiscreteSystem
    statedim::Int
    X::ST
end
statedim(s::ConstrainedDiscreteIdentitySystem) = s.statedim
stateset(s::ConstrainedDiscreteIdentitySystem) = s.X
inputdim(s::ConstrainedDiscreteIdentitySystem) = 0
islinear(::ConstrainedDiscreteIdentitySystem) = true
isaffine(::ConstrainedDiscreteIdentitySystem) = true

"""
    LinearDiscreteSystem

Discrete-time linear system of the form
```math
x_{k+1} = A x_k.
```

### Fields

- `A` -- square matrix
"""
struct LinearDiscreteSystem{T, MT <: AbstractMatrix{T}} <: AbstractDiscreteSystem
    A::MT
end
@static if VERSION < v"0.7-"
    LinearDiscreteSystem{T, MT <: AbstractMatrix{T}}(A::MT) = LinearDiscreteSystem{T, MT}(A)
end
statedim(s::LinearDiscreteSystem) = checksquare(s.A)
inputdim(s::LinearDiscreteSystem) = 0
islinear(::LinearDiscreteSystem) = true
isaffine(::LinearDiscreteSystem) = true

"""
    LinearControlDiscreteSystem

Discrete-time linear control system of the form
```math
x_{k+1} = A x_k + B u_k.
```

### Fields

- `A` -- square matrix
- `B` -- matrix
"""
struct LinearControlDiscreteSystem{T, MTA <: AbstractMatrix{T}, MTB <: AbstractMatrix{T}} <: AbstractDiscreteSystem
    A::MTA
    B::MTB
    function LinearControlDiscreteSystem(A::MTA, B::MTB) where {T, MTA <: AbstractMatrix{T}, MTB <: AbstractMatrix{T}}
        @assert checksquare(A) == size(B, 1)
        return new{T, MTA, MTB}(A, B)
    end
end
statedim(s::LinearControlDiscreteSystem) = checksquare(s.A)
inputdim(s::LinearControlDiscreteSystem) = size(s.B, 2)
islinear(::LinearControlDiscreteSystem) = true
isaffine(::LinearControlDiscreteSystem) = true

"""
    ConstrainedLinearDiscreteSystem

Discrete-time linear system with state constraints of the form
```math
x_{k+1} = A x_k, x_k ∈ \\mathcal{X}.
```

### Fields

- `A` -- square matrix
- `X` -- state constraints
"""
struct ConstrainedLinearDiscreteSystem{T, MT <: AbstractMatrix{T}, ST} <: AbstractDiscreteSystem
    A::MT
    X::ST
end
@static if VERSION < v"0.7-"
    ConstrainedLinearDiscreteSystem{T, MT <: AbstractMatrix{T}, ST}(A::MT, X::ST) = ConstrainedLinearDiscreteSystem{T, MT, ST}(A, X)
end
statedim(s::ConstrainedLinearDiscreteSystem) = checksquare(s.A)
stateset(s::ConstrainedLinearDiscreteSystem) = s.X
inputdim(s::ConstrainedLinearDiscreteSystem) = 0
islinear(::ConstrainedLinearDiscreteSystem) = true
isaffine(::ConstrainedLinearDiscreteSystem) = true

"""
    ConstrainedLinearControlDiscreteSystem

Discrete-time linear control system with state constraints of the form
```math
x_{k+1} = A x_k + B u_k, x_k ∈ \\mathcal{X}, u_k ∈ \\mathcal{U} \\text{ for all } k.
```

### Fields

- `A` -- square matrix
- `B` -- matrix
- `X` -- state constraints
- `U` -- input constraints
"""
struct ConstrainedLinearControlDiscreteSystem{T, MTA <: AbstractMatrix{T}, MTB <: AbstractMatrix{T}, ST, UT} <: AbstractDiscreteSystem
    A::MTA
    B::MTB
    X::ST
    U::UT
    function ConstrainedLinearControlDiscreteSystem(A::MTA, B::MTB, X::ST, U::UT) where {T, MTA <: AbstractMatrix{T}, MTB <: AbstractMatrix{T}, ST, UT}
        @assert checksquare(A) == size(B, 1)
        return new{T, MTA, MTB, ST, UT}(A, B, X, U)
    end
end
statedim(s::ConstrainedLinearControlDiscreteSystem) = checksquare(s.A)
stateset(s::ConstrainedLinearControlDiscreteSystem) = s.X
inputdim(s::ConstrainedLinearControlDiscreteSystem) = size(s.B, 2)
inputset(s::ConstrainedLinearControlDiscreteSystem) = s.U
islinear(::ConstrainedLinearControlDiscreteSystem) = true
isaffine(::ConstrainedLinearControlDiscreteSystem) = true

"""
    LinearAlgebraicDiscreteSystem

Discrete-time linear algebraic system of the form
```math
E x_{k+1} = A x_k.
```

### Fields

- `A` -- matrix
- `E` -- matrix, same size as `A`
"""
struct LinearAlgebraicDiscreteSystem{T, MTA <: AbstractMatrix{T}, MTE <: AbstractMatrix{T}} <: AbstractDiscreteSystem
    A::MTA
    E::MTE
    function LinearAlgebraicDiscreteSystem(A::MTA, E::MTE) where {T, MTA <: AbstractMatrix{T}, MTE <: AbstractMatrix{T}}
        @assert size(A) == size(E)
        return new{T, MTA, MTE}(A, E)
    end
end
statedim(s::LinearAlgebraicDiscreteSystem) = size(s.A, 1)
inputdim(s::LinearAlgebraicDiscreteSystem) = 0
islinear(::LinearAlgebraicDiscreteSystem) = true
isaffine(::LinearAlgebraicDiscreteSystem) = true

"""
    ConstrainedLinearAlgebraicDiscreteSystem

Discrete-time linear system with state constraints of the form
```math
E x_{k+1} = A x_k, x_k ∈ \\mathcal{X}.
```

### Fields

- `A` -- matrix
- `E` -- matrix, same size as `A`
- `X` -- state constraints
"""
struct ConstrainedLinearAlgebraicDiscreteSystem{T, MTA <: AbstractMatrix{T}, MTE <: AbstractMatrix{T}, ST} <: AbstractDiscreteSystem
    A::MTA
    E::MTE
    X::ST
    function ConstrainedLinearAlgebraicDiscreteSystem(A::MTA, E::MTE, X::ST) where {T, MTA <: AbstractMatrix{T}, MTE <: AbstractMatrix{T}, ST}
        @assert size(A) == size(E)
        return new{T, MTA, MTE, ST}(A, E, X)
    end
end
statedim(s::ConstrainedLinearAlgebraicDiscreteSystem) = size(s.A, 1)
stateset(s::ConstrainedLinearAlgebraicDiscreteSystem) = s.X
inputdim(s::ConstrainedLinearAlgebraicDiscreteSystem) = 0
islinear(::ConstrainedLinearAlgebraicDiscreteSystem) = true
isaffine(::ConstrainedLinearAlgebraicDiscreteSystem) = true

"""
    PolynomialDiscreteSystem

Discrete-time polynomial system of the form
```math
x_{k+1} = p(x_k), x_k ∈ \\mathcal{X}.
```

### Fields

- `p`        -- polynomial
- `statedim` -- number of state variables
"""
struct PolynomialDiscreteSystem{PT} <: AbstractDiscreteSystem
    p::PT
    statedim::Int
end
statedim(s::PolynomialDiscreteSystem) = s.statedim
inputdim(s::PolynomialDiscreteSystem) = 0
islinear(::PolynomialDiscreteSystem) = false
isaffine(::PolynomialDiscreteSystem) = false

"""
    ConstrainedPolynomialDiscreteSystem

Discrete-time polynomial system with state constraints,
```math
x_{k+1} = p(x_k), x_k ∈ \\mathcal{X}.
```

### Fields

- `p`        -- polynomial
- `X`        -- constraint set
- `statedim` -- number of state variables
"""
struct ConstrainedPolynomialDiscreteSystem{PT, ST} <: AbstractDiscreteSystem
    p::PT
    statedim::Int
    X::ST
end
statedim(s::ConstrainedPolynomialDiscreteSystem) = s.statedim
stateset(s::ConstrainedPolynomialDiscreteSystem) = s.X
inputdim(s::ConstrainedPolynomialDiscreteSystem) = 0
islinear(::ConstrainedPolynomialDiscreteSystem) = false
isaffine(::ConstrainedPolynomialDiscreteSystem) = false
