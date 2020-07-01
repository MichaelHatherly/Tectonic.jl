using Test, Tectonic

@testset "Tectonic" begin
    @test isfile(Tectonic.tectonic())
    @test Tectonic.version() == "Tectonic 0.1.13-dev"
    # Compile a file, clean up afterwards.
    @test !isfile("test.pdf")
    @test try
        run(`$(tectonic()) test.tex`)
        true
    catch err
        rethrow(err)
    end
    @test isfile("test.pdf")
    rm("test.pdf"; force=true)
end
