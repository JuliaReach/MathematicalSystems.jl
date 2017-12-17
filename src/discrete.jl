"""
    DiscreteLinearSystem

Discrete-time linear system of the form
```math
x_{k+1} = A x_k.
```

### Fields

- `A` -- square matrix
"""
struct DiscreteLinearSystem{T, MT <: AbstractMatrix{T}} <: AbstractDiscreteSystem
    A::MT
end
DiscreteLinearSystem{T, MT <: AbstractMatrix{T}}(A::MT) = DiscreteLinearSystem{T, MT}(A)
statedim(s::DiscreteLinearSystem) = Base.LinAlg.checksquare(s.A)
inputdim(s::DiscreteLinearSystem) = 0
