"""
Provider module for the `biber` executable.
"""
module Biber

export biber

using Pkg.Artifacts

binary() = joinpath(artifact"biber_bin", "biber$(Sys.iswindows() ? ".exe" : "")")

"""
    biber(f)

Call function `f` with the `biber` command available on `PATH` for the duration of `f`.

```julia
biber() do bin
    run(`\$bin file`)
end
```
"""
function biber(f)
    dir, bin = splitdir(binary())
    path = ENV["PATH"]
    withenv("PATH" => "$(dir):$path") do
        f(bin)
    end
end

version() = VersionNumber(lstrip(!isnumeric, biber(bin -> readchomp(`$bin --version`))))

end
