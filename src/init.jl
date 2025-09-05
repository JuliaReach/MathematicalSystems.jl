# optional dependencies
@static if !isdefined(Base, :get_extension)
    using Requires
end

@static if !isdefined(Base, :get_extension)
    function __init__()
        @require LazySets = "b4f0291d-fe17-52bc-9479-3d1a343d9043" include("../ext/LazySetsExt.jl")
    end
end
