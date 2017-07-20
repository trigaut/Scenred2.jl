function obj_to_dict!(d::Dict, obj; first_field::Int=1, last_field::Int=0)
    for i in fieldnames(obj)[first_field:end-last_field]
       d[string(i)] = eval(quote string($obj.$i) end)
    end
    filter!((k,v)->v>-1,d)
    filter((k,v)->v>-1,d)
end


function stringify(scenario::Scenred2Scenario)
    str = string(scenario.probability)"\n"
    for t in 1:size(scenario.data)[1]
        str = join([str,join(scenario.data[t,:], " ")"\n"])
    end
    str
end

function write_prms(prms::Scenred2Prms) 
    d = Dict()
    obj_to_dict!(d, prms)
    optfile = "$(scenred2tmpdir)/scenred2Opt.opt" 
    writedlm(optfile, d)
    optfile
end

function write_fan(fan::Scenred2Fan)
    d = Dict()
    d["TYPE FAN"] = "\nTIME $(fan.timesteps)\nSCEN $(fan.n_scen)\nRANDOM $(fan.n_random_variables)"
    scenarios = fan.scenarios
    d["DATA"] = "\n"
    for s in fan.scenarios
        d["DATA"] = join([d["DATA"], stringify(s)])
    end
    d["END"] = ""
    datfile = "$(scenred2tmpdir)/scenred2Fan.dat"
    writedlm(datfile, d, quotes = false)
    datfile
end

function write_tree(tree::Scenred2Tree)
    d = Dict()
    d["TYPE TREE"] = "\nNODES $(tree.n_nodes)\nRANDOM $(tree.n_random_variables)"
    d["DATA"] = "\n"
    d["* PRED PROB"] =  join(["RAND-$i " for i in 1:tree.n_random_variables])

    datfile = "$(scenred2tmpdir)/scenred2Tree.dat"
    writedlm(datfile, d, quotes = false)
    d["END"] = ""
end

function write_cmd(operation::string, runtime_limit::Float64, 
                    report_level::Int)

    cmdfile = "$(scenred2tmpdir)/scenred2Cmd.cmd"
    d = Dict()
    d["log_file"] = "$(scenred2tmpdir)/scenred2Log.log"
    d[operation] = "$(scenred2tmpdir)/scenred2Opt.opt"
    d["read_scen"] = "$(scenred2tmpdir)/scenred2Fan.dat"
    d["out_tree"] = "$(scenred2tmpdir)/scenred2Out.dat"

    (runtime_limit > -1)&&(d["runtime_limit"] = runtime_limit)
    (report_level > -1)&&(d["report_level"] = report_level)

    writedlm(cmdfile, d)
    cmdfile
end