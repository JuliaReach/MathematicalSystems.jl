using Documenter, Systems

makedocs(
    doctest = true,  # use this flag to skip doctests (saves time!)
    modules = [Systems],
    format = :html,
    assets = ["assets/juliareach.css"],
    sitename = "Systems.jl",
    pages = [
        "Home" => "index.md",
        "Library" => Any[
        "Types" => "lib/types.md",
        "Methods" => "lib/methods.md"],
        "About" => "about.md"
    ]
)

deploydocs(
    repo = "github.com/JuliaReach/Systems.jl.git",
    target = "build",
    osname = "linux",
    julia  = "0.6",
    deps = Deps.pip("mkdocs", "python-markdown-math"),
    make = nothing
)