using Documenter, MathematicalSystems

makedocs(
    doctest = true,
    modules = [MathematicalSystems],
    format = :html,
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
    julia = "1.1",
    deps = nothing,
    make = nothing
)
