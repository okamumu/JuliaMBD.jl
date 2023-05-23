module TestLines

using JuliaMBD
using JuliaMBD: get_line
using Test

@testset "line1" begin
    x = InPort()
    y = OutPort()
    y => x
    (get_line(x))
end

# @testset "line2" begin
#     x = InPort()
#     y = OutPort()
#     y => x
#     expr = []
#     push!(expr, expr_setvalue(y, :a))
#     push!(expr, [expr_setvalue(l, expr_refvalue(y)) for l = get_lines(y)]...)
#     push!(expr, expr_setvalue(x, expr_refvalue(get_line(x))))
#     println(expr)
# end

end
