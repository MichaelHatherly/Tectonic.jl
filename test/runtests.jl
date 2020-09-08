using Test, Tectonic

@testset "Tectonic" begin
    @test isfile(binary())
    @test version() == v"0.1.13-dev"
    # Compile a file, clean up afterwards.
    @test !isfile("test.pdf")
    @test try
        tectonic() do bin
            run(`$bin test.tex`)
        end
        true
    catch err
        rethrow(err)
    end
    @test isfile("test.pdf")
    rm("test.pdf"; force=true)
end
