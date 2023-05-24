mutable struct InlineBlock <: AbstractInlineBlock
    name::Symbol
    params::Dict{Symbol,Any}
    inports::Vector{AbstractInPort}
    outports::Vector{AbstractOutPort}
    default_inport::AbstractInPort
    default_outport::AbstractOutPort
    expr::Expr

    function InlineBlock(name::Symbol)
        b = new()
        b.name = name
        b.params = Dict{Symbol,Any}()
        b.inports = Vector{AbstractInPort}()
        b.outports = Vector{AbstractOutPort}()
        b.default_inport = UndefInPort()
        b.default_outport = UndefOutPort()
        b.expr = expr
        b
    end
end

"""
    expr(b::AbstractInlineBlock)

A function to get Expr
"""
function expr(blk::AbstractInlineBlock)
    i = [expr_setvalue(get_var(p), expr_refvalue(get_var(get_line(p)))) for (_,p) = get_inports(blk)]
    body = blk.expr
    o = []
    for (_,p) = get_outports(blk)
        for line = get_lines(p)
            push!(o, expr_setvalue(get_var(line), expr_refvalue(get_var(p))))
        end
    end
    Expr(:block, i..., body, o...)
end
