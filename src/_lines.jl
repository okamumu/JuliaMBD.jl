export Line

"""
   UndefLine

A type meaning Undef
"""
struct UndefLine <: AbstractLine end

"""
   Line

A mutable struct of Line to connect from outport to inport.
The members are
- `var`: A symbol of line. SymbolicValue is generic for the parametric types SymbolicValue{Tv}. But now, the type is fixed as Auto.
- `source`: An instance of outport
- `dest`: An instance of inport
"""
mutable struct Line <: AbstractLine
    var::SymbolicValue{Auto}
    source::AbstractOutPort
    dest::AbstractInPort
    
    function Line(o::AbstractOutPort, i::AbstractInPort)
        name = Symbol(get_name(o), get_name(i))
        line = new(SymbolicValue{Auto}(name), o, i)
        set_line!(i, line)
        set_line!(o, line)
        line
    end

    function Line(o::AbstractOutPort, i::AbstractInPort, name::Symbol)
        line = new(SymbolicValue{Auto}(name), o, i)
        set_line!(i, line)
        set_line!(o, line)
        line
    end
end

"""
    get_var(x::AbstractLine)

Get a symbolicvar.
"""
function get_var(x::AbstractLine)
    x.var
end

"""
    get_source(x::AbstractLine)

Get a source of line.
"""
function get_source(x::AbstractLine)
    x.source
end

"""
    get_target(x::AbstractLine)

Get a target of line.
"""
function get_target(x::AbstractLine)
    x.dest
end

"""
   Base.:(=>)(out, in)

The method to create a line connecting two componets. When it uses with blocks, `get_default_inport`/`get_default_outport` are
called in the method. The returned value is the `out`
"""
function Base.:(=>)(o::AbstractBlockOrPort, i::AbstractBlockOrPort)
    Line(get_default_outport(o), get_default_inport(i))
    # isnothing(get_parent(o)) && return nothing
    get_default_inport(o)
end

function Base.:(=>)(o::AbstractBlockOrPort, is::Vector{<:AbstractBlockOrPort})
    for i = is
        Line(get_default_outport(o), get_default_inport(i))
    end
    # isnothing(get_parent(o)) && return nothing
    get_default_inport(o)
end

"""
   expr_refvalue(x)

Create Expr to refer the line.
"""
function expr_refvalue(x::AbstractLine)
    expr_refvalue(get_var(x))
end

"""
    expr_setvalue(x, expr)

Create Expr to set x = expr.
"""
function expr_setvalue(x::AbstractLine, expr)
    expr_setvalue(get_var(x), expr)
end
