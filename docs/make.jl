using Documenter, MathematicalSystems

makedocs(
    doctest = true,  # use this flag to skip doctests (saves time!)
    modules = [MathematicalSystems],
    format = Documenter.HTML(),
    assets = ["assets/juliareach.css"],
    sitename = "MathematicalSystems.jl",
    pages = [
        "Home" => "index.md",
        "Library" => Any[
        "Types" => "lib/types.md",
        "Methods" => "lib/methods.md"],
        "About" => "about.md"
    ]
)

deploydocs(
    repo = "github.com/JuliaReach/MathematicalSystems.jl.git",
    target = "build",
    osname = "linux",
    deps = nothing,
    make = nothing
)
