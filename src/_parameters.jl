export Auto
export SymbolicValue
# export expr_refvalue
# export expr_setvalue

# Definition for parameter values

"""
     Type Auto

Auto means the variable type is determined automatically from the code
"""
struct Auto end

"""
SymbolicValue{Tv}

The type expresses a symbolic parameter
"""
struct SymbolicValue{Tv}
    name::Symbol
end

function SymbolicValue(x::Symbol)
    SymbolicValue{Auto}(x)
end

"""
    get_name(x::SymbolicValue)

Get a name (Symbol).
"""
function get_name(x::SymbolicValue)
    x.name
end

## Overloads

function Base.show(io::IO, x::SymbolicValue{Tv}) where Tv
    Base.show(io, "$(get_name(x))")
end

"""
   expr_refvalue(x)

Create Expr to refer the symbolic value.
"""
expr_refvalue(x::SymbolicValue{Tv}) where Tv = x.name
expr_refvalue(x::Any) = x

"""
    expr_setvalue(x, expr)

Create Expr to set x = expr.
"""
expr_setvalue(x::SymbolicValue{Auto}, expr) = Expr(:(=), x.name, expr)
expr_setvalue(x::SymbolicValue{Tv}, expr) where Tv = Expr(:(=), x.name, Expr(:call, Symbol(Tv), expr))
