"""
Provider module for the `biber` executable.
"""
module Biber

export biber

using Pkg.Artifacts

let __binary__ = Ref("")
    global function __init__()
        file = joinpath(@__DIR__, "..", "Artifacts.toml")
        info = artifact_meta("biber_bin", file)
        path = artifact_path(Base.SHA1(info["git-tree-sha1"]))
        ext = Sys.iswindows() ? ".exe" : ""
        __binary__[] = joinpath(path, "biber$(ext)")
    end
    global binary() = __binary__[]
end

"""
    biber(f)

Call function `f` with the *biber* binary path as argument.

```julia
biber() do bin
    run(`\$bin file`)
end
```
"""
biber(f) = f(binary())

version() = VersionNumber(lstrip(!isnumeric, biber(bin -> readchomp(`$bin --version`))))

end