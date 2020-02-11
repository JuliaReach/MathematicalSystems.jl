import Base: ==

# syntactic equality of systems
function ==(sys1::AbstractSystem, sys2::AbstractSystem)
    if typeof(sys1) != typeof(sys2)
        return false
    end
    for field in fieldnames(typeof(sys1))
        if getfield(sys1, field) != getfield(sys2, field)
            return false
        end
    end
    return true
end

# approximate equality of systems
function Base.isapprox(sys1::AbstractSystem, sys2::AbstractSystem; kwargs...)
    if typeof(sys1) != typeof(sys2)
        return false
    end
    for field in fieldnames(typeof(sys1))
        if !isapprox(getfield(sys1, field), getfield(sys2, field); kwargs...)
            return false
        end
    end
    return true
end

"""
    typename(system::AbstractSystem)

Returns the base type of `system` without parameter information.

### Input

- `system` -- `AbstractSystem`

### Output

The base type of `system`.

"""
function typename(system::AbstractSystem)
    return Base.typename(typeof(system)).wrapper
end

"""
    _complementary_type(system_type::Type{<:AbstractSystem})

Return the complementary type of a system type `system_type`.

### Input

- `system_type` -- type of `AbstractSystem`

### Ouput

Return complementary type of `system_type`.

### Notes

There are two main subclasses of abstract types: continuous types and discrete
types. A complementary type of `system_type` has the same fields as `system_type`
but belongs to the other subclass, e.g. for a `LinearContinuousSystem` which is
a subtype of `AbstractContinuousSystem` and has the field `:A`, the subtype of
`AbstractDiscreteSystem` with the field `:A`, i.e. `LinearDiscreteSystem`,
is returned.

To get the complementary type of system type, use
`_complementary_type(typename(system))`.
"""
@generated function _complementary_type(type::Type{<:AbstractSystem})
    system_type = type.parameters[1]
    type_string = string(system_type)
    if supertype(system_type) == AbstractDiscreteSystem
        type_string = replace(type_string, "Discrete"=>"Continuous")
    elseif supertype(system_type) == AbstractContinuousSystem
        type_string = replace(type_string, "Continuous"=>"Discrete")
    else
        error("$system_type <: $(supertype(system_type)) is neither discrete nor continuous")
    end
    return Meta.parse(type_string)
end
