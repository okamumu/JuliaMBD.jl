
export InPort
export OutPort
# export get_name
# export get_var
# export get_parent
# export get_line
# export get_lines
# export get_default_inport
# export get_default_outport
# export expr_refvalue
# export expr_setvalue

function Base.show(io::IO, x::AbstractInPort)
    Base.show(io, "InPort($(get_name(x)))")
end

function Base.show(io::IO, x::AbstractOutPort)
    Base.show(io, "OutPort($(get_name(x)))")
end

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
    InPort <: AbstractInPort

The mutable struct for InPort. InPort corresponds to an argument of the function of block. The members are
- `var`: A symbol of port. SymbolicValue is generic for the parametric types SymbolicValue{Tv}
- `parent`: A block involves the port itself.
- `line`: An instance of Line that connects from other outport to the inport

# Examples
```jldoctest
julia> x = InPort() # name is determined by gensym, Type is Auto
julia> x = InPort(:x) # name is :x, Type is Auto
julia> x = InPort(Float64) # name is determined by gensym, Type is Float64
julia> x = InPort(:x, Float64) # name is :x, Type is Float64
````
"""
mutable struct InPort <: AbstractInPort
    var::SymbolicValue
    parent::AbstractBlock
    line::AbstractLine

    function InPort()
        p = new()
        p.var = SymbolicValue{Auto}(gensym())
        p.parent = UndefBlock()
        p.line = UndefLine()
        p
    end

    function InPort(name::Symbol)
        p = new()
        p.var = SymbolicValue{Auto}(name)
        p.parent = UndefBlock()
        p.line = UndefLine()
        p
    end

    function InPort(::Type{Tv}) where Tv
        p = new()
        p.var = SymbolicValue{Auto}(gensym())
        p.parent = UndefBlock()
        p.line = UndefLine()
        p
    end

    function InPort(name::Symbol, ::Type{Tv}) where Tv
        p = new()
        p.var = SymbolicValue{Tv}(name)
        p.parent = UndefBlock()
        p.line = UndefLine()
        p
    end
end

"""
    OutPort <: AbstractOutPort

The mutable struct for OutPort. OutPort corresponds to a returend value from the function of block. The members are
- `var`: A symbol of port. SymbolicValue is generic for the parametric types SymbolicValue{Tv}
- `parent`: A block involves the port itself.
- `lines`: A vector of instances of Line that connects from the outport to others.

# Examples
```jldoctest
julia> x = OutPort() # name is determined by gensym, Type is Auto
julia> x = OutPort(:x) # name is :x, Type is Auto
julia> x = OutPort(Float64) # name is determined by gensym, Type is Float64
julia> x = OutPort(:x, Float64) # name is :x, Type is Float64
````
"""
mutable struct OutPort <: AbstractOutPort
    var::SymbolicValue
    parent::AbstractBlock
    lines::Vector{AbstractLine}

    function OutPort()
        p = new()
        p.var = SymbolicValue{Auto}(gensym())
        p.parent = UndefBlock()
        p.lines = AbstractLine[]
        p
    end

    function OutPort(name::Symbol)
        p = new()
        p.var = SymbolicValue{Auto}(name)
        p.parent = UndefBlock()
        p.lines = AbstractLine[]
        p
    end

    function OutPort(::Type{Tv}) where Tv
        p = new()
        p.var = SymbolicValue{Auto}(gensym())
        p.parent = UndefBlock()
        p.lines = AbstractLine[]
        p
    end

    function OutPort(name::Symbol, ::Type{Tv}) where Tv
        p = new()
        p.var = SymbolicValue{Tv}(name)
        p.parent = UndefBlock()
        p.lines = AbstractLine[]
        p
    end
end

"""
    get_var(x::AbstractPort)

Get a symbolicvar.
"""
function get_var(x::AbstractPort)
    x.var
end

"""
    get_name(x::AbstractPort)

Get a name (Symbol).
"""
function get_name(x::AbstractPort)
    get_name(get_var(x))
end

function get_name(x::UndefInPort)
    :undef
end

function get_name(x::UndefOutPort)
    :undef
end

"""
    get_parent(x::AbstractPort)

Get a parent block.
"""
function get_parent(x::AbstractPort)
    x.parent
end

"""
    set_parent!(x::AbstractPort, b::AbstractBlock)

Set a parent block.
"""
function set_parent!(x::AbstractPort, b::AbstractBlock)
    x.parent = b
end

"""
   get_line(x::AbstractInPort)

Get an input line of InPort.
"""
function get_line(x::AbstractInPort)
    x.line
end

"""
   get_lines(x::AbstractOutPort)

Get output lines from OutPort.
"""
function get_lines(x::AbstractOutPort)
    x.lines
end

"""
   set_line!(x::AbstractInPort, l::AbstractLine)

Set an input line to InPort.
"""
function set_line!(x::AbstractInPort, l::AbstractLine)
    x.line = l
    nothing
end

"""
   set_line!(x::AbstractOutPort, l::AbstractLine)

Set an output line to OutPort.
"""
function set_line!(x::AbstractOutPort, l::AbstractLine)
    push!(x.lines, l)
    nothing
end

"""
   get_default_inport(p::AbstractInPort)
   get_default_outport(p::AbstractInPort)

Get an instance of default in/out port.
"""
get_default_inport(p::AbstractInPort) = p
get_default_outport(p::AbstractInPort) = get_default_outport(get_parent(p))

"""
   get_default_inport(p::AbstractOutPort)
   get_default_outport(p::AbstractOutPort)

Get an instance of default in/out port.
"""
get_default_inport(p::AbstractOutPort) = get_default_inport(get_parent(p))
get_default_outport(p::AbstractOutPort) = p

"""
   expr_refvalue(x)

Create Expr to refer the port.
"""
function expr_refvalue(x::AbstractPort)
    expr_refvalue(get_var(x))
end

"""
    expr_setvalue(x, expr)

Create Expr to set x = expr.
"""
function expr_setvalue(x::AbstractPort, expr)
    expr_setvalue(get_var(x), expr)
end
