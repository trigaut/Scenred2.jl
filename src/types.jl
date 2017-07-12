
type Scenred2Node
    predecessor::Int
    conditional_probability::Float64
    data::Vector{Float64}
end


type Scenred2Tree
    n_nodes::Int
    n_random_variables::Int
    nodes::Vector{Scenred2Node}
end

type Scenred2Scenario
    probability::Float64
    data::Array{Float64,2}
end

type Scenred2Fan
    TIME::Int
    SCEN::Int
    RANDOM::Int
    scenarios::Vector{Scenred2Scenario}
end

type Scenred2Prms
    construction_method::Int
    reduction_method::Int
    order::Int
    scaling::Int
    red_percentage::Float64
end

function Scenred2Prms(; construction_method::Int = 2, reduction_method = 1, 
                        order = 1, scaling = 0, red_percentage = 0.1)
    Scenred2Prms(construction_method, reduction_method, order, scaling, red_percentage)
end

function obj_to_dict!(d::Dict, obj; first_field::Int=1, last_field::Int=0)
    for i in fieldnames(obj)[first_field:end-last_field]
       d[string(i)] = eval(quote string($obj.$i) end)
    end
end


function stringify(scenario::Scenred2Scenario)
    str = string(scenario.probability)"\n"
    for t in 1:size(scenario.data)[1]
        str = join([str,join(scenario.data[t,:], " ")"\n"])
    end
    str
end

function Base.writedlm(prms::Scenred2Prms) 
    d = Dict()
    obj_to_dict!(d, prms)
    writedlm("$(Pkg.Dir.path())/Scenred2/tmp/scenred2Opt.opt", d)
end

function Base.writedlm(fan::Scenred2Fan)
    d = Dict()
    d["TYPE FAN"] = "\nTIME $(fan.TIME)\nSCEN $(fan.SCEN)\nRANDOM $(fan.RANDOM)"
    scenarios = fan.scenarios
    d["DATA"] = "\n"
    for s in fan.scenarios
        d["DATA"] = join([d["DATA"], stringify(s)])
    end
    d["END"] = ""
    writedlm("$(Pkg.Dir.path())/Scenred2/tmp/scenred2Fan.dat", d, quotes = false)
end

Scenred2Node(data::Vector{Any}) = Scenred2Node(floor(Int,data[1]), data[2], data[3:end])

function Scenred2Tree(n_nodes::Int, n_vars::Int, data::Array{Any,2})
    Scenred2Tree(n_nodes, n_vars, [Scenred2Node(data[i,:]) for i in 1:size(data)[1]])
end

function Scenred2Tree(f::Scenred2Fan, prms::Scenred2Prms)
    
    writedlm(f)
    writedlm(prms)

    run(`scenred2 $(Pkg.Dir.path())/Scenred2/build/scenred2Cmd.cmd -nogams`)

    raw_tree = readdlm("$(Pkg.Dir.path())/Scenred2/tmp/scenred2Out.dat")

    n_nodes = raw_tree[find(x->x=="NODES",raw_tree[:,1])[1],2]
    n_vars = raw_tree[find(x->x=="RANDOM",raw_tree[:,1])[1],2]

    ind_first_node = find(x->x==1,raw_tree[:,1])[1]
    data = raw_tree[ind_first_node:ind_first_node+n_nodes-1, 1:n_vars+2]
    println(data)

    Scenred2Tree(n_nodes, n_vars, data)

end

function LightGraphs.Graph(tree::Scenred2Tree)
    n_nodes = tree.n_nodes
    adjlist = [Array{Int,1}() for _ in 1:n_nodes]
    edgelabels = []
    nodelabels = [tree.nodes[1].data]
    for (i,n) in enumerate(tree.nodes[2:end])
        push!(adjlist[i+1], n.predecessor)
        push!(adjlist[n.predecessor], i+1)
        push!(edgelabels, n.conditional_probability)
        push!(nodelabels, n.data)
    end
    Graph(length(edgelabels), adjlist), edgelabels, nodelabels
end

function LightGraphs.DiGraph(tree::Scenred2Tree)
    n_nodes = tree.n_nodes
    fadjlist = [Array{Int,1}() for _ in 1:n_nodes]
    badjlist = [Array{Int,1}() for _ in 1:n_nodes]
    edgelabels = Dict()
    nodelabels = [tree.nodes[1].data]
    for (i,n) in enumerate(tree.nodes[2:end])
        #push!(badjlist[i+1], n.predecessor)
        push!(fadjlist[n.predecessor], i+1)
        edgelabels[(n.predecessor, i+1)] = n.conditional_probability
        push!(nodelabels, n.data)
    end
    DiGraph(length(edgelabels), fadjlist, badjlist), edgelabels, nodelabels
end

function LightGraphs.DiGraph(fan::Scenred2Fan)
    nT = fan.TIME
    nS = fan.SCEN
    nR = fan.RANDOM
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
            #push!(badjlist[1+(is-1)*nT+t+1], 1+(is-1)*nT+t)
        end
        nodelabels[1+(is-1)*nT+nT] = s.data[nT,:]
    end

    DiGraph(length(edgelabels), fadjlist, badjlist), edgelabels, nodelabels
end