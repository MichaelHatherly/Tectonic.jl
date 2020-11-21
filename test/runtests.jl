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
                @test version() == v"0.3.3"
                # Compile a file, clean up afterwards.
                @test !isfile("test.pdf")
                @test tryrun() do
                    tectonic() do bin
                        run(`$bin test.tex`)
                    end
                end
                @test isfile("test.pdf")
            end
            @testset "biber" begin
                @test isfile(Biber.binary())
                @test Biber.version() == v"2.14.0"

                # Test that we can use biber with tectonic. A single run of
                # tectonic is needed to create the initial temp files, which
                # must be retained. Then we run biber, followed by a complete
                # tectonic run again.

                @test tryrun() do
                    tectonic() do bin
                        run(`$bin --keep-intermediates --reruns 0 bib.tex`)
                    end
                end
                @test isfile("bib.run.xml")
                @test isfile("bib.pdf")
                @test isfile("bib.aux")
                @test isfile("bib.bcf")

                @test tryrun() do
                    biber() do bin
                        run(`$bin bib`)
                    end
                end
                @test isfile("bib.blg")

                @test tryrun() do
                    tectonic() do bin
                        run(`$bin bib.tex`)
                    end
                end
                @test isfile("bib.pdf")
            end
        end
    end
end
