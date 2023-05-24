"""
     UndefBlock

A struct of UndefiedBlock
"""
struct UndefBlock <: AbstractBlock end

"""
    get_default_inport(b::UndefBlock)
    get_default_outport(b::UndefBlock)

Return a nothing as an instance of default in/out port.
"""
get_default_inport(b::UndefBlock) = nothing
get_default_outport(b::UndefBlock) = nothing

## overloads

function Base.show(io::IO, x::AbstractBlock)
    Base.show(io, "Block($(objectid(x)))")
end

"""
    get_default_inport(b)

A function to get a default inport. This function calls a specific get_default_inport by a type of given block.
"""
function get_default_inport(b::AbstractBlock)
    b.default_inport
end

"""
    get_default_outport(b)

A function to get a default outport. This function calls a specific get_default_outport by a type of given block.
"""
function get_default_outport(b::AbstractBlock)
    b.default_outport
end

"""
    get_params(b)
    get_params(b, key)

A function to get params.
"""
function get_params(b::AbstractBlock)
    b.params
end

# function get_params(b::AbstractBlock, key::Symbol)
#     b.params[key]
# end

"""
    set_params!(b, key, val)

A function to set params.
"""
function set_params!(b::AbstractBlock, key::Symbol, val::Any)
    b.env[key] = val
    push!(b.params, (SymbolicValue(key), val))
end

function set_params!(b::AbstractBlock, key::SymbolicValue, val::Any)
    b.env[get_name(key)] = val
    push!(b.params, (key, val))
end

function set_params!(b::AbstractBlock, key::SymbolicValue)
    b.env[get_name(key)] = get_name(key)
    push!(b.params, (key, get_name(key)))
end

"""
    get_inports(b)

A function to get inports.
"""
function get_inports(b::AbstractBlock)
    b.inports
end

"""
    get_outports(b)

A function to get outports.
"""
function get_outports(b::AbstractBlock)
    b.outports
end

"""
    set_inport!(b, key, p; default=false)

A function to set inport.
"""
function set_inport!(b::AbstractBlock, key::Symbol, p::AbstractInPort; default=false)
    b.env[key] = p
    push!(b.inports, p)
    set_parent!(p, b)
    if default
        b.default_inport = p
    end
end

"""
    set_outport!(b, key, p)

A function to set outport.
"""
function set_outport!(b::AbstractBlock, key::Symbol, p::AbstractOutPort; default=false)
    b.env[key] = p
    push!(b.outports, p)
    set_parent!(p, b)
    if default
        b.default_outport = p
    end
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
    p = get_default_inport(b)
    set_inport!(blk, get_name(p), p, default=(typeof(blk.default_inport) == UndefInPort))
end

function addblock!(blk::AbstractBlockDefinition, b::AbstractOutBlock)
    push!(blk.blks, b)
    p = get_default_outport(b)
    set_outport!(blk, get_name(p), p, default=(typeof(blk.default_outport) == UndefOutPort))
end

function addblock!(blk::AbstractBlockDefinition, b::AbstractSystemBlock)
    push!(blk.blks, b.blks...)
end
