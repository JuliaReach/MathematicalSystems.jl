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
extract_dyn_equation_parameters
add_asterisk
sort
```

## Querying expressions

```@docs
is_equation
extract_sum
```

## Evaluation of AbstractSystem at given state

```@docs
_instantiate
```

## Naming convention for systems' fields

Systems' fields should be accessed externally by their respective getter functions.
Internally to the library, the following naming conventions are used.

|Field|Description|Getter function|
|-----|-----------|---------------|
|`A`  |state matrix|`state_matrix`|
|`B`  |input matrix|`input_matrix`|
|`c`  |affine term|`affine_term`|
|`D`  |noise matrix|`noise_matrix`|
|`X`  |state constraints|`stateset`|
|`U`  |input constraints|`inputset`|
|`W`  |disturbance set|`noiseset`|
