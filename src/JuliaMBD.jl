module JuliaMBD

include("_types.jl")
include("_undef.jl")

include("_parameters.jl")
include("_ports.jl")
include("_lines.jl")


include("_tsort.jl")
include("_block_common.jl")
include("_blocks/Expr.jl")
include("_blocks/ExprPlain.jl")
include("_blocks/InOut.jl")

include("_blocks/BlockDefinition.jl")
include("_blocks/Inline.jl")
include("_blocks/Function.jl")
include("_blocks/System.jl")

end
