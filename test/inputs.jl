@testset "Constant input" begin
    c = ConstantInput(1.0)

    @test eltype(c) == Float64
    @test Base.IteratorSize(typeof(c)) == Base.IsInfinite()
    @test Base.IteratorEltype(typeof(c)) == Base.HasEltype()

    i = 0
    for ci in c
        @test ci == 1.0
        i += 1
        i <= 10 || break
    end
    @test i == 11

    @test  length(nextinput(c, 2)) == 2
    i = 1
    for val in nextinput(c, 2)
        @test i <= 2 && val == 1.0
        i += 1
    end

    c2 = map(x->x^2, c)
    @test c2.U == (c.U)^2
 end

@testset "Varying input" begin
    v = VaryingInput([1.0, 2.0, 3.0])

    @test eltype(v) == Float64
    @test Base.IteratorSize(typeof(v)) == Base.HasLength()
    @test Base.IteratorEltype(typeof(v)) == Base.HasEltype()

    @test length(v) == 3
    @test collect(v) == [1.0, 2.0, 3.0]

    @test  length(nextinput(v, 2)) == 2
    i = 1
    for val in nextinput(v, 2)
        @test i <= 2 && val == v.U[i]
        i += 1
    end

    v2 = map(x->x.^2, v)
    @test all([v2.U[i] == vi^2 for (i, vi) in enumerate(v)])
 end
