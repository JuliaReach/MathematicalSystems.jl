using LinearAlgebra: inv, rank
using SparseArrays: spzeros
using InteractiveUtils: subtypes

import Base.==
import Base.≈

export _corresponding_type, discretize

function ==(sys1::AbstractSystem, sys2::AbstractSystem)
    if typeof(sys1)!== typeof(sys2)
        return false
    end
    for field in fieldnames(typeof(sys1))
        if getfield(sys1, field) != getfield(sys2, field)
            return false
        end
    end
    return true
end

function ≈(sys1::AbstractSystem, sys2::AbstractSystem)
    if typeof(sys1)!== typeof(sys2)
        return false
    end
    for field in fieldnames(typeof(sys1))
        if !(getfield(sys1, field) ≈ getfield(sys2, field))
            return false
        end
    end
    return true
end

function _corresponding_type(sys::AbstractSystem)
    sys_type = typeof(sys)
    return _corresponding_type(sys_type)
end

function _corresponding_type(sys_type::Type{<:AbstractSystem})
    fields = fieldnames(sys_type)
    if supertype(sys_type) == AbstractDiscreteSystem
        abstract_type = AbstractContinuousSystem
    else
        abstract_type = AbstractDiscreteSystem
    end
    return _corresponding_type(abstract_type, fields)
end

function _corresponding_type(abstract_type, fields::Tuple)
      @show abstract_type, fields
    TYPES = subtypes(abstract_type)
    TYPES_FIELDS = fieldnames.(TYPES)
    is_in(x, y) = all([el ∈ y for el in x])
    idx = findall(x -> is_in(x, fields) && is_in(fields,x), TYPES_FIELDS)
    if length(idx) == 0
        error("$(fields) does not match any system type of MathematicalSystems")
    end
    return TYPES[idx][1]
end

function discretize(sys::AbstractContinuousSystem, ΔT::Real; algorithm=:default)
    noset(x) = !(x ∈ [:X,:U,:W])
    fields = collect(fieldnames(typeof(sys)))
    cont_nonset_values = [getfield(sys, f) for f in filter(noset, fields)]
    if algorithm == :default
        if rank(sys.A) == size(sys.A, 1)
          # A is invertible, use exact discretizaion
          algorithm = :exact
        else
          # A is not invertible, use approximative discretizaion
          algorithm = :euler
        end
    end
    disc_nonset_values = _discretize_arrays(cont_nonset_values...,ΔT;
                                            algorithm=algorithm)
    set_values = [getfield(sys, f) for f in filter(!noset, fields)]
    discrete_type = _corresponding_type(sys)
    return discrete_type(disc_nonset_values..., set_values...)
end

function _discretize_arrays(A::AbstractMatrix,
                            B::AbstractMatrix,
                            c::AbstractVector,
                            D::AbstractMatrix, ΔT::Real; algorithm=:exact)
    if algorithm == :exact
        A_d = exp(A*ΔT)
        B_d = inv(A)*(A_d - I)*B
        c_d = inv(A)*(A_d - I)*c
        D_d = inv(A)*(A_d - I)*D
    elseif algorithm == :euler
        A_d = (I + ΔT*A)
        B_d = ΔT*B
        c_d = ΔT*c
        D_d = ΔT*D
    else
        error("discretization algorithm $algorithm is not known")
    end
    return [A_d, B_d, c_d, D_d]
end

function _discretize_arrays(A::AbstractMatrix, ΔT::Real; algorithm=:exact)
    n = size(A,1)
    A_d, _, _, _ = _discretize_arrays(A, spzeros(n,n), spzeros(n), spzeros(n,n), ΔT;
                              algorithm=algorithm)
    return [A_d]
end

# works for (:A,:D) and (:A, :B)
function _discretize_arrays(A::AbstractMatrix,
                            B::AbstractMatrix, ΔT::Real; algorithm=:exact)
    n = size(A,1)
    A_d, B_d, c_d, D_d = _discretize_arrays(A, B, spzeros(n), spzeros(n,n), ΔT;
                                    algorithm=algorithm)
    return [A_d, B_d]
end

function _discretize_arrays(A::AbstractMatrix,
                    c::AbstractVector, ΔT::Real; algorithm=:exact)
    n = size(A,1)
    A_d, B_d, c_d, D_d = _discretize_arrays(A, spzeros(n,n), c, spzeros(n,n), ΔT;
                                    algorithm=algorithm)
    return [A_d, c_d]
end

function _discretize_arrays(A::AbstractMatrix,
                            B::AbstractMatrix,
                            c::AbstractVector, ΔT::Real; algorithm=:exact)
    n = size(A,1)
    A_d, B_d, c_d, D_d = _discretize_arrays(A, B, c, spzeros(n,n), ΔT;
                                    algorithm=algorithm)
    return [A_d, B_d, c_d]
end

function _discretize_arrays(A::AbstractMatrix,
                            B::AbstractMatrix,
                            D::AbstractMatrix, ΔT::Real; algorithm=:exact)
    n = size(A,1)
    A_d, B_d, c_d, D_d = _discretize_arrays(A, B, spzeros(n), D, ΔT;
                                    algorithm=algorithm)
    return [A_d, B_d, D_d]
end
