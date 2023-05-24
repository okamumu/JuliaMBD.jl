export InlineBlock

mutable struct InlineBlock <: AbstractInlineBlock
    env::Dict{Symbol,Any}
    name::Symbol
    params::Dict{Symbol,Any}
    inports::Vector{AbstractInPort}
    outports::Vector{AbstractOutPort}
    default_inport::AbstractInPort
    default_outport::AbstractOutPort
    expr::Expr

    function InlineBlock(name::Symbol)
        b = new()
        b.env = Dict{Symbol,Any}()
        b.name = name
        b.params = Dict{Symbol,Any}()
        b.inports = AbstractInPort[]
        b.outports = AbstractOutPort[]
        b.default_inport = UndefInPort()
        b.default_outport = UndefOutPort()
        b
    end
end

"""
    set_expr!(blk::AbstractInlineBlock, e::Expr)

Set Expr
"""
function set_expr!(blk::AbstractInlineBlock, e::Expr)
    blk.expr = e
end


"""
    expr(b::AbstractInlineBlock)

A function to get Expr
"""
function expr(blk::AbstractInlineBlock)
    i = []
    for p = get_inports(blk)
        line = get_line(p)
        if typeof(line) != UndefLine
            push!(i, expr_setvalue(get_var(p), expr_refvalue(get_var(line))))
        end
    end
    p = []
    for (k,v) = get_params(blk)
        push!(p, Expr(:(=), k, v))
    end
    body = blk.expr
    o = []
    for p = get_outports(blk)
        for line = get_lines(p)
            push!(o, expr_setvalue(get_var(line), expr_refvalue(get_var(p))))
        end
    end
    Expr(:block, i..., p..., body, o...)
end
