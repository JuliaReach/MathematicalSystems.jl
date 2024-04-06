using MathematicalSystems, Test
import Aqua

@testset "Aqua tests" begin
    Aqua.test_all(MathematicalSystems;
                  ambiguities=false)

    # do not warn about ambiguities in dependencies
    Aqua.test_ambiguities(MathematicalSystems)
end
