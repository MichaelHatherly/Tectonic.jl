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

binary() = joinpath(artifact"tectonic_bin", "tectonic$(Sys.iswindows() ? ".exe" : "")")

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
