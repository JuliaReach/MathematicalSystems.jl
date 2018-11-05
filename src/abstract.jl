"""
    AbstractSystem

Abstract supertype for all system types.
"""
abstract type AbstractSystem end

"""
    statedim(s::AbstractSystem)

Returns the dimension of the state space of system `s`.
"""
function statedim end

"""
    stateset(s::AbstractSystem)

Returns the set of allowed states of system `s`.
"""
function stateset end

"""
    inputdim(s::AbstractSystem)

Returns the dimension of the input space of system `s`.
"""
function inputdim end

"""
    inputset(s::AbstractSystem)

Returns the set of allowed inputs of system `s`.
"""
function inputset end

"""
    AbstractDiscreteSystem

Abstract supertype for all discrete system types.
"""
abstract type AbstractDiscreteSystem <: AbstractSystem end

"""
    AbstractContinuousSystem

Abstract supertype for all continuous system types.
"""
abstract type AbstractContinuousSystem <: AbstractSystem end

"""
    AbstractMap

Abstract supertype for all map types.
"""
abstract type AbstractMap end

"""
    outputdim(m::AbstractMap)

Returns the dimension of the output space of the map `m`.
"""
function outputdim end

"""
    outputmap(s::SystemWithOutput)

Returns the output map of a system with output.
"""
function outputmap end
