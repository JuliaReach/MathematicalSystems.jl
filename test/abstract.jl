# test default implementations for abstract types

using MathematicalSystems: AbstractDiscretizationAlgorithm,
                           _discretize

@testset "AbstractSystem" begin
    struct MyAbstractSystem <: AbstractSystem end

    s = MyAbstractSystem()
    @test isnothing(statedim(s))
    @test isnothing(stateset(s))
    @test isnothing(inputdim(s))
    @test isnothing(inputset(s))
    @test isnothing(noisedim(s))
    @test isnothing(noiseset(s))
    @test isnothing(islinear(s))
    @test isnothing(isaffine(s))
    @test isnothing(ispolynomial(s))
    @test isnothing(isblackbox(s))
    @test isnothing(isnoisy(s))
    @test isnothing(iscontrolled(s))
    @test isnothing(isconstrained(s))
    @test isnothing(state_matrix(s))
    @test isnothing(input_matrix(s))
    @test isnothing(noise_matrix(s))
    @test isnothing(affine_term(s))
    @test isnothing(outputmap(s))
end

@testset "AbstractMap" begin
    struct MyAbstractMap <: AbstractMap end

    m = MyAbstractMap()
    @test isnothing(outputdim(m))
    @test isnothing(islinear(m))
    @test isnothing(isaffine(m))
    @test isnothing(apply(m))
end

@testset "AbstractDiscretizationAlgorithm" begin
    struct MyAbstractDiscretizationAlgorithm <: AbstractDiscretizationAlgorithm end

    a = MyAbstractDiscretizationAlgorithm()
    M = hcat([1])
    @test isnothing(_discretize(a, 0, M, M, [0], M))
end
