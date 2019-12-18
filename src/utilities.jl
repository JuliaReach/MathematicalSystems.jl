import Base: ==

function ==(sys1::AbstractSystem, sys2::AbstractSystem)
    if typeof(sys1) != typeof(sys2)
        return false
    end
    for field in fieldnames(typeof(sys1))
        if !(getfield(sys1, field) == getfield(sys2, field))
            return false
        end
    end
    return true
end

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
