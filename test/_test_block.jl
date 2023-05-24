module TestBlocks

using JuliaMBD
using JuliaMBD: ExprBlock, BlockInlineDefinition,InBlock, OutBlock
using JuliaMBD: addparameter!, set_params!, set_parent!, set_inport!, set_outport!, expr, addblock!
using JuliaMBD: _addinport!, _addoutport!, _compile_constructor, _compile_function
# using JuliaMBD: expr_refvalue, expr_setvalue
using Test

@testset "blk1" begin
    i = InBlock(:x, outport=OutPort(:xtmp))
    o = OutBlock(:y, inport=InPort(:ytmp))
    g = ExprBlock(inports=(:x,), outports=(:y,), expr=:(y = K * x))
    i => g => o
    @test expr(g) == Expr(:block, :(x=xtmpx), :(y = K*x), :(yytmp = y))
end

@testset "blk2" begin
end

end
