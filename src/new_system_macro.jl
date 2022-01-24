using MLStyle.AbstractPatterns: init_cfg
using MLStyle.MatchImpl: gen_match
using MLStyle: @match

# See MLStyle#133 (remove when released)
macro trymatch(val, tbl)
    Meta.isexpr(tbl, :block) || (tbl = Expr(:block, tbl))
    push!(tbl.args, :(_ => nothing))
    res = gen_match(val, tbl, __source__, __module__)
    res = init_cfg(res)
    esc(res)
end

macro tryreturn(val, tbl)
    Meta.isexpr(tbl, :block) || (tbl = Expr(:block, tbl))
    push!(tbl.args, :(_ => return))
    res = gen_match(val, tbl, __source__, __module__)
    res = init_cfg(res)
    esc(res)
end
tryparse(::Type{<:AbstractSystem}, syseq, cons...) = nothing

macro system_new(syseq, cons...)
    Base.remove_linenums!(syseq)
    sys = [tryparse(ST, syseq, cons...) for ST in subtypes(AbstractContinuousSystem)]
    filter!(!isnothing, sys) 
    if length(sys) == 1
        esc(sys[1])
    elseif isempty(sys)
        throw(ArgumentError("no system type found matching the given expressions"))
    elseif length(sys) > 1
        throw(ArgumentError("non-unique system type found matching the given expressions"))
    end
end