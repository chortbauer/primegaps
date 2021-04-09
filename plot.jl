using JLD2, FileIO
using Plots
gr()

# load primegapsdicts from disk
gapsdictarray = []
for i = 2:13
    append!(gapsdictarray, [load_object("gapsdict10x$(i).jld2")])
end


# fit linear polynomial to log(N_gaps)
using Polynomials

function linfittodict(gapsdict)
    x = Int64.(collect(keys(gapsdict)))
    y = log.(collect(values(gapsdict)))
    fit(x, y, 1)
end

function polygradiant(poly)
    poly[1]
end

linpolyarray = map(linfittodict, gapsdictarray)
gradiantarray = map(polygradiant, linpolyarray)

function polyplotrange(poly)
    [2, floor(roots(poly)[1])]
end



# plot primegaps and linpolyfits
begin
    fig = plot(title="Primegaps for all Primes p < N", yaxis=:log)
    
    xlabel!(fig, "size of gap")
    ylabel!(fig, "number of occurences")

    for i = 1:12
        scatter!(fig, gapsdictarray[i], label="N=10^$(i+1)")

        xs = polyplotrange(linpolyarray[i])
        ys = exp.(linpolyarray[i].(xs))

        plot!(fig, xs, ys, label=nothing, line=(:dash, :red))
    end

    vline!(fig, [6, 30, 210], label=nothing, line=(:dot, :black))

    plot!(fig, dpi=300)
end


# plot gradient of polyfits
begin
    fig_gradient = plot(exp10.(2:13), gradiantarray, marker=:dot)

    yaxis!(fig_gradient, "gradiant of linear fit")
    xaxis!(fig_gradient, "N")

    xticks!(fig_gradient, [10^i for i in 2:13])

    plot!(fig_gradient, legend=false, xaxis=:log10, dpi=300)
end


# compare ratio of gaps length 6 and 30
function sixtothirty(gapsdict)
    get(gapsdict, 6, 1)/get(gapsdict, 30, 1)
end

sixtothirtyarray = map(sixtothirty, gapsdictarray)

begin
    fig_sixtothirty = plot([10^i for i in 4:13], sixtothirtyarray[3:end], marker=:dot)

    yaxis!(fig_sixtothirty, "ratio of occurence 6/30")
    xaxis!(fig_sixtothirty, "N")

    xticks!(fig_sixtothirty, [10^i for i in 4:13])
    # yticks!(fig_sixtothirty, vcat([1], collect(0:5:25)))
    # yticks!(fig_sixtothirty, 0:5:25)

    ylims!(fig_sixtothirty, (0, ylims(fig_sixtothirty)[2]))

    # hline!(fig_sixtothirty, [1], line=(:dot, :black))

    plot!(fig_sixtothirty, legend=false, xaxis=:log10, dpi=300)
end




# save plots to disk
savefig(fig, "Primegaps.png")
savefig(fig_sixtothirty, "sixtothirty.png")
savefig(fig_gradient, "gradient.png")
