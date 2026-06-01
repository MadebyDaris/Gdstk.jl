using Documenter
using Gdstk

makedocs(
    sitename = "Gdstk.jl",
    format = Documenter.HTML(),
    modules = [Gdstk],
    pages = [
        "Home" => "index.md",
        "API Reference" => "api.md"
    ],
    remotes = nothing,
    checkdocs = :none,
    warnonly = true
)

deploydocs(
    repo = "github.com/MadebyDaris/Gdstk.jl.git",
)
