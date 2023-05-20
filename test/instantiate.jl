using MathematicalSystems: _instantiate

@testset "instantiate" begin
    struct MyAbstractSystemInstantiate <: AbstractSystem end
    s = MyAbstractSystemInstantiate()
    MathematicalSystems.statedim(::MyAbstractSystemInstantiate) = 0
    MathematicalSystems.inputdim(::MyAbstractSystemInstantiate) = 0
    MathematicalSystems.noisedim(::MyAbstractSystemInstantiate) = 0
    MathematicalSystems.isconstrained(::MyAbstractSystemInstantiate) = false
    MathematicalSystems.iscontrolled(::MyAbstractSystemInstantiate) = true
    MathematicalSystems.isnoisy(::MyAbstractSystemInstantiate) = false
    MathematicalSystems.islinear(::MyAbstractSystemInstantiate) = false
    MathematicalSystems.isaffine(::MyAbstractSystemInstantiate) = false
    MathematicalSystems.ispolynomial(::MyAbstractSystemInstantiate) = false
    MathematicalSystems.isblackbox(::MyAbstractSystemInstantiate) = false
    @test_throws ArgumentError _instantiate(s, zeros(0))
    @test_throws ArgumentError _instantiate(s, zeros(0), zeros(0))
    @test_throws ArgumentError _instantiate(s, zeros(0), zeros(0), zeros(0))

    s = LinearContinuousSystem(rand(2, 2))
    @test_throws ArgumentError _instantiate(s, zeros(2), zeros(0))
end
