
struct Scenred2Node
    predecessor::Int
    probability::Float64
    data::Vector{Float64}
end


struct Scenred2Tree
    n_nodes::Int
    n_random_variables::Int
    nodes::Vector{Scenred2Node}
end

struct Scenred2Scenario
    probability::Float64
    data::Array{Float64,2}
end

struct Scenred2Fan
    timesteps::Int #Number of time steps
    n_scen::Int #Number of scenarios
    n_random_variables::Int #Number of random variables
    scenarios::Vector{Scenred2Scenario}
end

mutable struct Scenred2Prms
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

    construct_tree(f, prms, runtime_limit = runtime_limit, report_level = report_level)

end
