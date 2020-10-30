# Methods

This section describes systems methods implemented in `MathematicalSystems.jl`.

```@contents
Pages = ["methods.md"]
Depth = 3
```

```@meta
CurrentModule = MathematicalSystems
DocTestSetup = quote
    using MathematicalSystems
end
```

## States

```@docs
statedim
stateset
```

## Inputs

```@docs
inputdim
inputset
nextinput
```

## Noises

```@docs
noisedim
noiseset
```

## Output

```@docs
outputdim
outputmap
```

## Traits

```@docs
islinear(::AbstractSystem)
islinear(::AbstractMap)
isaffine(::AbstractSystem)
ispolynomial(::AbstractSystem)
isaffine(::AbstractMap)
isblackbox(::AbstractSystem)
isnoisy(::AbstractSystem)
iscontrolled(::AbstractSystem)
isconstrained(::AbstractSystem)
state_matrix(::AbstractSystem)
input_matrix(::AbstractSystem)
noise_matrix(::AbstractSystem)
affine_term(::AbstractSystem)
```

## Maps

```@docs
apply
```

## Successor

```@docs
successor
```

## Vector Field
```@docs
vector_field
```

## Discretization

```@docs
discretize
```

## Internal Methods

```@docs
_discretize
typename(::AbstractSystem)
_complementary_type(::Type{<:AbstractSystem})
```
