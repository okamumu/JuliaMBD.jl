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
    _addinport!(blk, get_default_inport(b), default=(typeof(blk.default_inport) == UndefInPort))
end

function addblock!(blk::AbstractBlockDefinition, b::AbstractOutBlock)
    push!(blk.blks, b)
    _addoutport!(blk, get_default_outport(b), default=(typeof(blk.default_outport) == UndefOutPort))
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
