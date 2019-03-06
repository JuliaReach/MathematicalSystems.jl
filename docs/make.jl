using Documenter, MathematicalSystems

makedocs(
    modules = [MathematicalSystems],
    # See https://github.com/JuliaDocs/Documenter.jl/issues/868
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"),
    assets = ["assets/juliareach.css"],
    sitename = "MathematicalSystems.jl",
    pages = [
        "Home" => "index.md",
        "Library" => Any[
        "Types" => "lib/types.md",
        "Methods" => "lib/methods.md"],
        "About" => "about.md"
    ],
    strict = true
)

deploydocs(
    repo = "github.com/JuliaReach/MathematicalSystems.jl.git",
    target = "build",
    julia = "1.1",
    deps = nothing,
    make = nothing
)
