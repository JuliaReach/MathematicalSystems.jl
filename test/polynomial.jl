using MathematicalSystems, Test
import TypedPolynomials

@testset "Polynomial coefficient types" begin
    TypedPolynomials.@polyvar x
    # Variables and monomials use Int coefficients before TypedPolynomials v0.5.
    monomial_coefficient_type = TypedPolynomials.coefficient_type(x)
    for (p, T) in ((x, monomial_coefficient_type), (x^2, monomial_coefficient_type),
                   (2x, Int), (2.0x + x^2, Float64))
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
