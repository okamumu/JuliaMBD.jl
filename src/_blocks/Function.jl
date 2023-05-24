mutable struct FunctionBlock <: AbstractFunctionBlock
    env::Dict{Symbol,Any}
    name::Symbol
    params::Dict{Symbol,Any}
    inports::Vector{AbstractInPort}
    outports::Vector{AbstractOutPort}
    default_inport::AbstractInPort
    default_outport::AbstractOutPort

    function FunctionBlock(name::Symbol)
        b = new()
        b.env = Dict{Symbol,Any}()
        b.name = name
        b.params = Dict{Symbol,Any}()
        b.inports = AbstractInPort[]
        b.outports = AbstractOutPort[]
        b
    end
end

"""
    expr(b::AbstractFunctionBlock)

A function to get Expr
"""
function expr(blk::AbstractFunctionBlock)
    result = gensym()
    i = []
    for p = get_inports(blk)
        line = get_line(p)
        if typeof(line) != UndefLine
            push!(i, expr_setvalue(get_var(p), expr_refvalue(get_var(line))))
        end
    end
    o = []
    for p = get_outports(blk)
        for line = get_lines(p)
            push!(o, expr_setvalue(get_var(line), Expr(:., result, Expr(:quote, expr_refvalue(get_var(p))))))
        end
    end
    Expr(:block,
        Expr(:(=), result, Expr(:call, blk.type, i...)),
        o...
    )
end
