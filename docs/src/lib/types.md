# Types

This section describes systems types implemented in `MathematicalSystems.jl`.

```@contents
Pages = ["types.md"]
Depth = 3
```

```@meta
CurrentModule = MathematicalSystems
DocTestSetup = quote
    using MathematicalSystems
end
```

## Abstract Systems

```@docs
AbstractSystem
AbstractContinuousSystem
AbstractDiscreteSystem
```

## Continuous Systems

```@docs
ContinuousIdentitySystem
ConstrainedContinuousIdentitySystem
LinearContinuousSystem
LinearControlContinuousSystem
ConstrainedLinearContinuousSystem
ConstrainedLinearControlContinuousSystem
LinearAlgebraicContinuousSystem
ConstrainedLinearAlgebraicContinuousSystem
```

## Discrete Systems

```@docs
DiscreteIdentitySystem
ConstrainedDiscreteIdentitySystem
LinearDiscreteSystem
LinearControlDiscreteSystem
ConstrainedLinearDiscreteSystem
ConstrainedLinearControlDiscreteSystem
LinearAlgebraicDiscreteSystem
ConstrainedLinearAlgebraicDiscreteSystem
```

## Initial Value Problems

```@docs
InitialValueProblem
IVP
```

## Input Types

```@docs
AbstractInput
ConstantInput
VaryingInput
```
