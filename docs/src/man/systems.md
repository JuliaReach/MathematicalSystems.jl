# System types overview

## Using the macro

A convenient way to create a new system is with the `@system` macro. For example,
the ODE $x'(t) = -2x(t)$ is simply `x' = -2x`, where $x'(t) := dx/dt$ is the derivative
of state $x(t)$ with respect to "time":

```@example system_examples
using MathematicalSystems

@system(x' = -2x)
```

We can also add state constraints, say $x(t) ≥ 0.5$,

```@example system_examples
using LazySets

H = HalfSpace([-1.0], -0.5) # x >= 0.5
@system(x' = -2x, x ∈ H)
```

Systems of ODEs can be defined using vector notation:

```@example system_examples
A = [1.0 0.0; -1.0 -2.0]
B = Ball2(zeros(2), 1.0)
c = [0.0, 5.0]
@system(z' = A*z + c, z ∈ B)
```
which defines the two-dimensional system $x' = y$, $y' = -x - 2y + 3$, with state
constraints $z ∈ B = \{ \sqrt{x^2 + y^2} \leq 5\}$.

Initial-value problems can be specified with the `@ivp` macro.
For instance, we can attach an initial condition $z(0) = (0.2, 0.2])$ to
the previous example:

```@example system_examples
S0 = Singleton([0.2, 0.2])
@ivp(z' = A*z + c, z ∈ B, z(0) ∈ S0)
```

## Inputs

In the examples introduced so far, the macro has automatically created different system types
given a defining equation, either in scalar or in vector form, and state constraints.
It is possible to define systems with additive input terms or noise terms, with
constraints on the state, inputs or combinations of these. Other specific classes of
systems such as algebraic, polynomial or general nonlinear systems given by a standard
Julia function are available as well (see the tables below).

Some applications require distinguishing between *controlled* inputs and *uncontrolled* or
noise inputs. In this library we make such distinction by noting field names with $u$ and $w$
for (controlled) inputs and noise respectively. Please note that some systems are structurally
equivalent, for example `CLCCS` and `NCLCS` being $x' = Ax + Bu$ and $x' = Ax + Dw$ respectively;
the difference lies in the resulting value of getter functions such as `inputset` and `noiseset`.

## Summary tables

The following table summarizes the different system types in abbreviated form.
The abbreviated names are included here only for reference and are not exported.
See the [Types](@ref) section of this manual, or simply click on the system's name
for details on each type.

Please note that for each continuous system there is a corresponding discrete system,
e.g. there is [`ConstrainedAffineContinuousSystem`](@ref) and [`ConstrainedAffineDiscreteSystem`](@ref), etc.
However in this table we only included continuous system types for brevity.

|Abbreviation| System type|
|-----------|-------------|
|CIS|[`ContinuousIdentitySystem`](@ref)|
|CCIS|[`ConstrainedContinuousIdentitySystem`](@ref)|
|LCS|[`LinearContinuousSystem`](@ref)|
|ACS|[`AffineContinuousSystem`](@ref)|
|LCCS|[`LinearControlContinuousSystem`](@ref)|
|ACCS|[`AffineControlContinuousSystem`](@ref)|
|CLCS|[`ConstrainedLinearContinuousSystem`](@ref)|
|CACS|[`ConstrainedAffineContinuousSystem`](@ref)|
|CACCS|[`ConstrainedAffineControlContinuousSystem`](@ref)|
|CLCCS|[`ConstrainedLinearControlContinuousSystem`](@ref)|
|LACS|[`LinearAlgebraicContinuousSystem`](@ref)|
|CLACS|[`ConstrainedLinearAlgebraicContinuousSystem`](@ref)|
|PCS|[`PolynomialContinuousSystem`](@ref)|
|CPCS|[`PolynomialContinuousSystem`](@ref)|
|BBCS|[`BlackBoxContinuousSystem`](@ref)|
|CBBCS|[`ConstrainedBlackBoxContinuousSystem`](@ref)|
|BBCCS|[`BlackBoxControlContinuousSystem`](@ref)|
|CBBCCS|[`ConstrainedBlackBoxControlContinuousSystem`](@ref)|
|NLCS| [`NoisyLinearContinuousSystem`](@ref)|
|NCLCS| [`NoisyConstrainedLinearContinuousSystem`](@ref)|
|NLCCS| [`NoisyLinearControlContinuousSystem`](@ref)|
|NCLCCS | [`NoisyConstrainedLinearControlContinuousSystem`](@ref)|
|NACCS| [`NoisyAffineControlContinuousSystem`](@ref)|
|NCALCCS| [`NoisyConstrainedAffineControlContinuousSystem`](@ref)|
|NBBCCS|[`NoisyBlackBoxControlContinuousSystem`](@ref)|
|NCBBCCS|[`NoisyConstrainedBlackBoxControlContinuousSystem`](@ref)|
|SOLCS|[`SecondOrderLinearContinuousSystem`](@ref)|
|SOACS|[`SecondOrderAffineContinuousSystem`](@ref)|
|SOCACCS|[`SecondOrderConstrainedAffineControlContinuousSystem`](@ref)|
|SOCLCCS|[`SecondOrderConstrainedLinearControlContinuousSystem`](@ref)|

The following table summarizes the equation represented by each system type
(the names are given in abbreviated form). Again, discrete systems are not included. The column *Input constraints* is `yes` if the structure can model input or noise constraints (or both).

|Equation | State constraints | Input constraints|System type (abbr.)|
|:-------|-------------|-----------|-----|
|$x' = 0$|no |no| CIS|
|$x' = 0, x ∈ X$|yes|no|CCIS|
|$x' = Ax$| no|no|LCS|
|$x' = Ax + c$|no|no |ACS|
|$x' = Ax + Bu$|no | no|LCCS|
|$x' = Ax + Bu + c$|no|no|ACCS|
|$x' = Ax, x ∈ X$|yes|no|CLCS||
|$x' = Ax + c, x ∈ X$|yes|no|CACS|
|$x' = Ax + Bu + c, x ∈ X, u ∈ U$|yes|yes|CACCS|
|$x' = Ax + Bu, x ∈ X, u ∈ U$|yes|yes|CLCCS|
|$Ex' = Ax$|no|no|LACS|
|$Ex' = Ax, x ∈ X$|yes|no|CLACS|
|$x' = p(x)$|no|no|PCS|
|$x' = p(x), x ∈ X$|yes|no|CPCS|
|$x' = f(x)$|no|no|BBCS|
|$x' = f(x), x ∈ X$|yes|no|CBBCS|
|$x' = f(x, u)$|no|no|BBCCS|
|$x' = f(x, u), x ∈ X, u ∈ U$|yes|yes|CBBCCS|
|$x' = Ax + Dw$|no|no|NLCS|
|$x' = Ax + Dw, x ∈ X, w ∈ W$|yes|yes|NCLCS |
|$x' = Ax + Bu + Dw$|no|no|NLCCS|
|$x' = Ax + Bu + Dw, x ∈ X, u ∈ U, w ∈ W$|yes|yes|NCLCCS |
|$x' = Ax + Bu + c + Dw$|no|no|NACCS|
|$x' = Ax + Bu + c + Dw, x ∈ X, u ∈ U, w ∈ W$|yes|yes|NCALCCS |
|$x' = f(x, u, w)$|no|no|NBBCCS|
|$x' = f(x, u, w), x ∈ X, u ∈ U, w ∈ W$|yes|yes|NCBBCCS|
|$Mx'' + Cx' + Kx = 0$|no|no|SOLCS|
|$Mx'' + Cx' + Kx = b$|no|no|SOACS|
|$Mx'' + Cx' + Kx = Bu + d, x ∈ X, u ∈ U$|yes|yes|SOCACCS|
|$Mx'' + Cx' + Kx = Bu, x ∈ X, u ∈ U$|yes|yes|SOCLCCS|
