module TestTSort

using JuliaMBD
using JuliaMBD: tsort, tsort2, toexpr, expr
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

@testset "tsort2" begin
    x = AbstractBlock[]
    x1 = InBlock(:x1)
    push!(x, x1)
    x2 = InBlock(:x2)
    push!(x, x2)
    x3 = InBlock(:x3)
    push!(x, x3)
    x4 = OutBlock(:x4)
    push!(x, x4)

    println(x1, x2, x3, x4)
    x1 => x2 
    x3 => x4

    println([expr(v) for v = toexpr(x)[1]])
    println([expr(v) for v = tsort(toexpr(x)[1])])
    println(toexpr(x)[2])
end

end
