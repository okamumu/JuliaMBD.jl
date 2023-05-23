using JuliaMBD
using Documenter

DocMeta.setdocmeta!(JuliaMBD, :DocTestSetup, :(using JuliaMBD); recursive=true)

makedocs(;
    modules=[JuliaMBD],
    authors="Hiroyuki Okamura <okamu@hiroshima-u.ac.jp> and contributors",
    repo="https://github.com/okamumu/JuliaMBD.jl/blob/{commit}{path}#{line}",
    sitename="JuliaMBD.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://okamumu.github.io/JuliaMBD.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/okamumu/JuliaMBD.jl",
    devbranch="main",
)
