using Pkg.Artifacts
using Pkg.BinaryPlatforms
using URIParser, FilePaths

pkgname = "tectonic"
origin = "https://github.com/tectonic-typesetting/tectonic/releases/download/continuous"
version = v"0.1.13-dev"
build = 1
release_info = read(download(joinpath(origin, "RELEASE-INFO.txt")), String)
commit = match(r"^commit=(.+)$"m, release_info)[1]

build_path = joinpath(@__DIR__, "build")

ispath(build_path) && rm(build_path; recursive=true, force=true)

mkpath(build_path)

artifact_toml = joinpath(@__DIR__, "Artifacts.toml")

platforms = [
    Linux(:x86_64),
    MacOS(:x86_64),
    Windows(:x86_64),
]

mktempdir() do temp_path
    for platform in platforms
        download_url =
            if platform isa Linux
                "tectonic-latest-x86_64-unknown-linux-musl.tar.gz"
            elseif platform isa MacOS
                "tectonic-latest-x86_64-apple-darwin.tar.gz"
            elseif platform isa Windows
                "tectonic-latest-x86_64-pc-windows-msvc.exe"
            else
                continue
            end
        download_url = joinpath(origin, download_url)
        download_filename = Path(temp_path) / Path(basename(Path(URI(download_url).path)))

        download(download_url, download_filename)

        product_hash = create_artifact() do artifact_dir
            if extension(download_filename) == "exe"
                cp(string(download_filename), joinpath(artifact_dir, "tectonic.exe"))
            else
                run(Cmd(`tar -xvf $download_filename -C $artifact_dir`))
            end

            files = readdir(artifact_dir)
        end

        archive_filename = "$pkgname-$commit-$(triplet(platform)).tar.gz"
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
    end
end
