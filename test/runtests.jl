using Test, Tectonic

@testset "Tectonic" begin
    @test isfile(Tectonic.tectonic())
    @test Tectonic.version() == "Tectonic 0.1.13-dev"
    # Compile a file, clean up afterwards.
    @test !isfile("test.pdf")
    @test success(`$(Tectonic.tectonic()) test.tex`)
    @test isfile("test.pdf")
    rm("test.pdf"; force=true)
end
