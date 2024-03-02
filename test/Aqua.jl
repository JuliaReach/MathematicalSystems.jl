using MathematicalSystems, Test
import Aqua

@testset "Aqua tests" begin
    Aqua.test_all(MathematicalSystems;
                  ambiguities=false)

    @static if VERSION < v"1.6"
        # do not warn about ambiguities in dependencies
        Aqua.test_ambiguities(MathematicalSystems)
    else
        # the ambiguities should be resolved in the future
        Aqua.test_ambiguities(MathematicalSystems; broken=true)
    end
end
