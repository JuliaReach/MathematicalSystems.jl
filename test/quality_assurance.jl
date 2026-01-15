using MathematicalSystems, Test
import Aqua, ExplicitImports

@testset "ExplicitImports tests" begin
    ignores = (:checksquare,)
    @test isnothing(ExplicitImports.check_all_explicit_imports_are_public(MathematicalSystems;
                                                                          ignore=ignores))
    @test isnothing(ExplicitImports.check_all_explicit_imports_via_owners(MathematicalSystems))
    ignores = (:AbstractRotation, :IsInfinite, :typename, :parse,
               :AbstractTriangular, :IteratorSize)
    @test isnothing(ExplicitImports.check_all_qualified_accesses_are_public(MathematicalSystems;
                                                                            ignore=ignores))
    @test isnothing(ExplicitImports.check_all_qualified_accesses_via_owners(MathematicalSystems))
    @test isnothing(ExplicitImports.check_no_implicit_imports(MathematicalSystems))
    @test isnothing(ExplicitImports.check_no_self_qualified_accesses(MathematicalSystems))
    ignores = (:LinearParametricContinuousSystem,
               :LinearParametricDiscreteSystem,
               :LinearControlParametricContinuousSystem,
               :LinearControlParametricDiscreteSystem)  # false positives due to meta-programming
    @test isnothing(ExplicitImports.check_no_stale_explicit_imports(MathematicalSystems;
                                                                    ignore=ignores))
end

@testset "Aqua tests" begin
    Aqua.test_all(MathematicalSystems)
end
