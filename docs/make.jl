using Documenter, MathematicalSystems
import LazySets

DocMeta.setdocmeta!(MathematicalSystems, :DocTestSetup,
                    :(using MathematicalSystems); recursive=true)

makedocs(
    sitename = "MathematicalSystems.jl",
    modules = [MathematicalSystems],
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true",
                             assets = ["assets/aligned.css"]),
    strict = true,
    pages = [
        "Home" => "index.md",
        "Manual" => Any["System types overview" => "man/systems.md"],
        "Library" => Any[
            "Types"     => "lib/types.md",
            "Methods"   => "lib/methods.md",
            "Internals" => "lib/internals.md"
        ],
        "About" => "about.md"
    ]
)

deploydocs(
    repo = "github.com/JuliaReach/MathematicalSystems.jl.git",
    push_preview = true
)
