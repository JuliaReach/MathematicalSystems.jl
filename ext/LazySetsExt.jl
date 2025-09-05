module LazySetsExt

import MathematicalSystems
using MathematicalSystems: LinearParametricContinuousSystem,
                           LinearParametricDiscreteSystem,
                           LinearControlParametricContinuousSystem,
                           LinearControlParametricDiscreteSystem

@static if isdefined(Base, :get_extension)
    using LazySets: MatrixZonotope
else
    using ..LazySets: MatrixZonotope
end

for Z in (:LinearParametricContinuousSystem, :LinearParametricDiscreteSystem)
    BaseName = Symbol(replace(string(Z), "Parametric" => ""))

    @eval begin
        function MathematicalSystems.$(BaseName)(AS::MatrixZonotope)
            return $Z(AS)
        end
    end
end

for Z in (:LinearControlParametricContinuousSystem, :LinearControlParametricDiscreteSystem)
    BaseName = Symbol(replace(string(Z), "Parametric" => ""))

    @eval begin
        function MathematicalSystems.$(BaseName)(AS::MatrixZonotope, BS::MatrixZonotope)
            return $Z(AS, BS)
        end
    end
end

end  # module
