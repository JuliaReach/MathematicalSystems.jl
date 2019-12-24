using Espresso: matchex

"""
    map(ex, args)

Returns an instance of the map type corresponding to the given expression.

### Input

- `ex`   -- an expression defining the map, in the form of an anonymous function
- `args` -- additional optional arguments

### Output

A map that best matches the given expression.

### Examples

Let us first create a linear map using this macro:

```jldoctest
julia> @map x -> [1 0; 0 0]*x
LinearMap{Int64,Array{Int64,2}}([1 0; 0 0])
```

We can create an affine system as well:

```jldoctest
julia> @map x -> [1 0; 0 0]*x + [2, 0]
AffineMap{Int64,Array{Int64,2},Array{Int64,1}}([1 0; 0 0], [2, 0])
```

Additional arguments can be passed to `@map` using the function-call form, i.e.
separating the arguments by commas, and using parentheses around the macro call.
For exmple, an identity map of dimension 5 can be defined as:

```jldoctest
julia> @map(x -> x, dim=5)
IdentityMap(5)
```

An identity map can alternatively be created by giving a the size of the identity
matrix as `I(n)`, for example:

```jldoctest
julia> @map x -> I(5)*x
IdentityMap(5)
```
"""
macro map(ex, args)
    quote
        local x = $(ex.args)[1]
        local rhs = $(ex.args)[2].args[2]

        # x -> x, dim=...
        MT = IdentityMap
        local pat = Meta.parse("$x")
        local matched = matchex(pat, rhs)
        matched != nothing && return MT($args)

        throw(ArgumentError("unable to match the given expression to a known map type"))
    end
end
macro map(ex)
    x = (ex.args)[1]
    rhs = (ex.args)[2].args[2]

    # x -> I(n)*x
    # (this rule is more specific than x -> Ax so it should come before it)
    MT = IdentityMap
    pat = Meta.parse("I(_n) * $x")
    matched = matchex(pat, rhs)
    matched != nothing &&
        return Expr(:call, :($MT), esc(:($(matched[:_n]))))

    # x -> Ax
    MT = LinearMap
    pat = Meta.parse("_A * $x")
    matched = matchex(pat, rhs)
    matched != nothing &&
        return Expr(:call, :($MT), esc(:($(matched[:_A]))))

    # x -> Ax + b
    MT = AffineMap
    pat = Meta.parse("_A * $x + _b")
    matched = matchex(pat, rhs)
    matched != nothing &&
        return Expr(:call, :($MT), esc(:($(matched[:_A]))), esc(:($(matched[:_b]))))

    throw(ArgumentError("unable to match the given expression to a known map type"))
end



# @System Macro ================================================================
# Autors: @mforets, @ueliwechsler
using LinearAlgebra: I
using MacroTools: @capture
using InteractiveUtils: subtypes
export @system

function corresponding_type(abstract_type, fields::Tuple)
    TYPES = subtypes(abstract_type)
    TYPES_FIELDS = fieldnames.(TYPES)
    is_in(x, y) = all([el ∈ y for el in x])
    idx = findall(x -> is_in(x, fields) && is_in(fields,x), TYPES_FIELDS)
    if length(idx) == 0
        error("The entry $(fields) does not match a MathematicalSystem structure.")
    end
    return TYPES[idx][1]
end

# return the tuple containing the dimension(s) in `f_dims`
# order of if, elseif, elseif is important!!
function _capture_dim(f_dims)
    if @capture(f_dims, (x_, u_, w_))
        dims = [x, u, w]
    elseif @capture(f_dims, (x_, u_))
        dims = [x, u]
    elseif @capture(f_dims, (x_))
        dims = x
    else
        throw(ArgumentError("the dimensions $f_dims could not be parsed; " *
            "see the documentation for valid examples"))
    end
    return dims
end

# return `true` if the given expression `expr` corresponds to an equation `lhs = rhs`
# and `false` otherwise. This function just detects the presence of the symbol `=`.
function is_equation(expr)
    return @capture(expr, lhs_ = rhs_)
end

# return the tuple `(true, AT)` if the given expression `expr` corresponds to a dynamic equation,
# either of the form `x⁺ = rhs` or `x' = rhs` and `false` otherwise, in the former
# case `AT = AbstractDiscreteSystem` and in the latter `AT = AbstractContinuousSystem`
# otherwise, return `(false, nothing)`

# returns `(equation, AT, state)` if `expr` if the given expression `expr`
# corresponds to a dynamic equation, either of the form `x⁺ = rhs` or `x' = rhs`
#  in the former case `AT = AbstractDiscreteSystem` and in the latter
# `AT = AbstractContinuousSystem`. The equation is `x = rhs` where the superscript
# is stripped from the expression and the state corresponds to `x`,
# otherwise, return `(nothing, nothing, nothing)`
function strip_dynamic_equation(expr)
    expr_str = string(expr)
    stripped_equation = ""
    if occursin("'", expr_str)
        AT = AbstractContinuousSystem
        stripped_equation =  replace(expr_str, "'" => "")
    elseif occursin("⁺", expr_str)
        AT = AbstractDiscreteSystem
        stripped_equation =  replace(expr_str, "⁺" => "")
    end
    stripped_expr = Meta.parse(stripped_equation)
    !@capture(stripped_expr, lhs_ = rhs_) && return (nothing, nothing, nothing)

    if @capture(lhs, (E_*x_)) || @capture(lhs, (x_))
        state = x
        return (stripped_expr, AT, state)
    end
    return (nothing, nothing, nothing)
end

function parse_system(exprs)

    # define default dynamic equation, unknown abstract system type,
    # and empty list of constraints
    dynamic_equation = nothing
    state_var = :x
    AT = nothing
    constraints = Vector{Expr}()

    # define default input symbol and default dimension
    noise_var = :w
    dimension = nothing

    # main loop to parse the subexpressions in exprs
    for ex in exprs

        if is_equation(ex)  # parse an equation
            (stripped, abstract_system_type, subject) = strip_dynamic_equation(ex)
            if subject != nothing
                dynamic_equation = stripped
                state_var = subject
                AT = abstract_system_type
            elseif @capture(ex, (dim = (f_dims_)) | (dims = (f_dims_)))
                dimension = _capture_dim(f_dims)
            elseif @capture(ex, (noise = w_) | (w_ = noise))
                noise_var = w
            else
                throw(ArgumentError("could not properly parse the equation $ex; " *
                                    "see the documentation for valid examples"))
            end

        elseif @capture(ex, state_ ∈ Set_)  # parse a constraint
            push!(constraints, ex)

        elseif @capture(ex, (noise: w_) | (w_: noise))  # parse a noise symbol
            noise_var = w

        elseif @capture(ex, (dim: (f_dims_)) | (dims: (f_dims_)))  # parse a dimension
            dimension = _capture_dim(f_dims)

        else
            throw(ArgumentError("the expression $ex could not be parsed; " *
                                "see the documentation for valid examples"))
        end
    end

    # error handling for the given equations
    dynamic_equation == nothing && error("the dynamic equation was not found")

    # error handling for the given set constraints
    nsets = length(constraints)
    nsets > 3 && error("cannot parse $nsets set constraints")

    return dynamic_equation, state_var, AT, constraints, noise_var, dimension
end

# extract the field and value parameter from the dynamic equation `equation`
# in the form `rhs = [(:A_user, :A), (:B_user, :B), ....]` and
# `lhs = [(:E_user, :E)]` or `lhs = Any[]`
function extract_dyn_equation_parameters(equation, state, noise, dim, AT)
    @capture(equation, lhs_ = rhscode_)
    # a multiplication sign * needs to be used
    lhs_params = Any[]
    rhs_params = Any[]
    # if a * is used on the lhs, the rhs is a code-block
    if  @capture(lhs, E_*x_)
        push!(lhs_params, (E, :E))
        rhs = rhscode.args[end]
    else
        rhs = rhscode
    end
    @show lhs, rhs
    if @capture(rhs, A_ + B__) # If rhs is a sum
        @show summands = add_asterisk.([A, B...], Ref(state), Ref(noise))
        push!(rhs_params, extract_sum(summands, state, noise)...)
    elseif @capture(rhs, f_(a__))  && f != :(*) # If rhs is function call
        # the dimension argument needs to be a iterable
        @show dim
        (dim == nothing) && error("for a blackbox system, the dimension has to be defined")
        dim_vec = [dim...]
        push!(rhs_params, extract_function(rhs, dim_vec)...)
    else # if rhs is a single term (eith A*x, Ax, 2x, x or 0)
        if rhs == state
            if AT == AbstractDiscreteSystem
                push!(rhs_params, (dim, :statedim))
            elseif AT == AbstractContinuousSystem
                push!(rhs_params, (Matrix{Int}(I, dim, dim), :A))
            end
        elseif rhs == :(0) && AT == AbstractContinuousSystem
            push!(rhs_params, (dim, :statedim))
        else
            rhs = add_asterisk(rhs, state, noise)
            if @capture(rhs, array_ * var_)
                if state == var
                    value = tryparse(Float64, string(array))
                    if value == nothing
                        push!(rhs_params, (array, :A))
                    else
                        push!(rhs_params, (value*Matrix{Int}(I, dim, dim), :A))
                    end
                else
                    throw(ArgumentError("if there is only one term on the right side, it needs to"*
                            " include the state."))
                end
            end
        end
    end
    return lhs_params, rhs_params
end


# CAVEAT: This function "adds" most of the restriction to the API of @system
# if there are no * used in the equation.
# add a asterisk * to a expression, if the expression itself is not yet in the
# form `Expr(:call, :*, :A, :x)`. It checks if the expression if contains the
# value of  `state` or `noise` at the its end and separates the expreseion accoridngly,
# if neither is true, it checks if `expr` has only one letter, then it is assumed to
# be a constant and otherwise, it assume there is a one letter input.
# Examples:
# add_asterisk(:(A1*x), :x, :w) # :(A1*x)
# add_asterisk(:(A1x12), :x12, :w) # :(A1*x12)
# add_asterisk(:(A1w12), :x, :w12) # :(A1*w12)
# add_asterisk(:(A1u), :x, :w) # :(A1*u)
# add_asterisk(:(A1ub), :x, :w) # :(A1u*b)
# add_asterisk(:(d), :x, :w) # :(d)
function add_asterisk(summand, state, noise)
    if @capture(summand, A_ * x_)
        return summand
    end
    # the constant term needs to be a single chars, and if there
    # are no *, also the variables need to be single chars
    str = string(summand)
    if length(str) == 1
        return summand
    else
        statestr = string(state); lenstate = length(statestr)
        noisestr = string(noise); lennoise = length(noisestr)
        if lenstate < length(str) && str[(end-lenstate+1):end] == statestr
            return Meta.parse(str[1:end-length(statestr)]*"*$state")
        elseif lennoise < length(str) && str[(end-lennoise+1):end] == noisestr
            return Meta.parse(str[1:end-length(noisestr)]*"*$noise")
        else
            return Meta.parse(str[1:end-1]*"*"*str[end])
        end
    end
end

# # call to * with right argument equals state => state matrix
# extract(:(A1*x), :x, :w) # (:A1, :A)
# # call to * with right argument equals noise => noise matrix
# extract(:(A2*w), :x, :w) # (:A2, :D)
# # call to * with right argument not equals state or  noise = input matrix
# extract(:(A3*u), :x, :w) # (:A3, :B)
# # single expression => const term
# extract(:(u), :x, :w) # (:u, :c)
function extract_sum(summands, state::Symbol, noise::Symbol)
    params = Any[]
    for summand in summands
        if @capture(summand, array_ * var_)
            @show array, var
            if state == var
                push!(params, (array, :A))
            elseif noise == var
                push!(params, (array, :D))
            else
                push!(params, (array, :B))
                # input = var # => return this to check if constraints are correctly defined
            end
        elseif @capture(summand, array_)
            push!(params, (array, :c))
        end
    end
    return params
end

function extract_function(rhs, dim::AbstractVector)
    @show dim
    if @capture(rhs, f_(x_))
        @assert length(dim) == 1
        return [(f, :f), (dim[1], :statedim)]
    elseif @capture(rhs, f_(x_,u_))
        @assert length(dim) == 2
        return [(f, :f), (dim[1], :statedim),
                         (dim[2], :inputdim)]
    elseif @capture(rhs, f_(x_,u_,w_))
        @assert length(dim) == 3
        return [(f, :f), (dim[1], :statedim),
                         (dim[2], :inputdim),
                         (dim[3], :noisedim)]
    end
end

function constructor_input(lhs, rhs, set)
    rhs_fields = [tuple[2] for tuple in rhs]
    lhs_fields = [tuple[2] for tuple in lhs]
    set_fields = [tuple[2] for tuple in set]
    (length(unique(set_fields)) != length(set_fields)) &&
        error("There is some ambiguity in the set definition")
    rhs_var_names = [tuple[1] for tuple in rhs]
    lhs_var_names = [tuple[1] for tuple in lhs]
    set_var_names = [tuple[1] for tuple in set]
    field_names = (rhs_fields..., lhs_fields..., set_fields...)
    var_names = (rhs_var_names..., lhs_var_names..., set_var_names...)
    return field_names, var_names
end

function expand_set(expr, state, noise) # input => to check set definitions
    if @capture(expr, x_ ∈ Set_)
        if x == state
            return  Set, :X
        elseif x == noise
            return  Set, :W
        else
            return  Set, :U
        end
    end
    error("The set-entry $(expr) does not have the correct form")
end

macro system(expr...)
    if typeof(expr) == :Expr
        dyn_eq, state, AT, constr, noise, dim = parse_system([expr])
    else
        dyn_eq, state, AT, constr, noise, dim = parse_system(expr)
    end
    lhs, rhs = extract_dyn_equation_parameters(dyn_eq, state, noise, dim, AT)
    set = expand_set.(constr, state, noise)
    field_names, var_names = constructor_input(lhs, rhs, set)
    sys_type = corresponding_type(AT, field_names)
    return  esc(Expr(:call, :($sys_type), :($(var_names...))))
end
