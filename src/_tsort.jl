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
    for (_,p) = get_outports(blk)
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
