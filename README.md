# Julia wrapper for SCENRED2

Scenred2.jl provides a julia interface to use [GAMS's SCENRED2](https://www.gams.com/latest/docs/tools/scenred2/index.html) scenario trees construction and reduction tool.
SCENRED2 is developed by [Dr. Holger Heitsch](https://www.wias-berlin.de/people/heitsch/), this wrapper is unofficial.
This package is available free of charge and in no way replaces or alters any functionality of GAMS's SCENRED2 product.

## Setting up SCENRED2 on Linux

- scenred2 executable is available with [GAMS](https://www.gams.com/)
- You must add scenred2 in your PATH (or create a symbolic link in a bin directory)

## Install

```julia
julia> Pkg.clone("https://github.com/trigaut/Scenred2.jl.git")
julia> Pkg.build("Scenred2")
```
