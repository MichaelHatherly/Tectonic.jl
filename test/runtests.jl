using Test, Tectonic, Tectonic.Biber

tryrun(f) = try; (f(); true); catch err; rethrow(err); end

mktempdir() do dir
    for f in ["test.tex", "bib.tex", "CITATION.bib"]
        cp(joinpath(@__DIR__, f), joinpath(dir, f))
    end
    cd(dir) do
        @testset "Tectonic" begin
            @testset "tectonic" begin
                @test isfile(binary())
                @test version() == v"0.7.1"
                # Compile a file, clean up afterwards.
                @test !isfile("test.pdf")
                @test tryrun() do
                    tectonic() do bin
                        run(`$bin -w https://relay.fullyjustified.net/default_bundle.tar test.tex`)
                    end
                end
                @test isfile("test.pdf")
            end
            @testset "biber" begin
                @test isfile(Biber.binary())
                @test Biber.version() == v"2.14.0"
                @test tryrun() do
                    biber() do _
                        tectonic() do bin
                            run(`$bin -w https://relay.fullyjustified.net/default_bundle.tar bib.tex`)
                        end
                    end
                end
                @test isfile("bib.pdf")
            end
        end
    end
end
