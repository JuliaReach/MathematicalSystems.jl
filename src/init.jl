# optional dependencies
@static if !isdefined(Base, :get_extension)
    using Requires: @require
end

@static if !isdefined(Base, :get_extension)
    function __init__()
        @require LazySets = "b4f0291d-fe17-52bc-9479-3d1a343d9043" include("../ext/LazySetsExt.jl")
        @require RecipesBase = "3cdcf5f2-1ef4-517c-9805-6587b60abb01" include("../ext/RecipesBaseExt.jl")
    end
end
