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
isnoisy(::AbstractSystem)
iscontrolled(::AbstractSystem)
isconstrained(::AbstractSystem)
```

## Maps

```@docs
apply
```

## Successor

```@docs
successor
```
