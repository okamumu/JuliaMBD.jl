export AbstractBlockOrPort
export AbstractBlock
export AbstractPort
export AbstractInPort
export AbstractOutPort
export AbstractLine

abstract type AbstractComponent end
abstract type AbstractBlockOrPort <: AbstractComponent end
abstract type AbstractLine <: AbstractComponent end
abstract type AbstractBlock <: AbstractBlockOrPort end
abstract type AbstractPort <: AbstractBlockOrPort end
abstract type AbstractInPort <: AbstractPort end
abstract type AbstractOutPort <: AbstractPort end

"""
     UndefInPort
     UndefOutPort

A struct of UndefiedPort
"""
struct UndefInPort <: AbstractInPort end
struct UndefOutPort <: AbstractOutPort end

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

abstract type AbstractInBlock <: AbstractBlock end
abstract type AbstractOutBlock <: AbstractBlock end
abstract type AbstractExprBlock <: AbstractBlock end
abstract type AbstractInlineBlock <: AbstractBlock end
abstract type AbstractFunctionBlock <: AbstractBlock end

# abstract type AbstractTimeBlock <: AbstractBlock end
# abstract type AbstractIntegratorBlock <: AbstractBlock end
# abstract type AbstractSystemBlock <: AbstractBlock end
# abstract type AbstractFunctionBlock <: AbstractSystemBlock end
# abstract type AbstractInBlock <: AbstractBlock end
# abstract type AbstractOutBlock <: AbstractBlock end
