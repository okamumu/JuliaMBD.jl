export SystemBlock

"""
    SystemBlock

A struct to create the system block. This is a copy instance of block definition
"""
mutable struct SystemBlock <: AbstractSystemBlock
    env::Dict{Symbol,Any}
    name::Symbol
    params::Vector{Tuple{SymbolicValue,Any}}
    inports::Vector{AbstractInPort}
    outports::Vector{AbstractOutPort}
    default_inport::AbstractInPort
    default_outport::AbstractOutPort
    blks::Vector{AbstractBlock}

    function SystemBlock(name::Symbol)
        new(Dict{Symbol,Any}(),
            name,
            Tuple{SymbolicValue,Any}[],
            AbstractInPort[],
            AbstractOutPort[],
            UndefInPort(),
            UndefOutPort(),
            AbstractBlock[])
    end
end

