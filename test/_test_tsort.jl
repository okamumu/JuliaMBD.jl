module TestTSort

using JuliaMBD
using JuliaMBD: tsort, tsort2
using Test

@testset "tsort1" begin
    x = AbstractBlock[]
    x1 = InBlock(:x1)
    push!(x, x1)
    x2 = InBlock(:x2)
    push!(x, x2)
    x3 = InBlock(:x3)
    push!(x, x3)
    x4 = InBlock(:x4)
    push!(x, x4)

    println(x1, x2, x3, x4)
    x1 => x2 
    x3 => x4

    println(tsort2(x))
end

end
