export BlockInlineDefinition

"""
    BlockInlineDefinition

A struct to create the following functions:
- constructor
"""
mutable struct BlockInlineDefinition <: AbstractBlockDefinition
    env::Dict{Symbol,Any}
    name::Symbol
    parameters::Vector{Tuple{SymbolicValue,Any}}
    inports::Vector{AbstractInPort}
    outports::Vector{AbstractOutPort}
    default_inport::AbstractInPort
    default_outport::AbstractOutPort
    blks::Vector{AbstractBlock}

    function BlockInlineDefinition(name::Symbol)
        new(Dict{Symbol,Any}(),
            name,
            Tuple{SymbolicValue,Any}[],
            AbstractInPort[],
            AbstractOutPort[],
            UndefInPort(),
            UndefOutPort(),
            AbstractBlock[])
    end
end

"""
   _compile_constructor(blk::BlockInlineDefinition)

Create Expr to define the constructor
"""
function _compile_constructor(blk::BlockInlineDefinition)
    defparams1 = [Expr(:kw, expr_defvalue(x[1]), x[2]) for x = blk.parameters]
    defparams2 = [:(set_params!(b, $(Expr(:quote, get_name(x[1]))), $(get_name(x[1])))) for x = blk.parameters]
    definports1 = [Expr(:kw, :($(get_name(x))::AbstractInPort), :(InPort())) for x = blk.inports]
    definports3 = [:(set_inport!(b, $(Expr(:quote, get_name(x))), $(get_name(x)))) for x = blk.inports]
    defoutports1 = [Expr(:kw, :($(get_name(x))::AbstractOutPort), :(OutPort())) for x = blk.outports]
    defoutports3 = [:(set_outport!(b, $(Expr(:quote, get_name(x))), $(get_name(x)))) for x = blk.outports]
    default1 = if typeof(blk.default_inport) != UndefInPort
        :(b.default_inport = $(get_name(blk.default_inport)))
    else
        :()
    end
    default2 = if typeof(blk.default_outport) != UndefOutPort
        :(b.default_outport = $(get_name(blk.default_outport)))
    else
        :()
    end
    ex = Expr(:block, [expr(b) for b = tsort(blk.blks)]...)
    quote
        function $(blk.name)(;$(defparams1...), $(definports1...), $(defoutports1...))
            b = InlineBlock($(Expr(:quote, blk.name)))
            $(defparams2...)
            $(definports3...)
            $(defoutports3...)
            $(default1)
            $(default2)
            set_expr!(b, $(Expr(:quote, ex)))
            b
        end
    end
end
