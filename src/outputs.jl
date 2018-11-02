"""
    SystemWithOutput{ST<:AbstractSystem, MT<:AbstractMap}

Parametric composite type for systems with outputs. It is parameterized in the
system's type (`ST`) and in the map's type (`MT`).

### Fields

- `system`    -- system of type `ST`
- `outputmap` -- output map of type `MT`
"""
struct SystemWithOutput{ST<:AbstractSystem, MT<:AbstractMap}
    system::ST
    outputmap::MT
end

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
    outputmap = LinearControlMap(A, B, U)
    return SystemWithOutput(system, outputmap)
end

"""
    LTI

`LTI` is an alias for `LinearTimeInvariantSystem`.
"""
const LTI = LinearTimeInvariantSystem