"""
    ContinuousLinearSystem

Continuous-time linear system of the form
```math
x' = A x.
```

### Fields

- `A` -- square matrix
"""
struct ContinuousLinearSystem{T, MT <: AbstractMatrix{T}} <: AbstractContinuousSystem
    A::MT
end
ContinuousLinearSystem{T, MT <: AbstractMatrix{T}}(A::MT) = ContinuousLinearSystem{T, MT}(A)
statedim(s::ContinuousLinearSystem) = Base.LinAlg.checksquare(s.A)
inputdim(s::ContinuousLinearSystem) = 0
