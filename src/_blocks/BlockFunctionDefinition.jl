export BlockFunctionDefinition

"""
    BlockFunctionDefinition

A struct to create the following functions:
- constructor
- function
"""
mutable struct BlockFunctionDefinition <: AbstractBlockDefinition
    env::Dict{Symbol,Any}
    name::Symbol
    parameters::Vector{Tuple{SymbolicValue,Any}}
    inports::Vector{AbstractInPort}
    outports::Vector{AbstractOutPort}
    default_inport::AbstractInPort
    default_outport::AbstractOutPort
    blks::Vector{AbstractBlock}

    function BlockFunctionDefinition(name::Symbol)
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
   _compile_constructor(blk::BlockFunctionDefinition)

Create Expr to define the constructor
"""
function _compile_constructor(blk::BlockFunctionDefinition)
    defparams1 = [Expr(:kw, expr_defvalue(x[1]), x[2]) for x = blk.parameters]
    defparams2 = [:(set_params!(b, $(Expr(:quote, get_name(x[1]))), $(get_name(x[1])))) for x = blk.parameters]
    definports1 = [Expr(:kw, :($(get_name(x))::AbstractInPort), :(InPort())) for x = blk.inports]
    definports2 = [:(set_parent!($(get_name(x)), b)) for x = blk.inports]
    definports3 = [:(set_inport!(b, $(Expr(:quote, get_name(x))), $(get_name(x)))) for x = blk.inports]
    defoutports1 = [Expr(:kw, :($(get_name(x))::AbstractOutPort), :(OutPort())) for x = blk.outports]
    defoutports2 = [:(set_parent!($(get_name(x)), b)) for x = blk.outports]
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
    quote
        function $(blk.name)(;$(defparams1...), $(definports1...), $(defoutports1...))
            b = FunctionBlock($(Expr(:quote, blk.name)))
            $(defparams2...)
            $(definports2...)
            $(defoutports2...)
            $(definports3...)
            $(defoutports3...)
            $(default1)
            $(default2)
            b
        end
    end
end

"""
   _compile_function(blk::BlockFunctionDefinition)

Create Expr to define the function
"""
function _compile_function(blk::BlockFunctionDefinition)
    defparams1 = [expr_defvalue(x[1]) for x = blk.parameters]
    definports1 = [expr_defvalue(get_var(x)) for x = blk.inports]
    defoutports1 = Expr(:tuple, [Expr(:(=), get_name(x), get_name(x)) for x = blk.outports]...)
    body = [expr(b) for b = tsort(blk.blks)]
    quote
        function $(Symbol(blk.name, "Function"))(;$(definports1...), $(defparams1...))
            $(body...)
            $(defoutports1)
        end
    end
end

# """
#     expr_func

# Expr for definition of function
# """
# function expr_func(blk::AbstractFunctionBlock)
#     Expr(:block, body...)
# end
