module TestPorts

using JuliaMBD
using JuliaMBD: get_var, expr_refvalue, expr_setvalue
using Test

@testset "inport" begin
    x = InPort()
    @test typeof(get_var(x)) == SymbolicValue{Auto}
    x = InPort(:leftin, Float64)
    @test get_var(x) == SymbolicValue{Float64}(:leftin)
end

@testset "outport" begin
    x = OutPort()
    @test typeof(get_var(x)) == SymbolicValue{Auto}
    x = OutPort(:leftin, Float64)
    @test get_var(x) == SymbolicValue{Float64}(:leftin)
end

@testset "inport2" begin
    x = InPort(:tes)
    @test expr_refvalue(x) == :tes
end

@testset "inport3" begin
    x = InPort(:tes)
    @test expr_setvalue(x, :b) == :(tes = b)
end

@testset "outport2" begin
    x = OutPort(:tes)
    @test expr_refvalue(x) == :tes
end

@testset "outport3" begin
    x = OutPort(:tes)
    @test expr_setvalue(x, :b) == :(tes = b)
end

end
