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

abstract type AbstractBlockDefinition <: AbstractBlock end
abstract type AbstractSystemBlock <: AbstractBlock end

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
