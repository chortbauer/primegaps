module Module1

export splitrange, gapdict_from_bitarray, primegaps_from_range, combine_primegaps, primegapsdict

using Primes
using StatsBase 
# using ThreadsX 
using Distributed 
using Plots

# greet() = print("Hello World!")

# splits up range into smaller chunks, avoids crashes
function splitrange(N, maxN=10^8)
  i=3
  RangeArray = []
  while i+maxN  <= N
    RangeArray = vcat(RangeArray, (i, i+maxN))
    i += maxN
  end
  RangeArray = vcat(RangeArray, (i, N))
end


# goes through a bitarray and records all gaps between trues
function gapdict_from_bitarray(Primesbitarray)
  i = 0
  i1 = i
  gapsarray = []
  while true
    i1 = findnext(Primesbitarray, i+1)
    try
      append!(gapsarray, [(i1 - i)])
    catch
      break
    end    
    i = i1
  end
  prevgap = popfirst!(gapsarray)
  endgap = length(Primesbitarray) -i
  return prevgap, countmap(gapsarray), endgap
end


function primegaps_from_range(Range)
  gapdict_from_bitarray(primesmask(Range[1], Range[2]))
end


function combine_primegaps(GapsStructArray)
  EndGaps = Dict(2=>0)
  for (i,GapsStruct) in pairs(IndexLinear(), GapsStructArray[1:end-1])
    addcounts!(EndGaps, [(GapsStruct[end] +GapsStructArray[i+1][1] -1)])
  end

  IntGaps = Dict(2=>0)
  for GapsStruct in GapsStructArray
    IntGaps = merge(+, IntGaps, GapsStruct[2])
  end

  return sort(delete!(merge(+, IntGaps, EndGaps), 0))
end


function primegapsdict(N)
  # GapsStructArray = map(primegaps_from_range, splitrange(N))
  # GapsStructArray = ThreadsX.map(primegaps_from_range, splitrange(N))
  GapsStructArray = pmap(primegaps_from_range, splitrange(N))
  combine_primegaps(GapsStructArray)
end

end # module

