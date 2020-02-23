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
BlackBoxControlContinuousSystem
ConstrainedBlackBoxControlContinuousSystem
NoisyLinearContinuousSystem
NoisyConstrainedLinearContinuousSystem
NoisyLinearControlContinuousSystem
NoisyConstrainedLinearControlContinuousSystem
NoisyAffineControlContinuousSystem
NoisyConstrainedAffineControlContinuousSystem
NoisyBlackBoxControlContinuousSystem
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
BlackBoxControlDiscreteSystem
ConstrainedBlackBoxControlDiscreteSystem
NoisyLinearDiscreteSystem
NoisyConstrainedLinearDiscreteSystem
NoisyLinearControlDiscreteSystem
NoisyConstrainedLinearControlDiscreteSystem
NoisyAffineControlDiscreteSystem
NoisyConstrainedAffineControlDiscreteSystem
NoisyBlackBoxControlDiscreteSystem
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

## Initial-value problem macro

```@docs
@ivp
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
system
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
