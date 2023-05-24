
mutable struct InBlock <: AbstractInBlock
    env::Dict{Symbol,Any}
    inports::Vector{AbstractInPort}
    outports::Vector{AbstractOutPort}
    default_inport::AbstractInPort
    default_outport::AbstractOutPort

    function InBlock(;inport::AbstractInPort, outport::AbstractOutPort)
        b = new()
        b.env = Dict{Symbol,Any}()
        set_parent!(inport, b)
        set_parent!(outport, b)
        b.inports = AbstractInPort[inport]
        b.outports = AbstractOutPort[outport]
        b.default_inport = inport
        b.default_outport = outport
        b.env[:in] = inport
        b.env[:out] = outport
        b
    end

    function InBlock(name::Symbol; outport::AbstractOutPort = OutPort())
        InBlock(inport=InPort(name), outport=outport)
    end
end

mutable struct OutBlock <: AbstractOutBlock
    env::Dict{Symbol,Any}
    inports::Vector{AbstractInPort}
    outports::Vector{AbstractOutPort}
    default_inport::AbstractInPort
    default_outport::AbstractOutPort

    function OutBlock(;inport::AbstractInPort, outport::AbstractOutPort)
        b = new()
        b.env = Dict{Symbol,Any}()
        set_parent!(inport, b)
        set_parent!(outport, b)
        b.inports = AbstractInPort[inport]
        b.outports = AbstractOutPort[outport]
        b.default_inport = inport
        b.default_outport = outport
        b.env[:in] = inport
        b.env[:out] = outport
        b
    end

    function OutBlock(name::Symbol; inport::AbstractInPort = InPort())
        OutBlock(inport=inport, outport=OutPort(name))
    end
end

"""
    expr(b::AbstractInBlock)
    expr(b::AbstractOutBlock)

A function to get Expr
"""
function expr(blk::AbstractInBlock)
    o = []
    for p = get_outports(blk)
        for line = get_lines(p)
            push!(o, expr_setvalue(get_var(line), expr_refvalue(get_var(p))))
        end
    end
    Expr(:block, o...)
end

function expr(blk::AbstractOutBlock)
    i = []
    for p = get_inports(blk)
        line = get_line(p)
        if typeof(line) == UndefLine
            push!(i, expr_setvalue(get_var(p), expr_refvalue(get_var(line))))
        end
    end
    Expr(:block, i...)
end
