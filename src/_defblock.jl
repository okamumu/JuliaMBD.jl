"""
    BlockDefinition

A struct to create the following functions:
- constructor
- expr_call
- function
"""
mutable struct BlockDefinition
    name::Symbol
    parameters::Vector{Tuple{SymbolicValue,Any}}
    inports::Vector{AbstractInPort}
    outports::Vector{AbstractOutPort}
    blks::Vector{AbstractBlock}

    function BlockDefinition(name::Symbol)
        b = new(name,
            Tuple{SymbolicValue,Any}[],
            AbstractInPort[],
            AbstractOutPort[],
            AbstractBlock[])
        b
    end
end

"""
   addparameter!(blk::BlockDefinition, x::SymbolicValue)
   addparameter!(blk::BlockDefinition, x::SymbolicValue, val::Any)

The function to add a parameter.
"""
function addparameter!(blk::BlockDefinition, x::SymbolicValue)
    push!(blk.parameters, (x, x.name))
end

function addparameter!(blk::BlockDefinition, x::SymbolicValue, val::Any)
    push!(blk.parameters, (x, val))
end

"""
   addblock!(blk::BlockDefinition, b::AbstractBlock)

The function to add a block
"""
function addblock!(blk::BlockDefinition, b::AbstractBlock)
    push!(blk.blks, b)
end

"""
   _addinport!(blk::BlockDefinition, p::AbstractInPort)

The function to add an inport
"""
function _addinport!(blk::BlockDefinition, p::AbstractInPort)
    push!(blk.inports, p)
end

"""
   _addoutport!(blk::BlockDefinition, p::AbstractOutPort)

The function to add an outport
"""
function _addoutport!(blk::BlockDefinition, p::AbstractOutPort)
    push!(blk.outports, p)
end

"""
   _compile_constructor(blk::BlockDefinition)

Create Expr to define the constructor
"""
function _compile_constructor(blk::BlockDefinition)
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
            b
        end
    end
end

"""
   _compile_function(blk::BlockDefinition)

Create Expr to define the function
"""
function _compile_function(blk::BlockDefinition)
    defparams1 = [expr_defvalue(x[1]) for x = blk.parameters]
    definports1 = [expr_defvalue(get_var(x)) for x = blk.inports]
    defoutports1 = Expr(:tuple, [Expr(:(=), get_name(x), get_name(x)) for x = blk.outports]...)
    body = [expr_call(b) for b = tsort(blk.blks)]
    # definports2 = [:(set_parent!($(get_name(x)), b)) for x = blk.inports]
    # definports3 = [:(set_inport!(b, $(Expr(:quote, get_name(x))), $(get_name(x)))) for x = blk.inports]
    # defoutports1 = [Expr(:kw, :($(get_name(x))::AbstractOutPort), :(OutPort())) for x = blk.outports]
    # defoutports2 = [:(set_parent!($(get_name(x)), b)) for x = blk.outports]
    # defoutports3 = [:(set_outport!(b, $(Expr(:quote, get_name(x))), $(get_name(x)))) for x = blk.outports]
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
