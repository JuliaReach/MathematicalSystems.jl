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
struct LinearControlDiscreteSystem{T, MT <: AbstractMatrix{T}} <: AbstractDiscreteSystem
    A::MT
    B::MT
    function LinearControlDiscreteSystem(A::MT, B::MT) where {T, MT <: AbstractMatrix{T}}
        @assert checksquare(A) == size(B, 1)
        return new{T, MT}(A, B)
    end
end
statedim(s::LinearControlDiscreteSystem) = checksquare(s.A)
inputdim(s::LinearControlDiscreteSystem) = size(s.B, 2)

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
struct ConstrainedLinearControlDiscreteSystem{T, MT <: AbstractMatrix{T}, ST, UT} <: AbstractDiscreteSystem
    A::MT
    B::MT
    X::ST
    U::UT
    function ConstrainedLinearControlDiscreteSystem(A::MT, B::MT, X::ST, U::UT) where {T, MT <: AbstractMatrix{T}, ST, UT}
        @assert checksquare(A) == size(B, 1)
        return new{T, MT, ST, UT}(A, B, X, U)
    end
end
statedim(s::ConstrainedLinearControlDiscreteSystem) = checksquare(s.A)
stateset(s::ConstrainedLinearControlDiscreteSystem) = s.X
inputdim(s::ConstrainedLinearControlDiscreteSystem) = size(s.B, 2)
inputset(s::ConstrainedLinearControlDiscreteSystem) = s.U

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
struct LinearAlgebraicDiscreteSystem{T, MT <: AbstractMatrix{T}} <: AbstractDiscreteSystem
    A::MT
    E::MT
    function LinearAlgebraicDiscreteSystem(A::MT, E::MT) where {T, MT <: AbstractMatrix{T}}
        @assert size(A) == size(E)
        return new{T, MT}(A, E)
    end
end
statedim(s::LinearAlgebraicDiscreteSystem) = size(s.A, 1)
inputdim(s::LinearAlgebraicDiscreteSystem) = 0

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
struct ConstrainedLinearAlgebraicDiscreteSystem{T, MT <: AbstractMatrix{T}, ST} <: AbstractDiscreteSystem
    A::MT
    E::MT
    X::ST
    function ConstrainedLinearAlgebraicDiscreteSystem(A::MT, E::MT, X::ST) where {T, MT <: AbstractMatrix{T}, ST}
        @assert size(A) == size(E)
        return new{T, MT, ST}(A, E, X)
    end
end
statedim(s::ConstrainedLinearAlgebraicDiscreteSystem) = size(s.A, 1)
stateset(s::ConstrainedLinearAlgebraicDiscreteSystem) = s.X
inputdim(s::ConstrainedLinearAlgebraicDiscreteSystem) = 0

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
