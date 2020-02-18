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
BlackBoxContinuousSystem
ConstrainedBlackBoxContinuousSystem
ConstrainedBlackBoxControlContinuousSystem
NoisyLinearContinuousSystem
NoisyConstrainedLinearContinuousSystem
NoisyConstrainedLinearControlContinuousSystem
NoisyConstrainedAffineControlContinuousSystem
NoisyConstrainedBlackBoxControlContinuousSystem
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
BlackBoxDiscreteSystem
ConstrainedBlackBoxDiscreteSystem
ConstrainedBlackBoxControlDiscreteSystem
NoisyLinearDiscreteSystem
NoisyConstrainedLinearDiscreteSystem
NoisyConstrainedLinearControlDiscreteSystem
NoisyConstrainedAffineControlDiscreteSystem
NoisyConstrainedBlackBoxControlDiscreteSystem
```

#### Discretization Algorithms

```@docs
AbstractDiscretizationAlgorithm
ExactDiscretization
EulerDiscretization
```

## System macro

```@docs
@system
```

## Identity operator

```@docs
IdentityMultiple
```

## Initial Value Problems

```@docs
InitialValueProblem
IVP
initial_state
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
ConstrainedResetMap
```

### Macros

```@docs
@map
```

## Systems with output

```@docs
SystemWithOutput
LinearTimeInvariantSystem
LTISystem
```
