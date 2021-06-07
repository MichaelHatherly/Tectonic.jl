using Pkg.Artifacts
using Pkg.BinaryPlatforms
using URIs

function tectonic()
    pkgname = "tectonic"
    origin = "https://github.com/tectonic-typesetting/tectonic/releases/download"
    version = v"0.5.0"
    build = 1

    downloads = Dict(
        "$origin/tectonic%40$version/tectonic-$version-x86_64-unknown-linux-musl.tar.gz" => Linux(:x86_64),
        "$origin/tectonic%40$version/tectonic-$version-x86_64-pc-windows-msvc.zip" => Windows(:x86_64),
        "$origin/tectonic%40$version/tectonic-$version-x86_64-apple-darwin.tar.gz" => MacOS(:x86_64),
    )

    build_path = joinpath(@__DIR__, "build")

    ispath(build_path) && rm(build_path; recursive=true, force=true)

    mkpath(build_path)

    artifact_toml = joinpath(@__DIR__, "Artifacts.toml")

    mktempdir() do temp_path
        for (url, platform) in downloads
            file = basename(url)
            @info "downloading" platform url file
            download(url, file)

            @info "unpacking" file
            product_hash = create_artifact() do artifact_dir
                if endswith(file, ".zip")
                    run(`unzip $file -d $artifact_dir`)
                elseif endswith(file, ".tar.gz")
                    run(`tar -xvf $file -C $artifact_dir`)
                else
                    error("cannot unpack that: $file")
                end
                files = readdir(artifact_dir)
            end
            @info "artifact" product_hash

            archive_filename = "$pkgname-$version+$build-$(triplet(platform)).tar.gz"
            download_hash = archive_artifact(product_hash, joinpath(build_path, archive_filename))

            @info "binding" archive_filename
            bind_artifact!(
                artifact_toml,
                "tectonic_bin",
                product_hash,
                platform=platform,
                force=true,
                download_info=Tuple[
                    (
                     "https://github.com/MichaelHatherly/Tectonic.jl/releases/download/tectonic-$(URIs.escapeuri("$(version)+$(build)"))/$archive_filename",
                     download_hash
                    )
                ]
            )
        end
    end
end

function biber()
    pkgname = "biber"
    origin = "https://sourceforge.net/projects/biblatex-biber/files/biblatex-biber"
    version = "2.14"
    build = 1

    downloads = Dict(
        "$origin/$version/binaries/Linux/biber-linux_x86_64.tar.gz" => Linux(:x86_64),
        "$origin/$version/binaries/Windows/biber-MSWIN64.zip" => Windows(:x86_64),
        "$origin/$version/binaries/OSX_Intel/biber-darwin_x86_64.tar.gz" => MacOS(:x86_64),
    )

    build_path = joinpath(@__DIR__, "build")

    ispath(build_path) && rm(build_path; recursive=true, force=true)

    mkpath(build_path)

    artifact_toml = joinpath(@__DIR__, "Artifacts.toml")

    mktempdir() do temp_path
        for (url, platform) in downloads
            file = basename(url)
            @info "downloading" platform url file
            download(url, file)

            @info "unpacking" file
            product_hash = create_artifact() do artifact_dir
                if endswith(file, ".zip")
                    run(`unzip $file -d $artifact_dir`)
                elseif endswith(file, ".tar.gz")
                    run(`tar -xvf $file -C $artifact_dir`)
                else
                    error("cannot unpack that: $file")
                end
                files = readdir(artifact_dir)
            end
            @info "artifact" product_hash

            archive_filename = "$pkgname-$version+$build-$(triplet(platform)).tar.gz"
            download_hash = archive_artifact(product_hash, joinpath(build_path, archive_filename))

            @info "binding" archive_filename
            bind_artifact!(
                artifact_toml,
                "biber_bin",
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
end