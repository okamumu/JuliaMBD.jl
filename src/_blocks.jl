export InlineBlock
export FunctionBlock

mutable struct InlineBlock <: AbstractInlineBlock
    type::Symbol
    params::Dict{Symbol,Any}
    inports::Dict{Symbol,AbstractInPort}
    outports::Dict{Symbol,AbstractOutPort}
    body::Dict{Symbol,AbstractBlock}

    function InlineBlock(type::Symbol)
        b = new()
        b.type = type
        b.params = Dict{Symbol,Any}()
        b.inports = Dict{Symbol,AbstractInPort}()
        b.outports = Dict{Symbol,AbstractOutPort}()
        b.body = Dict{Symbol,AbstractBlock}()
        b
    end
end

mutable struct FunctionBlock <: AbstractFunctionBlock
    type::Symbol
    params::Dict{Symbol,Any}
    inports::Dict{Symbol,AbstractInPort}
    outports::Dict{Symbol,AbstractOutPort}
    body::Dict{Symbol,AbstractBlock}

    function FunctionBlock(type::Symbol)
        b = new()
        b.type = type
        b.params = Dict{Symbol,Any}()
        b.inports = Dict{Symbol,AbstractInPort}()
        b.outports = Dict{Symbol,AbstractOutPort}()
        b.body = Dict{Symbol,AbstractBlock}()
        b
    end
end

"""
    get_type(b)

A function to get an instance of Val type
"""
function get_type(b::AbstractBlock)
    Val{b.type}()
end

"""
    get_default_inport(b)

A function to get a default inport. This function calls a specific get_default_inport by a type of given block.
"""
function get_default_inport(b::AbstractBlock)
    get_default_inport(b, get_type(b))
end

"""
    get_default_outport(b)

A function to get a default outport. This function calls a specific get_default_outport by a type of given block.
"""
function get_default_outport(b::AbstractBlock)
    get_default_outport(b, get_type(b))
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
    expr(b)

A function to get Expr for main processes
"""
function expr(b::AbstractBlock)
    expr(b, get_type(b))
end

"""
    expr_call(b)

A function to get Expr when the block b is called.
"""
function expr_call(blk::AbstractInlineBlock)
    i = [expr_setvalue(get_var(p), expr_refvalue(get_var(get_line(p)))) for (_,p) = get_inports(blk)]
    b = expr(blk)
    o = []
    for (_,p) = get_outports(blk)
        for line = get_lines(p)
            push!(o, expr_setvalue(get_var(line), expr_refvalue(get_var(p))))
        end
    end
    Expr(:block, i..., b, o...)
end

function expr_call(blk::AbstractFunctionBlock)
    result = gensym()
    i = [expr_setvalue(get_var(p), expr_refvalue(get_var(get_line(p))), op=:kw) for (_,p) = get_inports(blk)]
    o = []
    for (_,p) = get_outports(blk)
        for line = get_lines(p)
            push!(o, expr_setvalue(get_var(line), Expr(:., result, Expr(:quote, expr_refvalue(get_var(p))))))
        end
    end
    Expr(:block,
        Expr(:(=), result, Expr(:call, blk.type, i...)),
        o...
    )
end

"""
    expr_func

Expr for definition of function
"""
function expr_func(blk::AbstractFunctionBlock)
    body = [expr_call(b) for b = tsort(blk)]
    Expr(:block, body...)
end

