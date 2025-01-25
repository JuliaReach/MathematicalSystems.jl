using Documenter, MathematicalSystems, DocumenterCitations
import LazySets

DocMeta.setdocmeta!(MathematicalSystems, :DocTestSetup,
                    :(using MathematicalSystems); recursive=true)

bib = CitationBibliography(joinpath(@__DIR__, "src", "refs.bib"); style=:alpha)

makedocs(; sitename="MathematicalSystems.jl",
         modules=[MathematicalSystems],
         format=Documenter.HTML(; prettyurls=get(ENV, "CI", nothing) == "true",
                                assets=["assets/aligned.css", "assets/citations.css"],
                                size_threshold_warn=150 * 2^10),
         pagesonly=true,
         plugins=[bib],
         pages=["Home" => "index.md",
                "Manual" => Any["Overview of System Types" => "man/systems.md"],
                "Library" => Any["Types"     => "lib/types.md",
                                 "Methods"   => "lib/methods.md",
                                 "Internals" => "lib/internals.md"],
                "Bibliography" => "bibliography.md",
                "About" => "about.md"])

deploydocs(; repo="github.com/JuliaReach/MathematicalSystems.jl.git",
           push_preview=true)
