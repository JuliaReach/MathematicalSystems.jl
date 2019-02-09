using Espresso

"""
    map(ex)

Returns an instance of the map type corresponding to the given expression.

### Input

- `ex` -- an expression defining the map, in the form of an anonymous function

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
"""
macro map(ex)
    quote
        local x = $(ex.args)[1]
        local rhs = $(ex.args)[2].args[2]

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
