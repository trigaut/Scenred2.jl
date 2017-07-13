depsfile = joinpath(dirname(@__FILE__),"deps.jl")
if isfile(depsfile)
    rm(depsfile)
end

cmdfile = joinpath(dirname(@__FILE__),"scenred2Cmd.cmd")
if isfile(cmdfile)
    rm(cmdfile)
end

function write_depsfile(tmppath)
    open(depsfile,"w") do f
        print(f,"const scenred2tmpdir = ")
        show(f, tmppath) 
        println(f)
        print(f,"const scenred2depsdir = ")
        show(f, dirname(@__FILE__)) 
        println(f)
    end
end

tmpdir = "$(Pkg.Dir.path())/Scenred2/tmp" 

if ~isdir(tmpdir)
    mkdir(tmpdir) 
end

d = Dict()
d["log_file"] = "$(tmpdir)/scenred2Log.log"
d["tree_con"] = "$(tmpdir)/scenred2Opt.opt"
d["read_scen"] = "$(tmpdir)/scenred2Fan.dat"
d["out_tree"] = "$(tmpdir)/scenred2Out.dat"

writedlm(cmdfile, d)

write_depsfile(tmpdir)
