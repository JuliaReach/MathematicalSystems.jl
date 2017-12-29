"""
    InitialValueProblem

Parametric composite type for initial value problems. It is parameterized in the
system's type.

### Examples

```jldoctest
julia> p = InitialValueProblem(LinearContinuousSystem(eye(2)), [-1/2., 1/2]);
julia> p.x0
2-element Array{Float64,1}:
 -0.5
  0.5
julia> statedim(p)
  2
julia> inputdim(p)
  0
```
"""
struct InitialValueProblem{S <: AbstractSystem, XT} <: AbstractSystem
    s::S
    x0::XT
end
statedim(ivp::InitialValueProblem) = statedim(ivp.s)
inputdim(ivp::InitialValueProblem) = inputdim(ivp.s)

"""
    IVP

`IVP` is an alias for `InitialValueProblem`.
"""
const IVP = InitialValueProblem