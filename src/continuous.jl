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
