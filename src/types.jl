
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
    timesteps::Int #Number of time steps
    n_scen::Int #Number of scenarios
    n_random_variables::Int #Number of random variables
    scenarios::Vector{Scenred2Scenario}
end

type Scenred2Prms
    #construction parameters
    construction_method::Int
    first_branch::Int
    eps_growth::Int
    eps_evolution::Float64

    #reduction parameters
    metric_type::Int
    p_norm::Int
    red_num_leaves::Int

    #common parameters
    red_percentage::Float64
    reduction_method::Int
    order::Int
    scaling::Int
end

function Scenred2Prms(; construction_method = 2, first_branch = -1, 
                        eps_growth = -1, eps_evolution = -1., 
                        metric_type = 1, p_norm = -1, red_num_leaves = -1,
                        red_percentage = 0.1, reduction_method = 1, 
                        order = 1, scaling = 1)
    Scenred2Prms(construction_method, first_branch, eps_growth, eps_evolution, 
                metric_type, p_norm, red_num_leaves, red_percentage, 
                reduction_method, order, scaling)
end

Scenred2Node(data::Vector{Any}) = Scenred2Node(floor(Int,data[1]), data[2], data[3:end])

function Scenred2Tree(n_nodes::Int, n_vars::Int, data::Array{Any,2})
    Scenred2Tree(n_nodes, n_vars, [Scenred2Node(data[i,:]) for i in 1:size(data)[1]])
end

function Scenred2Tree(f::Scenred2Fan, prms::Scenred2Prms ; runtime_limit = -1, 
                        report_level = -1)

    cmd_file = write_cmd("tree_con", runtime_limit, report_level)
    fanfile = write_fan(f)
    prmsfile = write_prms(prms)
    outfile = "$(scenred2tmpdir)/scenred2Out.dat"

    run(`scenred2 $(cmdfile) -nogams`)

    raw_tree = readdlm(outfile)

    rm(cmdfile)
    rm(fanfile)
    rm(prmsfile)
    rm(outfile)

    n_nodes = raw_tree[find(x->x=="NODES",raw_tree[:,1])[1],2]
    n_vars = raw_tree[find(x->x=="RANDOM",raw_tree[:,1])[1],2]

    ind_first_node = find(x->x==1,raw_tree[:,1])[1]
    data = raw_tree[ind_first_node:ind_first_node+n_nodes-1, 1:n_vars+2]

    Scenred2Tree(n_nodes, n_vars, data)

end
