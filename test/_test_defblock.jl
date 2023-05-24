module TestDefBlocks

using JuliaMBD
using JuliaMBD: BlockDefinition, addparameter!
using JuliaMBD: _addinport!, _addoutport!, _compile_constructor, _compile_function
# using JuliaMBD: expr_refvalue, expr_setvalue
using Test

@testset "def1" begin
    b = BlockDefinition(:testblock)
    addparameter!(b, SymbolicValue(:x))
    addparameter!(b, SymbolicValue{Float64}(:v))
    addparameter!(b, SymbolicValue{Float64}(:t), 100)
    _addinport!(b, InPort(:u))
    _addoutport!(b, OutPort(:t))
    println(_compile_constructor(b))
end

@testset "def2" begin
    b = BlockDefinition(:testblock)
    addparameter!(b, SymbolicValue(:x))
    addparameter!(b, SymbolicValue{Float64}(:v))
    addparameter!(b, SymbolicValue{Float64}(:tt), 100)
    _addinport!(b, InPort(:u))
    _addoutport!(b, OutPort(:t))
    println(_compile_function(b))
end

end