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
AffineContinuousSystem
LinearControlContinuousSystem
ConstrainedLinearContinuousSystem
ConstrainedLinearControlContinuousSystem
LinearAlgebraicContinuousSystem
ConstrainedLinearAlgebraicContinuousSystem
PolynomialContinuousSystem
ConstrainedPolynomialContinuousSystem
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
PolynomialDiscreteSystem
ConstrainedPolynomialDiscreteSystem
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
