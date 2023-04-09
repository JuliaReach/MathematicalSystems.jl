"""
    AbstractInput

Abstract supertype for all input types.

### Notes

The input types defined here implement an iterator interface, such that other methods
can build upon the behavior of inputs which are either constant or varying.

Iteration is supported with an index number called *iterator state*.
The iteration function `Base.iterate` takes and returns a tuple (`input`, `state`),
where `input` represents the value of the input, and `state` is an index which
counts the number of times this iterator was called.

A convenience function `nextinput(input, n)` is also provided and it returns the
first `n` elements of `input`.
"""
abstract type AbstractInput end

"""
    ConstantInput{UT} <: AbstractInput

Type representing an input that remains constant in time.

### Fields

- `U` -- input set

### Examples

The constant input holds a single element and its length is infinite.
To access the field `U`, you can use Base's `iterate` given a state, or the method
 `nextinput` given the number of desired input elements:

```jldoctest constant_input
julia> c = ConstantInput(-1//2)
ConstantInput{Rational{Int64}}(-1//2)

julia> iterate(c, 1)
(-1//2, nothing)

julia> iterate(c, 2)
(-1//2, nothing)

julia> collect(nextinput(c, 4))
4-element Vector{Rational{Int64}}:
 -1//2
 -1//2
 -1//2
 -1//2
```

The elements of this input are rational numbers:

```jldoctest constant_input
julia> eltype(c)
Rational{Int64}
```

To transform a constant input, you can use `map` as in:

```jldoctest constant_input
julia> map(x->2*x, c)
ConstantInput{Rational{Int64}}(-1//1)
```
"""
struct ConstantInput{UT} <: AbstractInput
    U::UT
end

Base.eltype(::Type{ConstantInput{UT}}) where {UT} = UT
Base.iterate(input::ConstantInput, state::Union{Int, Nothing}=nothing) = (input.U, nothing)
Base.IteratorSize(::Type{<:ConstantInput}) = Base.IsInfinite()

# the following does not need to be defined because it is the default:
# Base.IteratorEltype(::Type{<:ConstantInput}) = Base.HasEltype()

Base.map(f::Function, c::ConstantInput) = ConstantInput(f(c.U))

"""
    nextinput(input::ConstantInput, n::Int=1)

Returns the first `n` elements of this input.

### Input

- `input` -- a constant input
- `n`     -- (optional, default: `1`) the number of desired elements

### Output

A repeated iterator that generates `n` equal samples of this input.
"""
nextinput(input::ConstantInput, n::Int=1) = Base.Iterators.repeated(input.U, n)

"""
    VaryingInput{UT, VUT<:AbstractVector{UT}} <: AbstractInput

Type representing an input that may vary with time.

### Fields

- `U` -- vector of input sets

### Examples

The varying input holds a vector and its length equals the number
of elements in the vector. Consider an input given by a vector of rational numbers:

```jldoctest varying_input
julia> v = VaryingInput([-1//2, 1//2])
VaryingInput{Rational{Int64}, Vector{Rational{Int64}}}(Rational{Int64}[-1//2, 1//2])

julia> length(v)
2

julia> eltype(v)
Rational{Int64}
```

Base's `iterate` method receives the input and an integer state and returns the
input element and the next iteration state:

```jldoctest varying_input
julia> iterate(v, 1)
(-1//2, 2)

julia> iterate(v, 2)
(1//2, 3)
```

The method `nextinput` receives a varying input and an integer `n` and returns
an iterator over the first `n` elements of this input (where `n=1` by default):

```jldoctest varying_input
julia> typeof(nextinput(v))
Base.Iterators.Take{VaryingInput{Rational{Int64}, Vector{Rational{Int64}}}}

julia> collect(nextinput(v, 1))
1-element Vector{Rational{Int64}}:
 -1//2

julia> collect(nextinput(v, 2))
2-element Vector{Rational{Int64}}:
 -1//2
  1//2
```

You can collect the inputs in an array, or equivalently use list comprehension,
(or use a `for` loop):

```jldoctest varying_input
julia> collect(v)
2-element Vector{Rational{Int64}}:
 -1//2
  1//2

julia> [2*vi for vi in v]
2-element Vector{Rational{Int64}}:
 -1//1
  1//1
```

Since this input type is finite, querying more elements than its length returns
the full vector:

```jldoctest varying_input
julia> collect(nextinput(v, 4))
2-element Vector{Rational{Int64}}:
 -1//2
  1//2
```

To transform a varying input, you can use `map` as in:

```jldoctest varying_input
julia> map(x->2*x, v)
VaryingInput{Rational{Int64}, Vector{Rational{Int64}}}(Rational{Int64}[-1//1, 1//1])
```
"""
struct VaryingInput{UT, VUT<:AbstractVector{UT}} <: AbstractInput
    U::VUT  # input sequence
end

Base.eltype(::Type{VaryingInput{UT, VUT}}) where {UT, VUT} = UT

function Base.iterate(input::VaryingInput, state::Int=1)
    if state > length(input.U)
        return nothing
    else
        return (input.U[state], state + 1)
    end
end

Base.length(input::VaryingInput) = length(input.U)

# the following do not need to be defined because they are the default:
# Base.IteratorSize(::Type{<:VaryingInput}) = Base.HasLength()
# Base.IteratorEltype(::Type{<:VaryingInput}) = Base.HasEltype()

Base.map(f::Function, v::VaryingInput) = VaryingInput(f.(v.U))

"""
    nextinput(input::VaryingInput, n::Int=1)

Returns the first `n` elements of this input.

### Input

- `input` -- varying input
- `n`     -- (optional, default: `1`) number of desired elements

### Output

An iterator of type `Base.Iterators.Take` that represents at most the first
`n` elements of this input.
"""
nextinput(input::VaryingInput, n::Int=1) = Base.Iterators.take(input, n)
