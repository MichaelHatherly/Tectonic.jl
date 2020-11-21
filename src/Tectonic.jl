"""
Wrapper module for [*tectonic*](https://github.com/tectonic-typesetting/tectonic).
"""
module Tectonic

export binary, tectonic, version, Biber

using Pkg.Artifacts

"""
    tectonic(f)

Call function `f` with the *tectonic* binary path as argument.

```julia
tectonic() do bin
    run(`\$bin file.tex`)
end
```

All required setup and clean-up to run the binary correctly is done automatically.

!!! note

    Currently nothing is needed to be done to run the binary, but this may
    change in future and this provides a future-proof interface to the package.
"""
tectonic(f) = f(binary())

"""
Version of *tectonic* provided by this package.
"""
version() = VersionNumber(lstrip(!isnumeric, tectonic(bin -> readchomp(`$bin --version`))))

let __binary__ = Ref("")
    global function __init__()
        file = joinpath(@__DIR__, "..", "Artifacts.toml")
        info = artifact_meta("tectonic_bin", file)
        path = artifact_path(Base.SHA1(info["git-tree-sha1"]))
        ext = Sys.iswindows() ? ".exe" : ""
        __binary__[] = joinpath(path, "tectonic$(ext)")
    end
    global binary() = __binary__[]
end

"""
Path to *tectonic* binary.

!!! warning

    This should not be used to run the program directly, please use the
    [`tectonic`](@ref) function instead since it performs the required setup
    and clean up steps needed.
"""
binary()

include("Biber.jl")

end # module
