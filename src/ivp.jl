"""
    InitialValueProblem{S <: AbstractSystem, XT} <: AbstractSystem

Parametric composite type for initial value problems. It is parameterized in the
system's type and the initial state's type

### Fields

- `s`  -- system
- `x0` -- initial state

### Examples

The linear system ``x' = -x`` with initial condition ``x₀ = [-1/2, 1/2]``:

```jldoctest
julia> s = LinearContinuousSystem([-1.0 0.0; 0.0 -1.0]);

julia> x₀ = [-1/2, 1/2];

julia> p = InitialValueProblem(s, x₀);

julia> initial_state(p) # same as p.x0
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
stateset(ivp::InitialValueProblem) = stateset(ivp.s)
inputdim(ivp::InitialValueProblem) = inputdim(ivp.s)
inputset(ivp::InitialValueProblem) = inputset(ivp.s)
islinear(ivp::InitialValueProblem) = islinear(ivp.s)
isaffine(ivp::InitialValueProblem) = isaffine(ivp.s)
ispolynomial(ivp::InitialValueProblem) = ispolynomial(ivp.s)
state_matrix(ivp::InitialValueProblem) = state_matrix(ivp.s)
input_matrix(ivp::InitialValueProblem) = input_matrix(ivp.s)
noise_matrix(ivp::InitialValueProblem) = noise_matrix(ivp.s)
affine_term(ivp::InitialValueProblem) = affine_term(ivp.s)

"""
    initial_state(ivp::InitialValueProblem)

Return the initial state of an initial-value problem.

### Input

- `ivp` -- initial-value problem

### Output

The initial state of an initial-value problem.
"""
initial_state(ivp::InitialValueProblem) = ivp.x0

"""
    system(ivp::InitialValueProblem)

Return the system wrapped by an initial-value problem.

### Input

- `ivp` -- initial-value problem

### Output

The system of the given initial-value problem.
"""
system(ivp::InitialValueProblem) = ivp.s

"""
    IVP

`IVP` is an alias for `InitialValueProblem`.
"""
const IVP = InitialValueProblem
