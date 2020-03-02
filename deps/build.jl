scenred2depsdir = dirname(@__FILE__)

depsfile = joinpath(scenred2depsdir,"deps.jl")
if isfile(depsfile)
    rm(depsfile)
end

tmpdir = scenred2depsdir*"/../tmp" 
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
