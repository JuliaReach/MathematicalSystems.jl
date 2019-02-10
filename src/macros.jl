using Espresso: matchex

"""
    map(ex, dom)

Returns an instance of the map type corresponding to the given expression.

### Input

- `ex`  -- an expression defining the map, in the form of an anonymous function
- `dom` -- additional optional arguments

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

An identity map can alternatively been used by giving a the size of the identity
matrix as `I(n)`, for example:

```jldoctest
julia> @map x -> I(5)*x
IdentityMap(5)
```
"""
macro map(ex, dom)
    quote
        local x = $(ex.args)[1]
        local rhs = $(ex.args)[2].args[2]

        # x -> x, dom=...
        MT = IdentityMap
        local pat = Meta.parse("$x")
        local matched = matchex(pat, rhs)
        matched != nothing && return MT($dom)

        throw(ArgumentError("unable to match the given expression to a known map type"))
    end
end

macro map(ex)
    quote
        local x = $(ex.args)[1]
        local rhs = $(ex.args)[2].args[2]

        # x -> I(n)*x
        # (this rule is more specific than x -> Ax so it should come before it)
        MT = IdentityMap
        pat = Meta.parse("I(_n) * $x")
        matched = matchex(pat, rhs)
        matched != nothing && return MT(eval(matched[:_n]))

        # x -> Ax 
        MT = LinearMap
        local pat = Meta.parse("_A * $x")
        local matched = matchex(pat, rhs)
        matched != nothing && return MT(eval(matched[:_A]))

        # x -> Ax + b
        MT = AffineMap
        pat = Meta.parse("_A * $x + _b")
        matched = matchex(pat, rhs)
        matched != nothing && return MT(eval(matched[:_A]), eval(matched[:_b]))

        throw(ArgumentError("unable to match the given expression to a known map type"))
    end
end
