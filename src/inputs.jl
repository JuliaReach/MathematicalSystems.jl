"""
    AbstractInput

Abstract supertype for all input types.
"""
abstract type AbstractInput end

Base.start(::AbstractInput) = 1

"""
    ConstantInput{UT} <: AbstractInput

Type representing an input that remains constant in time.

### Fields

- `U` -- input set
"""
struct ConstantInput{UT} <: AbstractInput
    U::UT
end

Base.next(inputs::ConstantInput, state) = (inputs.U, state + 1)
Base.done(inputs::ConstantInput, state) = state > 1
Base.length(inputs::ConstantInput) = 1
Base.iteratorsize(::ConstantInput) = IsInfinite()

next_input(inputs::ConstantInput, state::Int) = inputs.U
next_input(inputs::ConstantInput) = inputs.U

"""
    VaryingInput{UT} <: AbstractInput

Type representing an input that may vary with time.

### Fields

- `U` -- vector of input sets
"""
struct VaryingInput{UT} <: AbstractInput
    U::AbstractVector{<:UT}  # input sequence
end

Base.next(inputs::VaryingInput, state) = (inputs.U[state], state + 1)
Base.done(inputs::VaryingInput, state) = state > length(inputs.U)
Base.length(inputs::VaryingInput) = length(inputs.U)

next_input(inputs::VaryingInput, state::Int) = inputs.U[state]
