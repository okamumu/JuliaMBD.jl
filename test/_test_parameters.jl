module TestParameter

using JuliaMBD
using JuliaMBD: expr_refvalue, expr_setvalue
using Test

@testset "symbolic01" begin
    x = SymbolicValue(:a)
    @test typeof(x) == SymbolicValue{Auto}
end

@testset "symbolic02" begin
    x = SymbolicValue{UInt16}(:a)
    @test typeof(x) == SymbolicValue{UInt16}
end

@testset "symbolic03" begin
    x = SymbolicValue{UInt16}(:a)
    @test expr_refvalue(x) == :a
end

@testset "symbolic04" begin
    x = SymbolicValue{UInt16}(:a)
    y = SymbolicValue{Auto}(:b)
    @test expr_setvalue(y, expr_refvalue(x)) == :(b = a)
end

@testset "symbolic05" begin
    x = SymbolicValue{UInt16}(:a)
    y = SymbolicValue{UInt8}(:b)
    @test expr_setvalue(y, expr_refvalue(x)) == :(b = UInt8(a))
end

end