"""
    SystemWithOutput{ST<:AbstractSystem, MT<:AbstractMap} <: AbstractSystem

Parametric composite type for systems with outputs. It is parameterized in the
system's type (`ST`) and in the map's type (`MT`).

### Fields

- `s`         -- system of type `ST`
- `outputmap` -- output map of type `MT`
"""
struct SystemWithOutput{ST<:AbstractSystem, MT<:AbstractMap} <: AbstractSystem
    s::ST
    outputmap::MT
end
statedim(swo::SystemWithOutput) = statedim(swo.s)
inputdim(swo::SystemWithOutput) = inputdim(swo.s)
inputset(swo::SystemWithOutput) = inputset(swo.s)
outputdim(swo::SystemWithOutput) = outputdim(swo.outputmap)
outputmap(swo::SystemWithOutput) = swo.outputmap
islinear(swo::SystemWithOutput) = islinear(swo.s) && islinear(swo.outputmap)
isaffine(swo::SystemWithOutput) = isaffine(swo.s) && isaffine(swo.outputmap)

"""
    LinearTimeInvariantSystem(A, B, C, D)

A linear time-invariant system with of the form

```math
x' = Ax + Bu,\\\\
y = Cx + Du.
```

### Input

- `A` -- matrix
- `B` -- matrix
- `C` -- matrix
- `D` -- matrix

### Output

A system with output such that the system is a linear control
continuous system and the output map is a linear control map.
"""
function LinearTimeInvariantSystem(A, B, C, D)
    system = LinearControlContinuousSystem(A, B)
    outputmap = LinearControlMap(C, D)
    return SystemWithOutput(system, outputmap)
end

"""
    LinearTimeInvariantSystem(A, B, C, D, X, U)

A linear time-invariant system with state and input constraints
of the form

```math
x' = Ax + Bu,\\\\
y = Cx + Du,
```
where ``x(t) ∈ X`` and ``u(t) ∈ U`` for all ``t``.

### Input

- `A` -- matrix
- `B` -- matrix
- `C` -- matrix
- `D` -- matrix
- `X` -- state constraints
- `U` -- input constraints

### Output

A system with output such that the system is a constrained linear control
continuous system and the output map is a constrained linear control map.
"""
function LinearTimeInvariantSystem(A, B, C, D, X, U)
    system = ConstrainedLinearControlContinuousSystem(A, B, X, U)
    outputmap = ConstrainedLinearControlMap(C, D, X, U)
    return SystemWithOutput(system, outputmap)
end

"""
    LTISystem

`LTISystem` is an alias for `LinearTimeInvariantSystem`.
"""
const LTISystem = LinearTimeInvariantSystem
