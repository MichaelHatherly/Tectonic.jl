module Tectonic

export tectonic, version

using Pkg.Artifacts

"Path to `tectonic` binary."
tectonic() = cached_bin()

"`tectonic` version."
version() = readchomp(`$(tectonic()) --version`)

let ref = Ref("")
    global function cached_bin()
        if isempty(ref[])
            file = joinpath(@__DIR__, "..", "Artifacts.toml")
            info = artifact_meta("tectonic_bin", file)
            path = artifact_path(Base.SHA1(info["git-tree-sha1"]))
            ext = Sys.iswindows() ? ".exe" : ""
            ref[] = joinpath(path, "tectonic$(ext)")
        end
        return ref[]
    end
end

end # module
