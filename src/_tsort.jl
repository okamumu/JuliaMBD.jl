"""
    prev(b)

Get input blocks
"""
function prev(blk::AbstractBlock)
    b = AbstractBlock[]
    for (_,p) = get_inports(blk)
        l = get_line(p)
        if l != UndefLine()
            push!(b, get_parent(get_source(l)))
        end
    end
    b
end

"""
    next(b)

Get output blocks
"""
function next(blk::AbstractBlock)
    b = AbstractBlock[]
    for p = get_outports(blk)
        for l = get_lines(p)
            push!(b, get_parent(get_target(l)))
        end
    end
    b
end

"""
   tsort

Tomprogical sort to determine the sequence of expression in SystemBlock
"""
function tsort(blks::Vector{AbstractBlock})
    l = []
    check = Dict()
    for n = blks
        check[n] = 0
    end
    for n = blks
        if check[n] != 2
            _visit(n, check, l)
        end
    end
    l
end

function tsort2(blks::Vector{AbstractBlock})
    l = []
    check = Dict()
    for n = blks
        check[n] = 0
    end
    for n = blks
        if check[n] != 2
            v = []
            push!(l, v)
            _visit(n, check, v)
        end
    end
    l
end

function _visit(n, check, l)
    if check[n] == 1
        throw(ErrorException("DAG has a closed path"))
    elseif check[n] == 0
        check[n] = 1
        for m = next(n)
            _visit(m, check, l)
        end
        check[n] = 2
        pushfirst!(l, n)
    end
end

"""
    toexpr

The function to gen Expr
"""
function toexpr(blks::Vector{AbstractBlock})
    h = Dict()
    inblocks = AbstractBlock[]
    outblocks = AbstractBlock[]
    for b = blks
        h[b] = ExprPlain(expr=expr(b))
        if typeof(b) <: AbstractInBlock
            push!(inblocks, h[b])
        elseif typeof(b) <: AbstractOutBlock
            push!(outblocks, h[b])
        end
    end
    for b = blks
        for p = get_inports(b)
            newp = copyport(p)
            set_inport!(h[b], get_name(p), newp,
                default=(get_name(get_default_inport(b)) == get_name(newp)))
        end
        for p = get_outports(b)
            newp = copyport(p)
            set_outport!(h[b], get_name(p), newp,
                default=(get_name(get_default_outport(b)) == get_name(newp)))
        end
    end
    visited = Set()
    for b = blks
        for p = get_inports(b)
            if typeof(get_line(p)) != UndefLine
                x = get_source(get_line(p))
                if !in((p,x), visited)
                    h[get_parent(x)].env[get_name(x)] => h[b].env[get_name(p)]
                    push!(visited, (p,x))
                end
            end
        end
        for p = get_outports(b)
            for line = get_lines(p)
                x = get_target(line)
                if !in((p,x), visited)
                    h[b].env[get_name(p)] => h[get_parent(x)].env[get_name(x)]
                    push!(visited, (p,x))
                end
            end
        end
    end
    AbstractBlock[x for x = values(h)], inblocks, outblocks
end


