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
```