using Distributed 
using JLD2, FileIO

# addprocs(Sys.CPU_THREADS-1)
# addprocs(Int(Sys.CPU_THREADS/2)-1)

@everywhere using Pkg
@everywhere Pkg.activate("./Module1")
@everywhere using Module1


# for i = 1:10
#     gapsdict10xi = primegapsdict(10^i)
#     @save "gapsdict10x$(i).jld2" gapsdict10xi
# end


# rmprocs(workers())



# gapsdict10x12 = primegapsdict(10^12)
# @save "gapsdict10x12.jld2" gapsdict10x12

