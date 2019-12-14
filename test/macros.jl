@testset "@map macro" begin
    A = rand(2, 2);
    map = @map x -> A*x
    @test MathematicalSystems.LinearMap(A) == map
end
