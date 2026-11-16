using MathematicalSystems, Test
import TypedPolynomials

@testset "Polynomial coefficient types" begin
    TypedPolynomials.@polyvar x
    for (p, T) in ((x, Bool), (x^2, Bool), (2x, Int), (2.0x + x^2, Float64))
        for S in (PolynomialContinuousSystem, PolynomialDiscreteSystem)
            s = S([p], 1)
            @test s isa S{T,typeof(p),Vector{typeof(p)}}
            @test MathematicalSystems.mapping(s) == [p]
            @test statedim(s) == 1
        end
        for S in (ConstrainedPolynomialContinuousSystem, ConstrainedPolynomialDiscreteSystem)
            X = :constraints
            s = S([p], 1, X)
            @test s isa S{T,typeof(p),Vector{typeof(p)},typeof(X)}
            @test MathematicalSystems.mapping(s) == [p]
            @test statedim(s) == 1
            @test stateset(s) === X
        end
    end
end
