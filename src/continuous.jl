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
LinearContinuousSystem{T, MT <: AbstractMatrix{T}}(A::MT) = LinearContinuousSystem{T, MT}(A)
statedim(s::LinearContinuousSystem) = Base.LinAlg.checksquare(s.A)
inputdim(s::LinearContinuousSystem) = 0

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
struct LinearControlContinuousSystem{T, MT <: AbstractMatrix{T}} <: AbstractContinuousSystem
    A::MT
    B::MT
end
function LinearControlContinuousSystem{T, MT <: AbstractMatrix{T}}(A::MT, B::MT)
    @assert Base.LinAlg.checksquare(A) == size(B, 1)
    return LinearControlContinuousSystem{T, MT}(A, B)
end
statedim(s::LinearControlContinuousSystem) = Base.LinAlg.checksquare(s.A)
inputdim(s::LinearControlContinuousSystem) = size(s.B, 2)

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
ConstrainedLinearContinuousSystem{T, MT <: AbstractMatrix{T}, ST}(A::MT, X::ST) = ConstrainedLinearContinuousSystem{T, MT, ST}(A, X)
statedim(s::ConstrainedLinearContinuousSystem) = Base.LinAlg.checksquare(s.A)
inputdim(s::ConstrainedLinearContinuousSystem) = 0

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
struct ConstrainedLinearControlContinuousSystem{T, MT <: AbstractMatrix{T}, ST, UT} <: AbstractContinuousSystem
    A::MT
    B::MT
    X::ST
    U::UT
end
function ConstrainedLinearControlContinuousSystem{T, MT <: AbstractMatrix{T}, ST, UT}(A::MT, B::MT, X::ST, U::UT)
    @assert Base.LinAlg.checksquare(A) == size(B, 1)
    return ConstrainedLinearControlContinuousSystem{T, MT, ST, UT}(A, B, X, U)
end
statedim(s::ConstrainedLinearControlContinuousSystem) = Base.LinAlg.checksquare(s.A)
inputdim(s::ConstrainedLinearControlContinuousSystem) = size(s.B, 2)

