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
ConstrainedAffineContinuousSystem
ConstrainedAffineControlContinuousSystem
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
AffineDiscreteSystem
LinearControlDiscreteSystem
ConstrainedLinearDiscreteSystem
ConstrainedAffineDiscreteSystem
ConstrainedLinearControlDiscreteSystem
ConstrainedAffineControlDiscreteSystem
LinearAlgebraicDiscreteSystem
ConstrainedLinearAlgebraicDiscreteSystem
PolynomialDiscreteSystem
ConstrainedPolynomialDiscreteSystem
```

## Identity operator

```@docs
IdentityMultiple
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

## Maps

```@docs
AbstractMap
IdentityMap
ConstrainedIdentityMap
LinearMap
ConstrainedLinearMap
AffineMap
ConstrainedAffineMap
LinearControlMap
ConstrainedLinearControlMap
AffineControlMap
ConstrainedAffineControlMap
ResetMap
```

## Systems with output

```@docs
SystemWithOutput
LinearTimeInvariantSystem
LTISystem
```
