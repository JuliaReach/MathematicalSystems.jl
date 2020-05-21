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

@testset "@map macro(ex, args)" begin
    n = 3
    identitymap1 = @map(x->x, dim=n)
    identitymap2 = @map(x->x, dim:3)
    @test identitymap1 == identitymap2 == IdentityMap(n)
    X = BallInf(zeros(3), 1.0)
    identitymap3 = @map(x->x, dim:3, x ∈ X)
    @test identitymap3 == ConstrainedIdentityMap(3, X)
end
