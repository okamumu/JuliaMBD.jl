module TestSystemBlocks

using JuliaMBD
using JuliaMBD: ExprBlock, SystemBlock, InBlock, OutBlock, InlineBlock, FunctionBlock
using JuliaMBD: set_params!, set_parent!, set_inport!, set_outport!, expr, addblock!, set_expr!
using JuliaMBD: _compile_system_constructor, _compile_function, get_default_inport, get_default_outport
using JuliaMBD: addblock!
using Test

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

    b = SystemBlock(bdef)
    println(b)

    println(expr(b))
    # println(_compile_inline_constructor(bdef))
    # eval(_compile_inline_constructor(bdef))
    # m = Gain(K = 10.0)

    # println(expr(m))
    # mm = Expr(:(=), :f, Expr(:(->), :x, expr(m)))
    # eval(mm)
    # @test f(123.0) == 1230.0
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

    println(_compile_system_constructor(bdef))
    eval(_compile_system_constructor(bdef))
    env = Dict()
    env[:Gain] = bdef
    m = Gain(env, K = 10.0)

    println(expr(m))
    # mm = Expr(:(=), :f, Expr(:(->), :x, expr(m)))
    # eval(mm)
    # @test f(123.0) == 1230.0
end

@testset "blk4" begin
    i = InBlock(:x)
    println("in", i)
    o = OutBlock(:y)
    println("out", o)
    g = ExprBlock(inports=(:x,), outports=(:y,), expr=:(y = K * x))
    println("g", g)
    i => g => o

    bdef = BlockDefinition(:Gain)
    set_params!(bdef, SymbolicValue{Auto}(:K))
    addblock!(bdef, i)
    addblock!(bdef, o)
    addblock!(bdef, g)
    println(_compile_system_constructor(bdef))
    eval(_compile_system_constructor(bdef))

    env = Dict()
    env[:Gain] = bdef

    i = InBlock(:xx)
    println("in", i)
    o = OutBlock(:yy)
    println("out", o)
    g = Gain(env, K = 10.0)
    println("g", g)
    println(typeof(g))
    println(get_default_inport(g))
    println(get_default_outport(g))
    println(bdef.default_inport)
    println(bdef.default_outport)
    i => g => o

    bdef = BlockDefinition(:SS)
    set_params!(bdef, SymbolicValue{Auto}(:K))
    addblock!(bdef, i)
    addblock!(bdef, o)
    addblock!(bdef, g)
    eval(_compile_system_constructor(bdef))
    env[:SS] = bdef

    ss = SS(env, K=100.0)
    println(expr(ss))

    # mm = Expr(:(=), :f, Expr(:(->), :x, expr(m)))
    # eval(mm)
    # @test f(123.0) == 1230.0
end

end
