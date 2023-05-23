module TestLines

using JuliaMBD
using JuliaMBD: get_line, get_lines, get_source, get_name
using JuliaMBD: expr_refvalue, expr_setvalue
using Test

@testset "line1" begin
    x = InPort(:x)
    y = OutPort(:y)
    y => x
    @test get_name(get_source(get_line(x))) == :y
end

@testset "line2" begin
    x = InPort(:x)
    y = OutPort(:y)
    y => x
    expr = []
    push!(expr, expr_setvalue(y, :a))
    push!(expr, [expr_setvalue(l, expr_refvalue(y)) for l = get_lines(y)]...)
    push!(expr, expr_setvalue(x, expr_refvalue(get_line(x))))
    @test Expr(:block, expr...) == Expr(:block, :(y = a), :(yx = y), :(x = yx))
end

end
