@testset "Discrete linear system" begin
    for sd in 1:3
        s = DiscreteLinearSystem(zeros(sd, sd))
        @test statedim(s) == sd
        @test inputdim(s) == 0
    end
end
