depsfile = joinpath(dirname(@__FILE__),"deps.jl")
if isfile(depsfile)
    rm(depsfile)
end

tmpdir = "$(Pkg.Dir.path())/Scenred2/tmp" 
if ~isdir(tmpdir)
    mkdir(tmpdir) 
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

write_depsfile(tmpdir)
