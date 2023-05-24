
abstract type AbstractBlockDefinition end

"""
    BlockFunctionDefinition

A struct to create the following functions:
- constructor
- function
"""
mutable struct BlockFunctionDefinition <: AbstractBlockDefinition
    name::Symbol
    parameters::Vector{Tuple{SymbolicValue,Any}}
    inports::Vector{AbstractInPort}
    outports::Vector{AbstractOutPort}
    default_inport::AbstractInPort
    default_outport::AbstractOutPort
    blks::Vector{AbstractBlock}

    function BlockFunctionDefinition(name::Symbol)
        b = new(name,
            Tuple{SymbolicValue,Any}[],
            AbstractInPort[],
            AbstractOutPort[],
            UndefInPort(),
            UndefOutPort(),
            AbstractBlock[])
        b
    end
end

"""
    BlockInlineDefinition

A struct to create the following functions:
- constructor
"""
mutable struct BlockInlineDefinition <: AbstractBlockDefinition
    name::Symbol
    parameters::Vector{Tuple{SymbolicValue,Any}}
    inports::Vector{AbstractInPort}
    outports::Vector{AbstractOutPort}
    default_inport::AbstractInPort
    default_outport::AbstractOutPort
    blks::Vector{AbstractBlock}

    function BlockInlineDefinition(name::Symbol)
        b = new(name,
            Tuple{SymbolicValue,Any}[],
            AbstractInPort[],
            AbstractOutPort[],
            UndefInPort(),
            UndefOutPort(),
            AbstractBlock[])
        b
    end
end

"""
   addparameter!(blk::AbstractBlockDefinition, x::SymbolicValue)
   addparameter!(blk::AbstractBlockDefinition, x::SymbolicValue, val::Any)

The function to add a parameter.
"""
function addparameter!(blk::AbstractBlockDefinition, x::SymbolicValue)
    push!(blk.parameters, (x, x.name))
end

function addparameter!(blk::AbstractBlockDefinition, x::SymbolicValue, val::Any)
    push!(blk.parameters, (x, val))
end

"""
   addblock!(blk::AbstractBlockDefinition, b::AbstractBlock)

The function to add a block
"""
function addblock!(blk::AbstractBlockDefinition, b::AbstractBlock)
    push!(blk.blks, b)
end

function addblock!(blk::AbstractBlockDefinition, b::AbstractInBlock)
    push!(blk.blks, b)
    push!(blk.inports, get_default_inport(b))
end

function addblock!(blk::AbstractBlockDefinition, b::AbstractOutBlock)
    push!(blk.blks, b)
    push!(blk.outports, get_default_outport(b))
end

"""
   _addinport!(blk::AbstractBlockDefinition, p::AbstractInPort)

The function to add an inport
"""
function _addinport!(blk::AbstractBlockDefinition, p::AbstractInPort; default = false)
    push!(blk.inports, p)
    if default
        blk.default_inport = p
    end
end

"""
   _addoutport!(blk::AbstractBlockDefinition, p::AbstractOutPort)

The function to add an outport
"""
function _addoutport!(blk::AbstractBlockDefinition, p::AbstractOutPort; default = false)
    push!(blk.outports, p)
    if default
        blk.default_outport = p
    end
end

"""
   _compile_constructor(blk::BlockFunctionDefinition)
   _compile_constructor(blk::BlockInlineDefinition)

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
    quote
        function $(blk.name)(;$(defparams1...), $(definports1...), $(defoutports1...))
            b = FunctionBlock($(Expr(:quote, blk.name)))
            $(defparams2...)
            $(definports2...)
            $(defoutports2...)
            $(definports3...)
            $(defoutports3...)
            :(b.default_inport = blk.default_inport)
            :(b.default_outport = blk.default_outport)
            b
        end
    end
end

function _compile_constructor(blk::BlockInlineDefinition)
    defparams1 = [Expr(:kw, expr_defvalue(x[1]), x[2]) for x = blk.parameters]
    defparams2 = [:(set_params!(b, $(Expr(:quote, get_name(x[1]))), $(get_name(x[1])))) for x = blk.parameters]
    definports1 = [Expr(:kw, :($(get_name(x))::AbstractInPort), :(InPort())) for x = blk.inports]
    definports2 = [:(set_parent!($(get_name(x)), b)) for x = blk.inports]
    definports3 = [:(set_inport!(b, $(Expr(:quote, get_name(x))), $(get_name(x)))) for x = blk.inports]
    defoutports1 = [Expr(:kw, :($(get_name(x))::AbstractOutPort), :(OutPort())) for x = blk.outports]
    defoutports2 = [:(set_parent!($(get_name(x)), b)) for x = blk.outports]
    defoutports3 = [:(set_outport!(b, $(Expr(:quote, get_name(x))), $(get_name(x)))) for x = blk.outports]
    ex = Expr(:block, [expr(b) for b = tsort(blk.blks)]...)
    quote
        function $(blk.name)(;$(defparams1...), $(definports1...), $(defoutports1...))
            b = InlineBlock($(Expr(:quote, blk.name)), $(Expr(:quote,ex)))
            $(defparams2...)
            $(definports2...)
            $(defoutports2...)
            $(definports3...)
            $(defoutports3...)
            b.default_inport = $(get_name(blk.default_inport))
            b.default_outport = $(get_name(blk.default_outport))
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
    body = [expr_call(b) for b = tsort(blk.blks)]
    quote
        function $(Symbol(blk.name, "Function"))(;$(definports1...), $(defparams1...))
            $(body...)
            $(defoutports1)
        end
    end
end

"""
    expr_func

Expr for definition of function
"""
function expr_func(blk::AbstractFunctionBlock)
    Expr(:block, body...)
end
