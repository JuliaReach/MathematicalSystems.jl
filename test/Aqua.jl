using MathematicalSystems, Test
import Aqua

@testset "Aqua tests" begin
    @static if VERSION < v"1.6"
        unbound_args = true
    else
        # the unbound args should be resolved in the future
        unbound_args = (broken=true,)
    end

    Aqua.test_all(MathematicalSystems;
                  ambiguities=false, unbound_args=unbound_args)

    @static if VERSION < v"1.6"
        # do not warn about ambiguities in dependencies
        Aqua.test_ambiguities(MathematicalSystems)
    else
        # the ambiguities should be resolved in the future
        Aqua.test_ambiguities(MathematicalSystems; broken=true)
    end
end
