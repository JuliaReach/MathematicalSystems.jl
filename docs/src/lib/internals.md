# Internals

This section describes functions that are internal to the library.

```@contents
Pages = ["internals.md"]
Depth = 3
```

```@meta
CurrentModule = MathematicalSystems
DocTestSetup = quote
    using MathematicalSystems
end
```

## Expression handling

```@docs
_corresponding_type
_capture_dim
add_asterisk
```

## Querying expressions

```@docs
is_equation
extract_sum
```
