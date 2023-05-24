
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

function get_params(b::AbstractBlock, key::Symbol)
    b.params[key]
end

"""
    get_inports(b)
    get_inports(b, key)

A function to get inports.
"""
function get_inports(b::AbstractBlock)
    b.inports
end

function get_inports(b::AbstractBlock, key::Symbol)
    b.inports[key]
end

"""
    get_outports(b)
    get_outports(b, key)

A function to get outports.
"""
function get_outports(b::AbstractBlock)
    b.outports
end

function get_outports(b::AbstractBlock, key::Symbol)
    b.outports[key]
end

"""
    set_params!(b, key, val)

A function to set params.
"""
function set_params!(b::AbstractBlock, key::Symbol, val::Any)
    b.env[key] = val
    b.params[key] = val
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


