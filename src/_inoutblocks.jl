export Gain

"""
    Gain(K::Parameter; inport::AbstractInPort = InPort(), outport::AbstractOutPort = OutPort())
    Gain(;K::Parameter, inport::AbstractInPort = InPort(), outport::AbstractOutPort = OutPort())

A constructor for a Gain block
"""
function Gain(K::Any; inport::AbstractInPort = InPort(), outport::AbstractOutPort = OutPort())
    # b = InlineBlock(:Gain)
    b = FunctionBlock(:Gain)
    b.params[:K] = K
    set_parent!(inport, b)
    set_parent!(outport, b)
    get_inports(b)[:inport] = inport
    get_outports(b)[:outport] = outport
    b
end

function Gain(;K::Any, inport::AbstractInPort = InPort(), outport::AbstractOutPort = OutPort())
    # b = InlineBlock(:Gain)
    b = FunctionBlock(:Gain)
    b.params[:K] = K
    set_parent!(inport, b)
    set_parent!(outport, b)
    get_inports(b)[:inport] = inport
    get_outports(b)[:outport] = outport
    b
end

# overloads
get_default_inport(b, ::Val{:Gain}) = get_inports(b, :inport)
get_default_outport(b, ::Val{:Gain}) = get_outports(b, :outport)

function expr(b::AbstractBlock, ::Val{:Gain})
    inport = expr_refvalue(get_inports(b, :inport))
    K = expr_refvalue(get_params(b, :K))
    expr_setvalue(get_outports(b, :outport), :($K * $inport))
end
