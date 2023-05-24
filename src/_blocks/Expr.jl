export ExprBlock

mutable struct ExprBlock <: AbstractExprBlock
    env::Dict{Symbol,Any}
    inports::Vector{AbstractInPort}
    outports::Vector{AbstractOutPort}
    default_inport::AbstractInPort
    default_outport::AbstractOutPort
    expr::Expr

    function ExprBlock(;inports::Tuple{Symbol}, outports::Tuple{Symbol}, expr::Expr)
        b = new()
        b.env = Dict{Symbol,Any}()
        b.inports = AbstractInPort[]
        b.outports = AbstractOutPort[]
        b.default_inport = UndefInPort()
        b.default_outport = UndefOutPort()
        for (i,s) = enumerate(inports)
            set_inport!(b, s, InPort(s), default=(i==1))
        end
        for (i,s) = enumerate(outports)
            set_outport!(b, s, OutPort(s), default=(i==1))
        end
        b.expr = expr
        b
    end
end

"""
    expr(b::AbstractExprBlock)

A function to get Expr
"""
function expr(blk::AbstractExprBlock)
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
            push!(o, expr_setvalue(get_var(line), expr_refvalue(get_var(p))))
        end
    end
    Expr(:block, i..., blk.expr, o...)
end
