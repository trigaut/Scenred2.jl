function LightGraphs.DiGraph(tree::Scenred2Tree)
    n_nodes = tree.n_nodes
    fadjlist = [Array{Int,1}() for _ in 1:n_nodes]
    badjlist = [Array{Int,1}() for _ in 1:n_nodes]
    edgelabels = Dict()
    nodelabels = [tree.nodes[1].data]
    for (i,n) in enumerate(tree.nodes[2:end])
        push!(fadjlist[n.predecessor], i+1)
        edgelabels[(n.predecessor, i+1)] = n.conditional_probability
        push!(nodelabels, n.data)
    end
    DiGraph(length(edgelabels), fadjlist, badjlist), edgelabels, nodelabels
end

function LightGraphs.DiGraph(fan::Scenred2Fan)
    nT = fan.timesteps
    nS = fan.n_scen
    nR = fan.n_random_variables
    n_nodes = nT * nS + 1  
    fadjlist = [Array{Int,1}() for _ in 1:n_nodes]
    badjlist = [Array{Int,1}() for _ in 1:n_nodes]
    edgelabels = Dict()
    nodelabels = [ fill(0.,nR) for _ in 1:n_nodes ]
    for (is,s) in enumerate(fan.scenarios)
        edgelabels[(1,2+(is-1)*nT)] = s.probability
        push!(fadjlist[1], 2+(is-1)*nT)
        for t in 1:nT-1
            nodelabels[1+(is-1)*nT+t] = s.data[t,:]
            push!(fadjlist[1+(is-1)*nT+t], 1+(is-1)*nT+t+1)
        end
        nodelabels[1+(is-1)*nT+nT] = s.data[nT,:]
    end

    DiGraph(length(edgelabels), fadjlist, badjlist), edgelabels, nodelabels
end