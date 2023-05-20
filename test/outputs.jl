@testset "Unconstrained LTI system" begin
    A = [1.0 1; 1 -1]
    B = Matrix([0.5 1.5]')
    C = Matrix([0.5 1.5])
    D = Matrix([1.0]')
    s = LinearTimeInvariantSystem(A, B, C, D)
    @test statedim(s) == 2
    @test inputdim(s) == 1
    @test outputmap(s) isa LinearControlMap
    @test outputdim(s) == 1

    # check alias
    s = LTISystem(A, B, C, D)

    # check the LTI system's outputmap fields
    @test outputmap(s).A == C
    @test outputmap(s).B == D

    # check the LTI system's system (s) field
    @test s.s.A == A
    @test s.s.B == B

    # check that the system is linear
    @test islinear(s) && isaffine(s)
end

@testset "Constrained LTI system" begin
    A = [1.0 1; 1 -1]
    B = Matrix([0.5 1.5]')
    C = Matrix([0.5 1.5])
    D = Matrix([1.0]')
    X = Line([1.0, -1], 0.0)
    U = Interval(0.9, 1.1)
    s = LinearTimeInvariantSystem(A, B, C, D, X, U)
    @test statedim(s) == 2
    @test inputdim(s) == 1
    @test inputset(s) == U
    @test outputmap(s) isa ConstrainedLinearControlMap
    @test outputdim(s) == 1

    # check alias
    s = LTISystem(A, B, C, D, X, U)

    # check that the system is linear
    @test islinear(s) && isaffine(s)
end
