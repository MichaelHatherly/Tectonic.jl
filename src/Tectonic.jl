module Tectonic

export binary, version

using Pkg.Artifacts

"Path to `tectonic` binary."
function binary end

"`tectonic` version."
function version end

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

version() = readchomp(`$(binary()) --version`)

end # module
