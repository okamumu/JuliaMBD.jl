export FunctionBlock

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
    o = []
    args = []
    for (k,x) = blk.env
        if typeof(x) <: AbstractInPort
            line = get_line(x)
            if typeof(line) != UndefLine
                push!(i, expr_setvalue(get_var(x), expr_refvalue(get_var(line))))
            end
            push!(args, Expr(:kw, k, get_name(x)))
        elseif typeof(x) <: AbstractOutPort
            for line = get_lines(x)
                push!(o, expr_setvalue(get_var(line), Expr(:., result, Expr(:quote, k))))
            end
        else
            push!(args, Expr(:kw, k, get_params(blk, k)))
        end
    end
    Expr(:block,
        i...,
        Expr(:(=), result, Expr(:call, Symbol(blk.name, "Function"), args...)),
        o...
    )
end
