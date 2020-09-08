version = "0.1.13"
build = 1

using Pkg.Artifacts
using Pkg.BinaryPlatforms
using URIParser

origin = "https://github.com/tectonic-typesetting/tectonic/releases/download/tectonic@$(version)/"

artifact_toml = joinpath(@__DIR__, "Artifacts.toml")
build_path = joinpath(@__DIR__, "build")

platforms = [
    (Linux(:armv7l, libc=:musl, call_abi=:eabihf), "tectonic-$(version)-arm-unknown-linux-musleabihf.tar.gz"),
    (Linux(:x86_64, libc=:glibc),                  "tectonic-$(version)-x86_64-unknown-linux-gnu.tar.gz"),
    (Linux(:x86_64, libc=:musl),                   "tectonic-$(version)-x86_64-unknown-linux-musl.tar.gz"),
    (MacOS(:x86_64),                               "tectonic-$(version)-x86_64-apple-darwin.tar.gz"),
    (Windows(:x86_64),                             "tectonic-$(version)-x86_64-pc-windows-gnu.zip"),
]

@info "create build directory"
ispath(build_path) && rm(build_path; recursive=true, force=true)
mkpath(build_path)

for (platform, file) in platforms
    @info platform file
    download_url = origin * file
    download(download_url, file)
    product_hash = create_artifact() do artifact_dir
        if endswith(file, ".zip")
            run(Cmd(`unzip $file -d $artifact_dir`))
        else
            run(Cmd(`tar -xvf $file -C $artifact_dir`))
        end
        files = readdir(artifact_dir)
    end
    @info "building artifact"
    archive_filename = "tectonic-$(version)-$(triplet(platform)).tar.gz"
    download_hash = archive_artifact(product_hash, joinpath(build_path, archive_filename))
    bind_artifact!(
        artifact_toml,
        "tectonic_bin",
        product_hash,
        platform=platform,
        force=true,
        download_info=Tuple[
            (
             "https://github.com/MichaelHatherly/Tectonic.jl/releases/download/$(URIParser.escape("$(version)+$(build)"))/$archive_filename",
             download_hash
            )
        ]
    )
    rm(file; force=true)
end
