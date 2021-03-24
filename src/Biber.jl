"""
Provider module for the `biber` executable.
"""
module Biber

export biber

using Pkg.Artifacts

binary() = joinpath(artifact"biber_bin", "biber$(Sys.iswindows() ? ".exe" : "")")

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