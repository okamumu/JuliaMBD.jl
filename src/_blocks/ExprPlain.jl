export ExprPlain

mutable struct ExprPlain <: AbstractExprBlock
    env::Dict{Symbol,Any}
    inports::Vector{AbstractInPort}
    outports::Vector{AbstractOutPort}
    default_inport::AbstractInPort
    default_outport::AbstractOutPort
    expr::Expr

    function ExprPlain(;expr::Expr)
        b = new()
        b.env = Dict{Symbol,Any}()
        b.inports = AbstractInPort[]
        b.outports = AbstractOutPort[]
        b.default_inport = UndefInPort()
        b.default_outport = UndefOutPort()
        b.expr = expr
        b
    end
end

"""
    expr(b::ExprPlain)

A function to get Expr
"""
function expr(blk::ExprPlain)
    blk.expr
end
