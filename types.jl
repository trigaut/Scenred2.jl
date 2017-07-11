
type Scenred2Node
    predecessor::Int
    conditional_probability::Int
    data::Vector{Float64}
end


type Scenred2Tree
    n_random_variables::Int
    n_nodes::Int
    nodes::Dict{Int, Vector{Node}}
end

type Scenred2Scenario
    probability::Int
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
    red_percentage::Int
    order::Int
    scaling::Int
end

function Scenred2Prms(; construction_method::Int = 2, reduction_method = 1, 
                        order = 1, scaling = 0, red_percentage = 0.1)
    Scenred2Prms(construction_method, reduction_method, order, scaling, red_percentage)
end

function obj_to_dict!(d::Dict, obj; first_field::Int=1, last_field::Int=0)
    for i in fieldnames(prms)[first_field:end-last_field]
       d[i] = eval(quote prms.$i end)
       end
    end
end

function Base.writedlm(prms::Scenred2Prms) 
    d = Dict()
    obj_to_dict!(d, prms)
    writedlm("scenred2Opt.opt", d)
end

function Base.writedlm(prms::Scenred2Fan)
    d = Dict("TYPE" => "FAN")
    obj_tp_dict!(d, last_field=1)
    d["DATA"] = ""
    
    d["END"] = ""
end

function Scenred2Tree(f::Scenred2Fan, prms::Scenred2Prms)

end