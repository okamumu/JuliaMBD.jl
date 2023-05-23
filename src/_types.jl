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

abstract type AbstractInlineBlock <: AbstractBlock end
abstract type AbstractFunctionBlock <: AbstractBlock end

# abstract type AbstractTimeBlock <: AbstractBlock end
# abstract type AbstractIntegratorBlock <: AbstractBlock end
# abstract type AbstractSystemBlock <: AbstractBlock end
# abstract type AbstractFunctionBlock <: AbstractSystemBlock end
# abstract type AbstractInBlock <: AbstractBlock end
# abstract type AbstractOutBlock <: AbstractBlock end
