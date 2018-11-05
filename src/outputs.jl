"""
    SystemWithOutput{ST<:AbstractSystem, MT<:AbstractMap}

Parametric composite type for systems with outputs. It is parameterized in the
system's type (`ST`) and in the map's type (`MT`).

### Fields

- `s`         -- system of type `ST`
- `outputmap` -- output map of type `MT`
"""
struct SystemWithOutput{ST<:AbstractSystem, MT<:AbstractMap}
    s::ST
    outputmap::MT
end
statedim(swo::SystemWithOutput) = statedim(swo.s)
inputdim(swo::SystemWithOutput) = inputdim(swo.s)
inputset(swo::SystemWithOutput) = inputset(swo.s)
outputdim(swo::SystemWithOutput) = outputdim(swo.outputmap)
outputmap(swo::SystemWithOutput) = swo.outputmap

"""
    LinearTimeInvariantSystem

```math
x' = Ax + Bu,\\
y = Cx + Du.
```

`LTI` is an alias for `LinearTimeInvariantSystem`.
"""
function LinearTimeInvariantSystem(A, B, C, D, X, U)
    system = ConstrainedLinearControlContinuousSystem(A, B, X, U)
    outputmap = ConstrainedLinearControlMap(A, B, U)
    return SystemWithOutput(system, outputmap)
end

function LinearTimeInvariantSystem(A, B, C, D)
    system = LinearControlContinuousSystem(A, B)
    outputmap = LinearControlMap(A, B)
    return SystemWithOutput(system, outputmap)
end

"""
    LTISystem

`LTISystem` is an alias for `LinearTimeInvariantSystem`.
"""
const LTISystem = LinearTimeInvariantSystem