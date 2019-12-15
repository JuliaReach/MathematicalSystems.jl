@testset "@map macro(ex)" begin
    n = 3
    A = rand(2, 2);
    b = rand(2)
    identitymap = @map x -> I(n)*x
    @test identitymap == MathematicalSystems.IdentityMap(n)
    linearmap = @map x -> A*x
    @test linearmap == MathematicalSystems.LinearMap(A)
    affinemap = @map x -> A*x + b
    @test affinemap == MathematicalSystems.AffineMap(A, b)
end
