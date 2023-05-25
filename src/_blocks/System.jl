export SystemBlock

"""
    SystemBlock

A struct to create the system block. This is a copy instance of block definition
"""
mutable struct SystemBlock <: AbstractSystemBlock
    env::Dict{Symbol,Any}
    name::Symbol
    params::Vector{Tuple{SymbolicValue,Any}}
    inports::Vector{AbstractInPort}
    outports::Vector{AbstractOutPort}
    default_inport::AbstractInPort
    default_outport::AbstractOutPort
    blks::Vector{AbstractBlock}

    function SystemBlock(name::Symbol)
        new(Dict{Symbol,Any}(),
            name,
            Tuple{SymbolicValue,Any}[],
            AbstractInPort[],
            AbstractOutPort[],
            UndefInPort(),
            UndefOutPort(),
            AbstractBlock[])
    end

    function SystemBlock(def::AbstractBlockDefinition)
        b = SystemBlock(def.name)
        exprs, ins, outs = toexpr(def.blks)
        for x = exprs
            addblock!(b, x)
        end
        for x = ins
            p = get_default_inport(x)
            if typeof(p) != UndefInPort
                if typeof(def.default_inport) != UndefInPort && get_name(def.default_inport) == get_name(p)
                    set_inport!(b, get_name(p), p, default=true, parent=false)
                else
                    set_inport!(b, get_name(p), p, default=false, parent=false)
                end
            end
        end
        for x = outs
            p = get_default_outport(x)
            if typeof(p) != UndefOutPort
                if typeof(def.default_outport) != UndefOutPort && get_name(p) == get_name(def.default_outport)
                    set_outport!(b, get_name(p), p, default=true, parent=false)
                else
                    set_outport!(b, get_name(p), p, default=false, parent=false)
                end
            end
        end
        b
    end
end

"""
    expr(b::AbstractSystemBlock)

A function to get Expr
"""
function expr(blk::AbstractSystemBlock)
    i = []
    for p = get_inports(blk)
        line = get_line(p)
        if typeof(line) != UndefLine
            push!(i, expr_setvalue(get_var(p), expr_refvalue(get_var(line))))
        end
    end
    p = []
    for (k,v) = get_params(blk)
        push!(p, Expr(:(=), get_name(k), v))
    end
    body = [expr(x) for x = tsort(blk.blks)]
    o = []
    for p = get_outports(blk)
        for line = get_lines(p)
            push!(o, expr_setvalue(get_var(line), expr_refvalue(get_var(p))))
        end
    end
    Expr(:block, i..., p..., body..., o...)
end