module TestBlocks

using JuliaMBD
using JuliaMBD: get_type, expr, expr_call
# using JuliaMBD: expr_refvalue, expr_setvalue
using Test

@testset "gain1" begin
    b = Gain(1)
    @test get_type(b) == Val{:Gain}()
end

@testset "gain2" begin
    b = Gain(1, inport=InPort(:in), outport=OutPort(:out))
    o = OutPort(:o)
    i = InPort(:i)
    o => b => i
    @test expr(b) == :(out = 1 * in)
end

@testset "gain3" begin
    b = Gain(K=10.0, inport=InPort(:in), outport=OutPort(:out))
    o = OutPort(:o)
    i = InPort(:i)
    o => b => i
    @test expr_call(b) == :(out = 1 * in)
end

end
