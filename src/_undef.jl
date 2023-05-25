export UndefInPort
export UndefOutPort
export UndefLine
export UndefiedBlock

"""
     UndefInPort
     UndefOutPort

A struct of UndefiedPort
"""
struct UndefInPort <: AbstractInPort end
struct UndefOutPort <: AbstractOutPort end

"""
   UndefLine

A type meaning Undef
"""
struct UndefLine <: AbstractLine end

"""
     UndefBlock

A struct of UndefiedBlock
"""
struct UndefBlock <: AbstractBlock end

"""
    get_name(x::UndefInPort)
    get_name(x::UndefOutPort)

Get a name (Symbol).
"""
function get_name(x::UndefInPort)
    :undef
end

function get_name(x::UndefOutPort)
    :undef
end

"""
    get_default_inport(b::UndefInPort)
    get_default_inport(b::UndefOutPort)
    get_default_outport(b::UndefInPort)
    get_default_outport(b::UndefOutPort)

Return a nothing as an instance of default in/out port.
"""
get_default_inport(b::UndefInPort) = nothing
get_default_outport(b::UndefInPort) = nothing
get_default_inport(b::UndefOutPort) = nothing
get_default_outport(b::UndefOutPort) = nothing

"""
    get_default_inport(b::UndefBlock)
    get_default_outport(b::UndefBlock)

Return a nothing as an instance of default in/out port.
"""
get_default_inport(b::UndefBlock) = nothing
get_default_outport(b::UndefBlock) = nothing

"""
    isundef(x)

Return a bool whehter a given object is undef or not
"""
function isundef(x::AbstractBlock)
    typeof(x) == UndefBlock
end

function isundef(x::AbstractInPort)
    typeof(x) == UndefInPort
end

function isundef(x::AbstractOutPort)
    typeof(x) == UndefOutPort
end

function isundef(x::AbstractLine)
    typeof(x) == UndefLine
end
