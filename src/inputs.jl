"""
    AbstractInput

Abstract supertype for all input types.

### Notes

The input types defined here implement an iterator interface, such that other methods
can build upon the behavior of inputs which are either constant or varying.

Iteration is supported with an index number called *iterator state*.
The iteration function `Base.next` takes and returns a tuple (`input`, `state`),
where `input` represents the value of the input, and `state` is an index which
counts the number of times this iterator was called.
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
To access the field `U`, you can use the method `nextinput`, or a `for` loop:

```jldoctest constant_input
julia> c = ConstantInput(-1//2)
Systems.ConstantInput{Rational{Int64}}(-1//2)

julia> nextinput(c)
-1//2

julia> nextinput(c)
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
    nextinput(input::ConstantInput, state::Int)

Returns the input.

### Input

- `input`  -- a constant input
- `state`  -- (optional, default: `1`) the state of the iterator

### Output

The input representation in `input`.
"""
nextinput(input::ConstantInput, state::Int=1) = input.U

"""
    VaryingInput{UT} <: AbstractInput

Type representing an input that may vary with time.

### Fields

- `U` -- vector of input sets

### Examples

The varying input holds a vector of elements and its length equals the number
of elements in the vector.

```jldoctest varying_input
julia> v = VaryingInput([-1//2, 1//2])
Systems.VaryingInput{Rational{Int64}}(Rational{Int64}[-1//2, 1//2])

julia> length(v)
2
```

The method `nextinput` receives a varying input and an index representing the state
and returns the next input corresponding to the given state:

```jldoctest varying_input
julia> nextinput(v, 1)
-1//2

julia> nextinput(v, 2)
1//2
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
    nextinput(input::VaryingInput, state::Int)

Returns the input field given a state.

### Input

- `inputs` -- a varying input
- `state`  -- the state of the iterator

### Output

The input representation of `input` corresponding to `state`.
"""
nextinput(input::VaryingInput, state::Int) = input.U[state]
