# MathematicalSystems.jl

```@meta
DocTestFilters = [r"[0-9\.]+ seconds \(.*\)"]
```

`MathematicalSystems` is a [Julia](http://julialang.org) package for mathematical systems interfaces.

## Features

- Generic and flexible systems definitions, while being fast and type stable.
- Types for mathematical systems modeling: continuous, discrete, controlled,
  linear algebraic, etc.
- Iterator interfaces to handle constant or time-varying inputs.

## Ecosystem

The following packages use `MathematicalSystems.jl`:

- [Dionysos.jl](https://github.com/dionysos-dev/Dionysos.jl) -- *Optimal control of cyber-physical systems*
- [HybridSystems.jl](https://github.com/blegat/HybridSystems.jl) -- *Hybrid Systems definitions in Julia*
- [ReachabilityAnalysis.jl](https://github.com/JuliaReach/ReachabilityAnalysis.jl) -- *Methods to compute sets of states reachable by dynamical systems*
- [SpaceExParser.jl](https://github.com/JuliaReach/SpaceExParser.jl) -- *SpaceEx modeling language parser*
- [StructuralDynamicsODESolvers.jl](https://github.com/ONSAS/StructuralDynamicsODESolvers.jl) -- *Numerical integration methods for structural dynamics problems*
- [SwitchOnSafety.jl](https://github.com/blegat/SwitchOnSafety.jl) -- *Computing controlled invariant sets of Hybrid Systems using Sum Of Squares Programming*


## Manual Outline

```@contents
Pages = [
    "man/systems.md"
]
Depth = 2
```

## Library Outline

```@contents
Pages = [
    "lib/types.md",
    "lib/methods.md",
    "lib/internals.md"
]
Depth = 2
```
