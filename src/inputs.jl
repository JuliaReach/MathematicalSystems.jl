"""
    AbstractInput

Abstract supertype for all input types.

### Notes

The input types defined here implement an iterator interface, such that other methods
can build upon the behavior of inputs which are either constant or varying.
"""
abstract type AbstractInput end

Base.start(::AbstractInput) = 1

"""
    ConstantInput{UT} <: AbstractInput

Type representing an input that remains constant in time.

### Fields

- `U` -- input set

### Examples

The constant input holds a single element and its length is infinite.
To access the field `U`, you can use the method `next_input`,
and a `for` loop as well:

```jldoctest constant_input
julia> c = ConstantInput(-1//2)
Systems.ConstantInput{Rational{Int64}}(-1//2)

julia> next_input(c)
-1//2

julia> next_input(c)
-1//2

julia> length(c)
Base.IsInfinite()

julia> for ci in c print(2*ci) end
-1//1
```
"""
struct ConstantInput{UT} <: AbstractInput
    U::UT
end

Base.next(input::ConstantInput, state) = (input.U, state + 1)
Base.done(input::ConstantInput, state) = state > 1
Base.length(input::ConstantInput) = Base.IsInfinite()

"""
    next_input(input::ConstantInput, state::Int)

Returns the input.

### Input

- `input` -- a constant input
- `state`  -- the state of the iterator

### Output

The input field of `input`.
"""
next_input(input::ConstantInput, state::Int) = input.U

"""
    next_input(input::ConstantInput)

Returns the input which doesn't need to specify the `state` for constant inputs.

### Input

- `input` -- a constant input

### Output

The input field of `input`.
"""
next_input(input::ConstantInput) = input.U

"""
    VaryingInput{UT} <: AbstractInput

Type representing an input that may vary with time.

### Fields

- `U` -- vector of input sets

### Examples

The varying input holds a vector of element and its length equals the number
of elements in the vector.

```jldoctest varying_input
julia> v = VaryingInput([-1//2, 1//2])
Systems.VaryingInput{Rational{Int64}}(Rational{Int64}[-1//2, 1//2])

julia> length(v)
2
```

You can collect the inputs in an array, or equivalently use list comprehension,
(or use a `for` loop):

```jldoctest varying_input
julia> collect(v)
2-element Array{Any,1}:
 -1//2
  1//2

julia> [2*vi for vi in v]
2-element Array{Rational{Int64},1}:
 -1//1
  1//1
```
"""
struct VaryingInput{UT} <: AbstractInput
    U::AbstractVector{<:UT}  # input sequence
end

Base.next(input::VaryingInput, state) = (input.U[state], state + 1)
Base.done(input::VaryingInput, state) = state > length(input.U)
Base.length(input::VaryingInput) = length(input.U)

"""
    next_input(input::VaryingInput, state::Int)

Returns the input field given a state.

### Input

- `inpus` -- a varying input
- `state` -- the state of the iterator

### Output

The input field of `input`.
"""
next_input(input::VaryingInput, state::Int) = input.U[state]
