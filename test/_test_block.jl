module TestBlocks

using JuliaMBD
using JuliaMBD: ExprBlock, SystemBlock, InBlock, OutBlock, InlineBlock, FunctionBlock
using JuliaMBD: set_params!, set_parent!, set_inport!, set_outport!, expr, addblock!, set_expr!
using JuliaMBD: _compile_function_constructor, _compile_inline_constructor, _compile_function
using JuliaMBD: next
using Test

@testset "blk1" begin
    i = InBlock(:x, outport=OutPort(:xtmp))
    o = OutBlock(:y, inport=InPort(:ytmp))
    g = ExprBlock(inports=(:x,), outports=(:y,), expr=:(y = K * x))
    i => g => o
    @test expr(g) == Expr(:block, :(x=xtmpx), :(y = K*x), :(yytmp = y))
end

@testset "blk2" begin
    i = InBlock(:x, outport=OutPort(:xtmp))
    o = OutBlock(:y, inport=InPort(:ytmp))
    g = ExprBlock(inports=(:x,), outports=(:y,), expr=:(y = K * x))
    i => g => o

    bdef = BlockDefinition(:Gain)
    set_params!(bdef, SymbolicValue{Auto}(:K))
    addblock!(bdef, i)
    addblock!(bdef, o)
    addblock!(bdef, g)

    println(_compile_inline_constructor(bdef))
    eval(_compile_inline_constructor(bdef))
    m = Gain(K = 10.0)

    println(expr(m))
    mm = Expr(:(=), :f, Expr(:(->), :x, expr(m)))
    eval(mm)
    @test f(123.0) == 1230.0
end

@testset "blk3" begin
    i = InBlock(:x, outport=OutPort(:xtmp))
    o = OutBlock(:y, inport=InPort(:ytmp))
    g = ExprBlock(inports=(:x,), outports=(:y,), expr=:(y = K * x))
    i => g => o

    bdef = BlockDefinition(:Gain)
    set_params!(bdef, SymbolicValue{Auto}(:K))
    addblock!(bdef, i)
    addblock!(bdef, o)
    addblock!(bdef, g)

    println(_compile_function_constructor(bdef))
    println(_compile_function(bdef))
    eval(_compile_function_constructor(bdef))
    eval(_compile_function(bdef))

    m = Gain(K = 10.0, x = InPort(:gin), y = OutPort(:gout))
    xx = InPort(:xx)
    yy = OutPort(:yy)

    yy => m => xx

    println(expr(m))

    mm = Expr(:(=), :f, Expr(:(->), :yygin, expr(m)))
    eval(mm)

    @test f(123.0) == 1230.0
end

@testset "blk4" begin
    i = InBlock(:x, outport=OutPort(:xtmp))
    o = OutBlock(:y, inport=InPort(:ytmp))
    g = ExprBlock(inports=(:x,), outports=(:y,), expr=:(y = K * x))
    i => g => o

    bdef = BlockDefinition(:Gain)
    set_params!(bdef, SymbolicValue{Auto}(:K))
    addblock!(bdef, i)
    addblock!(bdef, o)
    addblock!(bdef, g)

    println(_compile_function_constructor(bdef))
    println(_compile_function(bdef))
    eval(_compile_function_constructor(bdef))
    eval(_compile_function(bdef))

    m = Gain(K = 10.0, x = InPort(:gin), y = OutPort(:gout))
    xx = InPort(:xx)
    yy = OutPort(:yy)

    yy => m => xx

    println(expr(m))

    mm = Expr(:(=), :f, Expr(:(->), :yygin, expr(m)))
    eval(mm)

    @test f(123.0) == 1230.0
end

end
