import MultivariatePolynomials
import MultivariatePolynomials: AbstractPolynomialLike

# check if a matrix is square
@inline function issquare(A::AbstractMatrix)
    return size(A, 1) == size(A, 2)
end

for (Z, AZ) in ((:ContinuousIdentitySystem, :AbstractContinuousSystem),
                (:DiscreteIdentitySystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z) <: $(AZ)
            statedim::Int
        end
        statedim(s::$Z) = s.statedim
        inputdim(s::$Z) = 0
        noisedim(s::$Z) = 0
        state_matrix(s::$Z) = I(s.statedim)
    end
    for T in [Z, Type{<:eval(Z)}]
        @eval begin
            islinear(::$T) = true
            isaffine(::$T) = true
            ispolynomial(::$T) = false
            isnoisy(::$T) = false
            iscontrolled(::$T) = false
            isconstrained(::$T) = false
        end
    end
end

@doc """
    ContinuousIdentitySystem <: AbstractContinuousSystem

Trivial identity continuous-time system of the form:

```math
    x(t)' = 0 \\; \\forall t.
```

### Fields

- `statedim` -- number of state variables
"""
ContinuousIdentitySystem

@doc """
    DiscreteIdentitySystem <: AbstractDiscreteSystem

Trivial identity discrete-time system of the form:
```math
    x_{k+1} = x_k \\; \\forall k.
```

### Fields

- `statedim` -- number of state variables
"""
DiscreteIdentitySystem

for (Z, AZ) in ((:ConstrainedContinuousIdentitySystem, :AbstractContinuousSystem),
                (:ConstrainedDiscreteIdentitySystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z){ST} <: $(AZ)
            statedim::Int
            X::ST
        end
        statedim(s::$Z) = s.statedim
        inputdim(::$Z) = 0
        noisedim(::$Z) = 0
        stateset(s::$Z) = s.X
        state_matrix(s::$Z) = I(s.statedim)
    end
    for T in [Z, Type{<:eval(Z)}]
        @eval begin
            islinear(::$T) = true
            isaffine(::$T) = true
            ispolynomial(::$T) = false
            isnoisy(::$T) = false
            iscontrolled(::$T) = false
            isconstrained(::$T) = true
        end
    end
end

@doc """
    ConstrainedContinuousIdentitySystem <: AbstractContinuousSystem

Trivial identity continuous-time system with domain constraints of the form:

```math
    x(t)' = 0, \\; x(t) ∈ \\mathcal{X} \\; \\forall t.
```

### Fields

- `statedim` -- number of state variables
- `X`        -- state constraints
"""
ConstrainedContinuousIdentitySystem

@doc """
    ConstrainedDiscreteIdentitySystem <: AbstractDiscreteSystem

Trivial identity discrete-time system with domain constraints of the form:

```math
    x_{k+1} = x_k, \\; x_k ∈ \\mathcal{X} \\; \\forall k.
```

### Fields

- `statedim` -- number of state variables
- `X`        -- state constraints
"""
ConstrainedDiscreteIdentitySystem

for (Z, AZ) in ((:LinearContinuousSystem, :AbstractContinuousSystem),
                (:LinearDiscreteSystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z){T, MT <: AbstractMatrix{T}} <: $(AZ)
            A::MT
            function $(Z)(A::MT) where {T, MT <: AbstractMatrix{T}}
                @assert issquare(A)
                return new{T, MT}(A)
            end
        end
        function $(Z)(A::Number)
             return $(Z)(hcat(A))
        end

        statedim(s::$Z) = size(s.A, 1)
        inputdim(::$Z) = 0
        noisedim(::$Z) = 0
        state_matrix(s::$Z) = s.A
    end
    for T in [Z, Type{<:eval(Z)}]
        @eval begin
            islinear(::$T) = true
            isaffine(::$T) = true
            ispolynomial(::$T) = false
            isnoisy(::$T) = false
            iscontrolled(::$T) = false
            isconstrained(::$T) = false
        end
    end
end

@doc """
    LinearContinuousSystem

Continuous-time linear system of the form:

```math
    x(t)' = A x(t) \\; \\forall t.
```

### Fields

- `A` -- state matrix
"""
LinearContinuousSystem

@doc """
    LinearDiscreteSystem

Discrete-time linear system of the form:

```math
    x_{k+1} = A x_k \\; \\forall k.
```

### Fields

- `A` -- state matrix
"""
LinearDiscreteSystem

for (Z, AZ) in ((:AffineContinuousSystem, :AbstractContinuousSystem),
                (:AffineDiscreteSystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z){T, MT <: AbstractMatrix{T}, VT <: AbstractVector{T}} <: $(AZ)
            A::MT
            c::VT
            function $(Z)(A::MT, c::VT) where {T, MT <: AbstractMatrix{T}, VT <: AbstractVector{T}}
                @assert checksquare(A) == length(c)
                return new{T, MT, VT}(A, c)
            end
        end
        function $(Z)(A::Number, c::Number)
             return $(Z)(hcat(A), vcat(c))
        end

        statedim(s::$Z) = length(s.c)
        inputdim(::$Z) = 0
        noisedim(::$Z) = 0
        state_matrix(s::$Z) = s.A
        affine_term(s::$Z) = s.c
    end
    for T in [Z, Type{<:eval(Z)}]
        @eval begin
            islinear(::$T) = false
            isaffine(::$T) = true
            ispolynomial(::$T) = false
            isnoisy(::$T) = false
            iscontrolled(::$T) = false
            isconstrained(::$T) = false
        end
    end
end

@doc """
    AffineContinuousSystem

Continuous-time affine system of the form:

```math
    x(t)' = A x(t) + c \\; \\forall t.
```

### Fields

- `A` -- state matrix
- `c` -- affine term
"""
AffineContinuousSystem

@doc """
    AffineDiscreteSystem

Discrete-time affine system of the form:

```math
    x_{k+1} = A x_k + c \\; \\forall k.
```

### Fields

- `A` -- state matrix
- `c` -- affine term
"""
AffineDiscreteSystem

for (Z, AZ) in ((:LinearControlContinuousSystem, :AbstractContinuousSystem),
                (:LinearControlDiscreteSystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z){T, MTA <: AbstractMatrix{T}, MTB <: AbstractMatrix{T}} <: $(AZ)
            A::MTA
            B::MTB
            function $(Z)(A::MTA, B::MTB) where {T, MTA <: AbstractMatrix{T}, MTB <: AbstractMatrix{T}}
                @assert checksquare(A) == size(B, 1)
                return new{T, MTA, MTB}(A, B)
            end
        end
        function $(Z)(A::Number, B::Number)
             return $(Z)(hcat(A), hcat(B))
        end

        statedim(s::$Z) = size(s.A, 1)
        inputdim(s::$Z) = size(s.B, 2)
        noisedim(::$Z) = 0
        state_matrix(s::$Z) = s.A
        input_matrix(s::$Z) = s.B
    end
    for T in [Z, Type{<:eval(Z)}]
        @eval begin
            islinear(::$T) = true
            isaffine(::$T) = true
            ispolynomial(::$T) = false
            isnoisy(::$T) = false
            iscontrolled(::$T) = true
            isconstrained(::$T) = false
        end
    end
end

@doc """
    LinearControlContinuousSystem

Continuous-time linear control system of the form:

```math
    x(t)' = A x(t) + B u(t) \\; \\forall t.
```

### Fields

- `A` -- state matrix
- `B` -- input matrix
"""
LinearControlContinuousSystem

@doc """
    LinearControlDiscreteSystem

Discrete-time linear control system of the form:

```math
    x_{k+1} = A x_k + B u_k \\; \\forall k.
```

### Fields

- `A` -- state matrix
- `B` -- input matrix
"""
LinearControlDiscreteSystem

for (Z, AZ) in ((:ConstrainedLinearContinuousSystem, :AbstractContinuousSystem),
                (:ConstrainedLinearDiscreteSystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z){T, MT <: AbstractMatrix{T}, ST} <: $(AZ)
            A::MT
            X::ST
            function $(Z)(A::MT, X::ST) where {T, MT <: AbstractMatrix{T}, ST}
                @assert issquare(A)
                return new{T, MT, ST}(A, X)
            end
        end
        function $(Z)(A::Number, X)
             return $(Z)(hcat(A), X)
        end

        statedim(s::$Z) = size(s.A, 1)
        inputdim(::$Z) = 0
        noisedim(::$Z) = 0
        stateset(s::$Z) = s.X
        state_matrix(s::$Z) = s.A
    end
    for T in [Z, Type{<:eval(Z)}]
        @eval begin
            islinear(::$T) = true
            isaffine(::$T) = true
            ispolynomial(::$T) = false
            isnoisy(::$T) = false
            iscontrolled(::$T) = false
            isconstrained(::$T) = true
        end
    end
end

@doc """
    ConstrainedLinearContinuousSystem

Continuous-time linear system with domain constraints of the form:

```math
    x(t)' = A x(t), \\; x(t) ∈ \\mathcal{X} \\; \\forall t.
```

### Fields

- `A` -- state matrix
- `X` -- state constraints
"""
ConstrainedLinearContinuousSystem

@doc """
    ConstrainedLinearDiscreteSystem

Discrete-time linear system with domain constraints of the form:

```math
    x_{k+1} = A x_k, \\; x_k ∈ \\mathcal{X} \\; \\forall k.
```

### Fields

- `A` -- state matrix
- `X` -- state constraints
"""
ConstrainedLinearDiscreteSystem

for (Z, AZ) in ((:ConstrainedAffineContinuousSystem, :AbstractContinuousSystem),
                (:ConstrainedAffineDiscreteSystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z){T, MT <: AbstractMatrix{T}, VT <: AbstractVector{T}, ST} <: $(AZ)
            A::MT
            c::VT
            X::ST
            function $(Z)(A::MT, c::VT, X::ST) where {T, MT <: AbstractMatrix{T}, VT <: AbstractVector{T}, ST}
                @assert checksquare(A) == length(c)
                return new{T, MT, VT, ST}(A, c, X)
            end
        end
        function $(Z)(A::Number, c::Number, X)
             return $(Z)(hcat(A), vcat(c), X)
        end

        statedim(s::$Z) = length(s.c)
        inputdim(::$Z) = 0
        noisedim(::$Z) = 0
        stateset(s::$Z) = s.X
        state_matrix(s::$Z) = s.A
        affine_term(s::$Z) = s.c
    end
    for T in [Z, Type{<:eval(Z)}]
        @eval begin
            islinear(::$T) = false
            isaffine(::$T) = true
            ispolynomial(::$T) = false
            isnoisy(::$T) = false
            iscontrolled(::$T) = false
            isconstrained(::$T) = true
        end
    end
end

@doc """
    ConstrainedAffineContinuousSystem

Continuous-time affine system with domain constraints of the form:

```math
    x(t)' = A x(t) + c, \\; x(t) ∈ \\mathcal{X} \\; \\forall t.
```

### Fields

- `A` -- state matrix
- `c` -- affine term
- `X` -- state constraints
"""
ConstrainedAffineContinuousSystem

@doc """
    ConstrainedAffineDiscreteSystem

Discrete-time affine system with domain constraints of the form:

```math
    x_{k+1} = A x_k + c, \\; x_k ∈ \\mathcal{X} \\; \\forall k.
```

### Fields

- `A` -- state matrix
- `c` -- affine term
- `X` -- state constraints
"""
ConstrainedAffineDiscreteSystem

for (Z, AZ) in ((:ConstrainedAffineControlContinuousSystem, :AbstractContinuousSystem),
                (:ConstrainedAffineControlDiscreteSystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z){T, MTA <: AbstractMatrix{T}, MTB <: AbstractMatrix{T}, VT <: AbstractVector{T}, ST, UT} <: $(AZ)
            A::MTA
            B::MTB
            c::VT
            X::ST
            U::UT
            function $(Z)(A::MTA, B::MTB, c::VT, X::ST, U::UT) where {T, MTA <: AbstractMatrix{T}, MTB <: AbstractMatrix{T}, VT <: AbstractVector{T}, ST, UT}
                @assert checksquare(A) == length(c) == size(B, 1)
                return new{T, MTA, MTB, VT, ST, UT}(A, B, c, X, U)
            end
        end
        function $(Z)(A::Number, B::Number, c::Number, X, U)
             return $(Z)(hcat(A), hcat(B), vcat(c), X, U)
        end

        statedim(s::$Z) = length(s.c)
        inputdim(s::$Z) = size(s.B, 2)
        noisedim(::$Z) = 0
        stateset(s::$Z) = s.X
        inputset(s::$Z) = s.U
        state_matrix(s::$Z) = s.A
        input_matrix(s::$Z) = s.B
        affine_term(s::$Z) = s.c
    end
    for T in [Z, Type{<:eval(Z)}]
        @eval begin
            islinear(::$T) = false
            isaffine(::$T) = true
            ispolynomial(::$T) = false
            isnoisy(::$T) = false
            iscontrolled(::$T) = true
            isconstrained(::$T) = true
        end
    end
end

@doc """
    ConstrainedAffineControlContinuousSystem

Continuous-time affine control system with domain constraints of the form:

```math
    x(t)' = A x(t) + B u(t) + c, \\; x(t) ∈ \\mathcal{X}, \\; u(t) ∈ \\mathcal{U} \\; \\forall t.
```

### Fields

- `A` -- state matrix
- `B` -- input matrix
- `c` -- affine term
- `X` -- state constraints
- `U` -- input constraints
"""
ConstrainedAffineControlContinuousSystem

@doc """
    ConstrainedAffineControlDiscreteSystem

Continuous-time affine control system with domain constraints of the form:

```math
    x_{k+1} = A x_k + B u_k + c, \\; x_k ∈ \\mathcal{X}, \\; u_k ∈ \\mathcal{U} \\; \\forall k.
```

### Fields

- `A` -- state matrix
- `B` -- input matrix
- `c` -- affine term
- `X` -- state constraints
- `U` -- input constraints
"""
ConstrainedAffineControlDiscreteSystem

for (Z, AZ) in ((:ConstrainedLinearControlContinuousSystem, :AbstractContinuousSystem),
                (:ConstrainedLinearControlDiscreteSystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z){T, MTA <: AbstractMatrix{T}, MTB <: AbstractMatrix{T}, ST, UT} <: $(AZ)
            A::MTA
            B::MTB
            X::ST
            U::UT
            function $(Z)(A::MTA, B::MTB, X::ST, U::UT) where {T, MTA <: AbstractMatrix{T}, MTB <: AbstractMatrix{T}, ST, UT}
                @assert checksquare(A) == size(B, 1)
                return new{T, MTA, MTB, ST, UT}(A, B, X, U)
            end
        end
        function $(Z)(A::Number, B::Number, X, U)
             return $(Z)(hcat(A), hcat(B), X, U)
        end

        statedim(s::$Z) = size(s.A, 1)
        inputdim(s::$Z) = size(s.B, 2)
        noisedim(::$Z) = 0
        stateset(s::$Z) = s.X
        inputset(s::$Z) = s.U
        state_matrix(s::$Z) = s.A
        input_matrix(s::$Z) = s.B
    end
    for T in [Z, Type{<:eval(Z)}]
        @eval begin
            islinear(::$T) = true
            isaffine(::$T) = true
            ispolynomial(::$T) = false
            isnoisy(::$T) = false
            iscontrolled(::$T) = true
            isconstrained(::$T) = true
        end
    end
end

@doc """
    ConstrainedLinearControlContinuousSystem

Continuous-time linear control system with domain constraints of the form:
```math
    x(t)' = A x(t) + B u(t), \\; x(t) ∈ \\mathcal{X}, \\; u(t) ∈ \\mathcal{U} \\; \\forall t.
```

### Fields

- `A` -- state matrix
- `B` -- input matrix
- `X` -- state constraints
- `U` -- input constraints
"""
ConstrainedLinearControlContinuousSystem

@doc """
    ConstrainedLinearControlDiscreteSystem

Discrete-time linear control system with domain constraints of the form:

```math
    x_{k+1} = A x_k + B u_k, \\; x_k ∈ \\mathcal{X}, \\; u_k ∈ \\mathcal{U} \\; \\forall k.
```

### Fields

- `A` -- state matrix
- `B` -- input matrix
- `X` -- state constraints
- `U` -- input constraints
"""
ConstrainedLinearControlDiscreteSystem

for (Z, AZ) in ((:LinearAlgebraicContinuousSystem, :AbstractContinuousSystem),
                (:LinearAlgebraicDiscreteSystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z){T, MTA <: AbstractMatrix{T}, MTE <: AbstractMatrix{T}} <: $(AZ)
            A::MTA
            E::MTE
            function $(Z)(A::MTA, E::MTE) where {T, MTA <: AbstractMatrix{T}, MTE <: AbstractMatrix{T}}
                @assert size(A) == size(E)
                return new{T, MTA, MTE}(A, E)
            end
        end
        function $(Z)(A::Number, E::Number)
             return $(Z)(hcat(A), hcat(E))
        end


        statedim(s::$Z) = size(s.A, 1)
        inputdim(::$Z) = 0
        noisedim(::$Z) = 0
        state_matrix(s::$Z) = s.A
    end
    for T in [Z, Type{<:eval(Z)}]
        @eval begin
            islinear(::$T) = true
            isaffine(::$T) = true
            ispolynomial(::$T) = false
            isnoisy(::$T) = false
            iscontrolled(::$T) = false
            isconstrained(::$T) = false
        end
    end
end

@doc """
    LinearAlgebraicContinuousSystem

Continuous-time linear algebraic system of the form:

```math
    E x(t)' = A x(t) \\; \\forall t.
```

### Fields

- `A` -- state matrix
- `E` -- matrix, same size as `A`
"""
LinearAlgebraicContinuousSystem

@doc """
    LinearAlgebraicDiscreteSystem

Discrete-time linear algebraic system of the form:

```math
    E x_{k+1} = A x_k \\; \\forall k.
```

### Fields

- `A` -- state matrix
- `E` -- matrix, same size as `A`
"""
LinearAlgebraicDiscreteSystem

for (Z, AZ) in ((:ConstrainedLinearAlgebraicContinuousSystem, :AbstractContinuousSystem),
                (:ConstrainedLinearAlgebraicDiscreteSystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z){T, MTA <: AbstractMatrix{T}, MTE <: AbstractMatrix{T}, ST} <: $(AZ)
            A::MTA
            E::MTE
            X::ST
            function $(Z)(A::MTA, E::MTE, X::ST) where {T, MTA <: AbstractMatrix{T}, MTE <: AbstractMatrix{T}, ST}
                @assert size(A) == size(E)
                return new{T, MTA, MTE, ST}(A, E, X)
            end
        end
        function $(Z)(A::Number, E::Number, X)
             return $(Z)(hcat(A), hcat(E), X)
        end

        statedim(s::$Z) = size(s.A, 1)
        inputdim(::$Z) = 0
        noisedim(::$Z) = 0
        stateset(s::$Z) = s.X
        state_matrix(s::$Z) = s.A
    end
    for T in [Z, Type{<:eval(Z)}]
        @eval begin
            islinear(::$T) = true
            isaffine(::$T) = true
            ispolynomial(::$T) = false
            isnoisy(::$T) = false
            iscontrolled(::$T) = false
            isconstrained(::$T) = true
        end
    end
end

@doc """
    ConstrainedLinearAlgebraicContinuousSystem

Continuous-time linear system with domain constraints of the form:

```math
    E x(t)' = A x(t), \\; x(t) ∈ \\mathcal{X} \\; \\forall t.
```

### Fields

- `A` -- state matrix
- `E` -- matrix, same size as `A`
- `X` -- state constraints
"""
ConstrainedLinearAlgebraicContinuousSystem

@doc """
    ConstrainedLinearAlgebraicDiscreteSystem

Discrete-time linear system with domain constraints of the form:

```math
    E x_{k+1} = A x_k, \\; x_k ∈ \\mathcal{X} \\; \\forall k.
```

### Fields

- `A` -- state matrix
- `E` -- matrix, same size as `A`
- `X` -- state constraints
"""
ConstrainedLinearAlgebraicDiscreteSystem

for (Z, AZ) in ((:PolynomialContinuousSystem, :AbstractContinuousSystem),
                (:PolynomialDiscreteSystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z){T, PT <: AbstractPolynomialLike{T}, VPT <: AbstractVector{PT}} <: $(AZ)
            p::VPT
            statedim::Int
            function $(Z)(p::VPT, statedim::Int) where {T, PT <: AbstractPolynomialLike{T}, VPT <: AbstractVector{PT}}
                @assert statedim == MultivariatePolynomials.nvariables(p) "the state dimension $(statedim) does not match the number of state variables"
                return new{T, PT, VPT}(p, statedim)
            end
        end
        statedim(s::$Z) = s.statedim
        inputdim(::$Z) = 0
        noisedim(::$Z) = 0

        MultivariatePolynomials.variables(s::$Z) = MultivariatePolynomials.variables(s.p)
        MultivariatePolynomials.nvariables(s::$Z) = s.statedim

        $(Z)(p::AbstractVector{<:AbstractPolynomialLike}) = $(Z)(p, MultivariatePolynomials.nvariables(p))
        $(Z)(p::AbstractPolynomialLike) = $(Z)([p])
    end
    for T in [Z, Type{<:eval(Z)}]
        @eval begin
            islinear(::$T) = false
            isaffine(::$T) = false
            ispolynomial(::$T) = true
            isnoisy(::$T) = false
            iscontrolled(::$T) = false
            isconstrained(::$T) = false
        end
    end
end

@doc """
    PolynomialContinuousSystem

Continuous-time polynomial system of the form:

```math
    x(t)' = p(x(t)) \\; \\forall t.
```

### Fields

- `p`        -- polynomial vector field
- `statedim` -- number of state variables
"""
PolynomialContinuousSystem

@doc """
    PolynomialDiscreteSystem

Discrete-time polynomial system of the form:

```math
    x_{k+1} = p(x_k) \\; \\forall k.
```

### Fields

- `p`        -- polynomial vector field
- `statedim` -- number of state variables
"""
PolynomialDiscreteSystem

for (Z, AZ) in ((:ConstrainedPolynomialContinuousSystem, :AbstractContinuousSystem),
                (:ConstrainedPolynomialDiscreteSystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z){T, PT <: AbstractPolynomialLike{T}, VPT <: AbstractVector{PT}, ST} <: $(AZ)
            p::VPT
            statedim::Int
            X::ST
            function $(Z)(p::VPT, statedim::Int, X::ST) where {T, PT <: AbstractPolynomialLike{T}, VPT <: AbstractVector{PT}, ST}
                @assert statedim == MultivariatePolynomials.nvariables(p) "the state dimension $(statedim) does not match the number of state variables"
                return new{T, PT, VPT, ST}(p, statedim, X)
            end
        end
        statedim(s::$Z) = s.statedim
        inputdim(::$Z) = 0
        noisedim(::$Z) = 0
        stateset(s::$Z) = s.X

        MultivariatePolynomials.variables(s::$Z) = MultivariatePolynomials.variables(s.p)
        MultivariatePolynomials.nvariables(s::$Z) = s.statedim

        $Z(p::AbstractVector{<:AbstractPolynomialLike}, X::ST) where {ST} = $(Z)(p, MultivariatePolynomials.nvariables(p), X)
        $Z(p::AbstractPolynomialLike, X::ST) where {ST} = $(Z)([p], X)
    end
    for T in [Z, Type{<:eval(Z)}]
        @eval begin
            islinear(::$T) = false
            isaffine(::$T) = false
            ispolynomial(::$T) = true
            isnoisy(::$T) = false
            iscontrolled(::$T) = false
            isconstrained(::$T) = true
        end
    end
end

@doc """
    ConstrainedPolynomialContinuousSystem

Continuous-time polynomial system with domain constraints:

```math
    x(t)' = p(x(t)), \\; x(t) ∈ \\mathcal{X} \\; \\forall t.
```

### Fields

- `p`        -- polynomial vector field
- `X`        -- constraint set
- `statedim` -- number of state variables
"""
ConstrainedPolynomialContinuousSystem

@doc """
    ConstrainedPolynomialDiscreteSystem

Discrete-time polynomial system with domain constraints:

```math
    x_{k+1} = p(x_k), \\;  x_k ∈ \\mathcal{X} \\; \\forall k.
```

### Fields

- `p`        -- polynomial
- `X`        -- constraint set
- `statedim` -- number of state variables
"""
ConstrainedPolynomialDiscreteSystem

for (Z, AZ) in ((:BlackBoxContinuousSystem, :AbstractContinuousSystem),
                (:BlackBoxDiscreteSystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z){FT} <: $(AZ)
            f::FT
            statedim::Int
        end
        statedim(s::$Z) = s.statedim
        inputdim(s::$Z) = 0
        noisedim(::$Z) = 0
    end
    for T in [Z, Type{<:eval(Z)}]
        @eval begin
            islinear(::$T) = false
            isaffine(::$T) = false
            ispolynomial(::$T) = false
            isnoisy(::$T) = false
            iscontrolled(::$T) = false
            isconstrained(::$T) = false
        end
    end
end

@doc """
    BlackBoxContinuousSystem <: AbstractContinuousSystem

Continuous-time system defined by a right-hand side of the form:

```math
    x(t)' = f(x(t)) \\; \\forall t.
```

### Fields

- `f`        -- function that holds the right-hand side
- `statedim` -- number of state variables
"""
BlackBoxContinuousSystem

@doc """
    BlackBoxDiscreteSystem <: AbstractDiscreteSystem

Discrete-time system defined by a right-hand side of the form:

```math
    x_{k+1} = f(x_k) \\; \\forall k.
```

### Fields

- `f`        -- function that holds the right-hand side
- `statedim` -- number of state variables
"""
BlackBoxDiscreteSystem

for (Z, AZ) in ((:ConstrainedBlackBoxContinuousSystem, :AbstractContinuousSystem),
                (:ConstrainedBlackBoxDiscreteSystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z){FT, ST} <: $(AZ)
            f::FT
            statedim::Int
            X::ST
        end
        statedim(s::$Z) = s.statedim
        inputdim(s::$Z) = 0
        noisedim(::$Z) = 0
        stateset(s::$Z) = s.X
    end
    for T in [Z, Type{<:eval(Z)}]
        @eval begin
            islinear(::$T) = false
            isaffine(::$T) = false
            ispolynomial(::$T) = false
            isnoisy(::$T) = false
            iscontrolled(::$T) = false
            isconstrained(::$T) = true
        end
    end
end

@doc """
    ConstrainedBlackBoxContinuousSystem <: AbstractContinuousSystem

Continuous-time system defined by a right-hand side with domain constraints of the
form:

```math
    x(t)' = f(x(t)), \\; x(t) ∈ \\mathcal{X} \\; \\forall t.
```

### Fields

- `f`        -- function that holds the right-hand side
- `statedim` -- number of state variables
- `X`        -- state constraints
"""
ConstrainedBlackBoxContinuousSystem

@doc """
    ConstrainedBlackBoxDiscreteSystem <: AbstractDiscreteSystem

Discrete-time system defined by a right-hand side with domain constraints
of the form:

```math
    x_{k+1} = f(x_k), \\; x_k ∈ \\mathcal{X} \\; \\forall k.
```

### Fields

- `f`        -- function that holds the right-hand side
- `statedim` -- number of state variables
- `X`        -- state constraints
"""
ConstrainedBlackBoxDiscreteSystem

for (Z, AZ) in ((:BlackBoxControlContinuousSystem, :AbstractContinuousSystem),
                (:BlackBoxControlDiscreteSystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z){FT} <: $(AZ)
            f::FT
            statedim::Int
            inputdim::Int
        end
        statedim(s::$Z) = s.statedim
        inputdim(s::$Z) = s.inputdim
        noisedim(::$Z) = 0
    end
    for T in [Z, Type{<:eval(Z)}]
        @eval begin
            islinear(::$T) = false
            isaffine(::$T) = false
            ispolynomial(::$T) = false
            isnoisy(::$T) = false
            iscontrolled(::$T) = true
            isconstrained(::$T) = false
        end
    end
end

@doc """
    BlackBoxControlContinuousSystem <: AbstractContinuousSystem

Continuous-time control system defined by a right-hand side of the form:

```math
    x(t)' = f(x(t), u(t)) \\; \\forall t.
```

### Fields

- `f`        -- function that holds the right-hand side
- `statedim` -- number of state variables
- `inputdim` -- number of input variables
"""
BlackBoxControlContinuousSystem

@doc """
    BlackBoxControlDiscreteSystem <: AbstractDiscreteSystem

Discrete-time control system defined by a right-hand side of the form:

```math
    x_{k+1} = f(x_k, u_k) \\; \\forall k.
```

### Fields

- `f`        -- function that holds the right-hand side
- `statedim` -- number of state variables
- `inputdim` -- number of input variables
"""
BlackBoxControlDiscreteSystem

for (Z, AZ) in ((:ConstrainedBlackBoxControlContinuousSystem, :AbstractContinuousSystem),
                (:ConstrainedBlackBoxControlDiscreteSystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z){FT, ST, UT} <: $(AZ)
            f::FT
            statedim::Int
            inputdim::Int
            X::ST
            U::UT
        end
        statedim(s::$Z) = s.statedim
        inputdim(s::$Z) = s.inputdim
        noisedim(::$Z) = 0
        stateset(s::$Z) = s.X
        inputset(s::$Z) = s.U
    end
    for T in [Z, Type{<:eval(Z)}]
        @eval begin
            islinear(::$T) = false
            isaffine(::$T) = false
            ispolynomial(::$T) = false
            isnoisy(::$T) = false
            iscontrolled(::$T) = true
            isconstrained(::$T) = true
        end
    end
end

@doc """
    ConstrainedBlackBoxControlContinuousSystem <: AbstractContinuousSystem

Continuous-time control system defined by a right-hand side with domain constraints
of the form:

```math
    x(t)' = f(x(t), u(t)), \\; x(t) ∈ \\mathcal{X}, \\; u(t) ∈ \\mathcal{U} \\; \\forall t.
```

### Fields

- `f`        -- function that holds the right-hand side
- `statedim` -- number of state variables
- `inputdim` -- number of input variables
- `X`        -- state constraints
- `U`        -- input constraints
"""
ConstrainedBlackBoxControlContinuousSystem

@doc """
    ConstrainedBlackBoxControlDiscreteSystem <: AbstractDiscreteSystem

Discrete-time control system defined by a right-hand side with domain constraints
of the form:

```math
    x_{k+1} = f(x_k, u_k), \\; x_k ∈ \\mathcal{X}, \\;  u_k ∈ \\mathcal{U} \\; \\forall k.
```

### Fields

- `f`        -- function that holds the right-hand side
- `statedim` -- number of state variables
- `inputdim` -- number of input variables
- `X`        -- state constraints
- `U`        -- input constraints
"""
ConstrainedBlackBoxControlDiscreteSystem

# ==============
# Noisy systems
# ==============

for (Z, AZ) in ((:NoisyLinearContinuousSystem, :AbstractContinuousSystem),
                (:NoisyLinearDiscreteSystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z){T, MTA <: AbstractMatrix{T}, MTD <: AbstractMatrix{T}} <: $(AZ)
            A::MTA
            D::MTD
            function $(Z)(A::MTA, D::MTD) where {T, MTA <: AbstractMatrix{T}, MTD <: AbstractMatrix{T}}
                @assert checksquare(A) == size(D,1)
                return new{T, MTA, MTD}(A, D)
            end
        end
        function $(Z)(A::Number, D::Number)
           return $(Z)(hcat(A), hcat(D))
        end

        statedim(s::$Z) = size(s.A,1)
        inputdim(::$Z) = 0
        noisedim(s::$Z) = size(s.D, 2)
        state_matrix(s::$Z) = s.A
        noise_matrix(s::$Z) = s.D
    end
    for T in [Z, Type{<:eval(Z)}]
        @eval begin
            islinear(::$T) = true
            isaffine(::$T) = true
            ispolynomial(::$T) = false
            isnoisy(::$T) = true
            iscontrolled(::$T) = false
            isconstrained(::$T) = false
        end
    end
end

@doc """
    NoisyLinearContinuousSystem

Continuous-time linear system with additive disturbance of the form:

```math
    x(t)' = A x(t) + D w(t) \\; \\forall t.
```

### Fields

- `A` -- state matrix
- `D` -- noise matrix
"""
NoisyLinearContinuousSystem

@doc """
    NoisyLinearDiscreteSystem

Discrete-time linear system with additive disturbance of the form:

```math
    x_{k+1} = A x_k + D w_k \\; \\forall k.
```

### Fields

- `A` -- state matrix
- `D` -- noise matrix
"""
NoisyLinearDiscreteSystem

for (Z, AZ) in ((:NoisyConstrainedLinearContinuousSystem, :AbstractContinuousSystem),
                (:NoisyConstrainedLinearDiscreteSystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z){T, MTA <: AbstractMatrix{T}, MTD <: AbstractMatrix{T}, ST, WT} <: $(AZ)
            A::MTA
            D::MTD
            X::ST
            W::WT
            function $(Z)(A::MTA, D::MTD, X::ST, W::WT) where {T, MTA <: AbstractMatrix{T}, MTD <: AbstractMatrix{T}, ST, WT}
                @assert checksquare(A) == size(D,1)
                return new{T, MTA, MTD, ST, WT}(A, D, X, W)
            end
        end
        function $(Z)(A::Number, D::Number, X, W)
           return $(Z)(hcat(A), hcat(D), X, W)
        end

        statedim(s::$Z) = size(s.A,1)
        inputdim(::$Z) = 0
        noisedim(s::$Z) = size(s.D, 2)
        stateset(s::$Z) = s.X
        noiseset(s::$Z) = s.W
        state_matrix(s::$Z) = s.A
        noise_matrix(s::$Z) = s.D
    end
    for T in [Z, Type{<:eval(Z)}]
        @eval begin
            islinear(::$T) = true
            isaffine(::$T) = true
            ispolynomial(::$T) = false
            isnoisy(::$T) = true
            iscontrolled(::$T) = false
            isconstrained(::$T) = true
        end
    end
end

@doc """
    NoisyConstrainedLinearContinuousSystem

Continuous-time linear system with  additive disturbance and domain constraints of the form:

```math
    x(t)' = A x(t) + D w(t), \\; x(t) ∈ \\mathcal{X}, \\; w(t) ∈ \\mathcal{W} \\; \\forall t.
```

### Fields

- `A` -- state matrix
- `D` -- noise matrix
- `X` -- state constraints
- `W` -- disturbance set
"""
NoisyConstrainedLinearContinuousSystem

@doc """
    NoisyConstrainedLinearDiscreteSystem

Discrete-time linear system with additive disturbance and domain constraints of the form:

```math
    x_{k+1} = A x_k + D w_k, \\; x_k ∈ \\mathcal{X}, \\; w(t) ∈ \\mathcal{W} \\; \\forall k.
```

### Fields

- `A` -- state matrix
- `D` -- noise matrix
- `X` -- state constraints
- `W` -- disturbance set
"""
NoisyConstrainedLinearDiscreteSystem

for (Z, AZ) in ((:NoisyLinearControlContinuousSystem, :AbstractContinuousSystem),
                (:NoisyLinearControlDiscreteSystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z){T, MTA <: AbstractMatrix{T}, MTB <: AbstractMatrix{T}, MTD <: AbstractMatrix{T}} <: $(AZ)
            A::MTA
            B::MTB
            D::MTD
            function $(Z)(A::MTA, B::MTB, D::MTD) where {T, MTA <: AbstractMatrix{T}, MTB <: AbstractMatrix{T}, MTD <: AbstractMatrix{T}}
                @assert checksquare(A) == size(B, 1) == size(D,1)
                return new{T, MTA, MTB, MTD}(A, B, D)
            end
        end
        function $(Z)(A::Number, B::Number, D::Number)
           return $(Z)(hcat(A), hcat(B), hcat(D))
        end

        statedim(s::$Z) = size(s.A, 1)
        inputdim(s::$Z) = size(s.B, 2)
        noisedim(s::$Z) = size(s.D, 2)
        state_matrix(s::$Z) = s.A
        input_matrix(s::$Z) = s.B
        noise_matrix(s::$Z) = s.D
    end
    for T in [Z, Type{<:eval(Z)}]
        @eval begin
            islinear(::$T) = true
            isaffine(::$T) = true
            ispolynomial(::$T) = false
            isnoisy(::$T) = true
            iscontrolled(::$T) = true
            isconstrained(::$T) = false
        end
    end
end

@doc """
    NoisyLinearControlContinuousSystem

Continuous-time linear control system with additive disturbance of the form:

```math
    x(t)' = A x(t) + B u(t) + D w(t) \\; \\forall t.
```


### Fields

- `A` -- state matrix
- `B` -- input matrix
- `D` -- noise matrix
"""
NoisyLinearControlContinuousSystem

@doc """
    NoisyLinearControlDiscreteSystem

Continuous-time linear control system with additive disturbance of the form:

```math
    x_{k+1} = A x_k + B u_k + D w_k \\; \\forall k.
```


### Fields

- `A` -- state matrix
- `B` -- input matrix
- `D` -- noise matrix
"""
NoisyLinearControlDiscreteSystem

for (Z, AZ) in ((:NoisyConstrainedLinearControlContinuousSystem, :AbstractContinuousSystem),
                (:NoisyConstrainedLinearControlDiscreteSystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z){T, MTA <: AbstractMatrix{T}, MTB <: AbstractMatrix{T}, MTD <: AbstractMatrix{T}, ST, UT, WT} <: $(AZ)
            A::MTA
            B::MTB
            D::MTD
            X::ST
            U::UT
            W::WT
            function $(Z)(A::MTA, B::MTB, D::MTD, X::ST, U::UT, W::WT) where {T, MTA <: AbstractMatrix{T}, MTB <: AbstractMatrix{T}, MTD <: AbstractMatrix{T}, ST, UT, WT}
                @assert checksquare(A) == size(B, 1) == size(D,1)
                return new{T, MTA, MTB, MTD, ST, UT, WT}(A, B, D, X, U, W)
            end
        end
        function $(Z)(A::Number, B::Number, D::Number, X, U, W)
           return $(Z)(hcat(A), hcat(B), hcat(D), X, U, W)
        end

        statedim(s::$Z) = size(s.A, 1)
        inputdim(s::$Z) = size(s.B, 2)
        noisedim(s::$Z) = size(s.D, 2)
        stateset(s::$Z) = s.X
        inputset(s::$Z) = s.U
        noiseset(s::$Z) = s.W
        state_matrix(s::$Z) = s.A
        input_matrix(s::$Z) = s.B
        noise_matrix(s::$Z) = s.D
    end
    for T in [Z, Type{<:eval(Z)}]
        @eval begin
            islinear(::$T) = true
            isaffine(::$T) = true
            ispolynomial(::$T) = false
            isnoisy(::$T) = true
            iscontrolled(::$T) = true
            isconstrained(::$T) = true
        end
    end
end

@doc """
    NoisyConstrainedLinearControlContinuousSystem

Continuous-time linear control system with additive disturbance and domain constraints
of the form:

```math
    x(t)' = A x(t) + B u(t) + D w(t), \\; x(t) ∈ \\mathcal{X}, \\; u(t) ∈ \\mathcal{U}, \\; w(t) ∈ \\mathcal{W} \\; \\forall t.
```


### Fields

- `A` -- state matrix
- `B` -- input matrix
- `D` -- noise matrix
- `X` -- state constraints
- `U` -- input constraints
- `W` -- disturbance set
"""
NoisyConstrainedLinearControlContinuousSystem

@doc """
    NoisyConstrainedLinearControlDiscreteSystem

Continuous-time linear control system with additive disturbance and domain constraints
of the form:

```math
    x_{k+1} = A x_k + B u_k + D w_k, \\; x_k ∈ \\mathcal{X}, \\; u_k ∈ \\mathcal{U}, \\; w_k ∈ \\mathcal{W} \\; \\forall k.
```


### Fields

- `A` -- state matrix
- `B` -- input matrix
- `D` -- noise matrix
- `X` -- state constraints
- `U` -- input constraints
- `W` -- disturbance set
"""
NoisyConstrainedLinearControlDiscreteSystem

for (Z, AZ) in ((:NoisyAffineControlContinuousSystem, :AbstractContinuousSystem),
                (:NoisyAffineControlDiscreteSystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z){T, MTA <: AbstractMatrix{T}, MTB <: AbstractMatrix{T}, VT <: AbstractVector{T}, MTD <: AbstractMatrix{T}} <: $(AZ)
            A::MTA
            B::MTB
            c::VT
            D::MTD
            function $(Z)(A::MTA, B::MTB, c::VT, D::MTD) where {T, MTA <: AbstractMatrix{T}, MTB <: AbstractMatrix{T}, VT <: AbstractVector{T}, MTD <: AbstractMatrix{T}}
                @assert checksquare(A) == length(c) == size(B, 1) == size(D,1)
                return new{T, MTA, MTB, VT, MTD}(A, B, c, D)
            end
        end
        function $(Z)(A::Number, B::Number, c::Number, D::Number)
           return $(Z)(hcat(A), hcat(B), vcat(c), hcat(D))
        end

        statedim(s::$Z) = length(s.c)
        inputdim(s::$Z) = size(s.B, 2)
        noisedim(s::$Z) = size(s.D, 2)
        state_matrix(s::$Z) = s.A
        input_matrix(s::$Z) = s.B
        noise_matrix(s::$Z) = s.D
        affine_term(s::$Z) = s.c
    end
    for T in [Z, Type{<:eval(Z)}]
        @eval begin
            islinear(::$T) = false
            isaffine(::$T) = true
            ispolynomial(::$T) = false
            isnoisy(::$T) = true
            iscontrolled(::$T) = true
            isconstrained(::$T) = false
        end
    end
end

@doc """
    NoisyAffineControlContinuousSystem

Continuous-time affine control system with additive disturbance of the form:

```math
    x(t)' = A x(t) + B u(t) + c + D w(t) \\; \\forall t.
```

### Fields

- `A` -- state matrix
- `B` -- input matrix
- `c` -- affine term
- `D` -- noise matrix
"""
NoisyAffineControlContinuousSystem

@doc """
    NoisyAffineControlDiscreteSystem

Continuous-time affine control system with additive disturbance of the form:

```math
    x_{k+1} = A x_k + B u_k + c + D w_k \\; \\forall k.
```

### Fields

- `A` -- state matrix
- `B` -- input matrix
- `c` -- affine term
- `D` -- noise matrix
"""
NoisyAffineControlDiscreteSystem

for (Z, AZ) in ((:NoisyConstrainedAffineControlContinuousSystem, :AbstractContinuousSystem),
                (:NoisyConstrainedAffineControlDiscreteSystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z){T, MTA <: AbstractMatrix{T}, MTB <: AbstractMatrix{T}, VT <: AbstractVector{T}, MTD <: AbstractMatrix{T}, ST, UT, WT} <: $(AZ)
            A::MTA
            B::MTB
            c::VT
            D::MTD
            X::ST
            U::UT
            W::WT
            function $(Z)(A::MTA, B::MTB, c::VT, D::MTD, X::ST, U::UT, W::WT) where {T, MTA <: AbstractMatrix{T}, MTB <: AbstractMatrix{T}, VT <: AbstractVector{T}, MTD <: AbstractMatrix{T}, ST, UT, WT}
                @assert checksquare(A) == length(c) == size(B, 1) == size(D,1)
                return new{T, MTA, MTB, VT, MTD, ST, UT, WT}(A, B, c, D, X, U, W)
            end
        end
        function $(Z)(A::Number, B::Number, c::Number, D::Number, X, U, W)
           return $(Z)(hcat(A), hcat(B), vcat(c), hcat(D), X, U, W)
        end

        statedim(s::$Z) = length(s.c)
        inputdim(s::$Z) = size(s.B, 2)
        noisedim(s::$Z) = size(s.D, 2)
        stateset(s::$Z) = s.X
        inputset(s::$Z) = s.U
        noiseset(s::$Z) = s.W
        state_matrix(s::$Z) = s.A
        input_matrix(s::$Z) = s.B
        noise_matrix(s::$Z) = s.D
        affine_term(s::$Z) = s.c
    end
    for T in [Z, Type{<:eval(Z)}]
        @eval begin
            islinear(::$T) = false
            isaffine(::$T) = true
            ispolynomial(::$T) = false
            isnoisy(::$T) = true
            iscontrolled(::$T) = true
            isconstrained(::$T) = true
        end
    end
end

@doc """
    NoisyConstrainedAffineControlContinuousSystem

Continuous-time affine control system with additive disturbance and domain constraints
of the form:

```math
    x(t)' = A x(t) + B u(t) + c + D w(t), \\; x(t) ∈ \\mathcal{X}, \\; u(t) ∈ \\mathcal{U}, \\; w(t) ∈ \\mathcal{W} \\; \\forall t.
```

### Fields

- `A` -- state matrix
- `B` -- input matrix
- `c` -- affine term
- `D` -- noise matrix
- `X` -- state constraints
- `U` -- input constraints
- `W` -- disturbance set
"""
NoisyConstrainedAffineControlContinuousSystem

@doc """
    NoisyConstrainedAffineControlDiscreteSystem

Continuous-time affine control system with additive disturbance and domain constraints
of the form:

```math
    x_{k+1} = A x_k + B u_k + c + D w_k, \\; x_k ∈ \\mathcal{X}, \\; u_k ∈ \\mathcal{U}, \\; w_k ∈ \\mathcal{W} \\; \\forall k.
```

### Fields

- `A` -- state matrix
- `B` -- input matrix
- `c` -- affine term
- `D` -- noise matrix
- `X` -- state constraints
- `U` -- input constraints
- `W` -- disturbance set
"""
NoisyConstrainedAffineControlDiscreteSystem


for (Z, AZ) in ((:NoisyBlackBoxControlContinuousSystem, :AbstractContinuousSystem),
                (:NoisyBlackBoxControlDiscreteSystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z){FT} <: $(AZ)
            f::FT
            statedim::Int
            inputdim::Int
            noisedim::Int
        end
        statedim(s::$Z) = s.statedim
        inputdim(s::$Z) = s.inputdim
        noisedim(s::$Z) = s.noisedim
    end
    for T in [Z, Type{<:eval(Z)}]
        @eval begin
            islinear(::$T) = false
            isaffine(::$T) = false
            ispolynomial(::$T) = false
            isnoisy(::$T) = true
            iscontrolled(::$T) = true
            isconstrained(::$T) = false
        end
    end
end

@doc """
    NoisyBlackBoxControlContinuousSystem <: AbstractContinuousSystem

Continuous-time disturbance-affected control system defined by a right-hand side
of the form:

```math
    x(t)' = f(x(t), u(t), w(t)) \\; \\forall t.
```

### Fields

- `f`        -- function that holds the right-hand side
- `statedim` -- number of state variables
- `inputdim` -- number of input variables
- `noisedim` -- number of noise variables
"""
NoisyBlackBoxControlContinuousSystem

@doc """
    NoisyBlackBoxControlDiscreteSystem <: AbstractDiscreteSystem

Discrete-time disturbance-affected control system defined by a right-hand side
of the form:

```math
    x_{k+1} = f(x_k, u_k) \\quad \\forall k.
```

### Fields

- `f`        -- function that holds the right-hand side
- `statedim` -- number of state variables
- `inputdim` -- number of input variables
- `noisedim` -- number of noise variables
"""
NoisyBlackBoxControlDiscreteSystem


for (Z, AZ) in ((:NoisyConstrainedBlackBoxControlContinuousSystem, :AbstractContinuousSystem),
                (:NoisyConstrainedBlackBoxControlDiscreteSystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z){FT, ST, UT,WT} <: $(AZ)
            f::FT
            statedim::Int
            inputdim::Int
            noisedim::Int
            X::ST
            U::UT
            W::WT
        end
        statedim(s::$Z) = s.statedim
        inputdim(s::$Z) = s.inputdim
        noisedim(s::$Z) = s.noisedim
        stateset(s::$Z) = s.X
        inputset(s::$Z) = s.U
        noiseset(s::$Z) = s.W
    end
    for T in [Z, Type{<:eval(Z)}]
        @eval begin
            islinear(::$T) = false
            isaffine(::$T) = false
            ispolynomial(::$T) = false
            isnoisy(::$T) = true
            iscontrolled(::$T) = true
            isconstrained(::$T) = true
        end
    end
end

@doc """
    NoisyConstrainedBlackBoxControlContinuousSystem <: AbstractContinuousSystem

Continuous-time disturbance-affected control system defined by a right-hand side
with domain constraints of the form:

```math
    x(t)' = f(x(t), u(t), w(t)), \\quad x(t) ∈ \\mathcal{X}, \\quad u(t) ∈ \\mathcal{U}, \\quad w(t) ∈ \\mathcal{W} \\quad \\forall t.
```

### Fields

- `f`        -- function that holds the right-hand side
- `statedim` -- number of state variables
- `inputdim` -- number of input variables
- `noisedim` -- number of noise variables
- `X`        -- state constraints
- `U`        -- input constraints
- `W`        -- disturbance set
"""
NoisyConstrainedBlackBoxControlContinuousSystem

@doc """
    NoisyConstrainedBlackBoxControlDiscreteSystem <: AbstractDiscreteSystem

Discrete-time disturbance-affected control system defined by a right-hand side
with domain constraints of the form:

```math
    x_{k+1} = f(x_k, u_k), \\quad x_k ∈ \\mathcal{X}, \\quad u_k ∈ \\mathcal{U}, \\quad w_k ∈ \\mathcal{W} \\quad \\forall k.
```

### Fields

- `f`        -- function that holds the right-hand side
- `statedim` -- number of state variables
- `inputdim` -- number of input variables
- `noisedim` -- number of noise variables
- `X`        -- state constraints
- `U`        -- input constraints
- `W`        -- disturbance set
"""
NoisyConstrainedBlackBoxControlDiscreteSystem

@doc """
    SecondOrderLinearContinuousSystem

Continuous-time second order linear system of the form:

```math
    Mx''(t) + Cx'(t) + Kx(t) = 0\\; \\forall t.
```

### Fields

- `M` -- mass matrix
- `C` -- viscosity matrix
- `K` -- stiffness matrix
"""
SecondOrderLinearContinuousSystem

@doc """
    SecondOrderLinearDiscreteSystem

Discrete-time second order linear system of the form:

```math
    Mx_{k+2} + Cx_{k+1} + Kx_k = 0\\; \\forall k.
```

### Fields

- `M` -- mass matrix
- `C` -- viscosity matrix
- `K` -- stiffness matrix
"""
SecondOrderLinearDiscreteSystem

for (Z, AZ) in ((:SecondOrderLinearContinuousSystem, :AbstractContinuousSystem),
                (:SecondOrderLinearDiscreteSystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z){T, MTM <: AbstractMatrix{T},
                       MTC <: AbstractMatrix{T},
                       MTK <: AbstractMatrix{T}} <: $(AZ)
            M::MTM
            C::MTC
            K::MTK
            function $(Z)(M::MTM, C::MTC, K::MTK) where {T, MTM <: AbstractMatrix{T},
                                                            MTC <: AbstractMatrix{T},
                                                            MTK <: AbstractMatrix{T}}
                @assert checksquare(M) == checksquare(C) == checksquare(K)
                return new{T, MTM, MTC, MTK}(M, C, K)
            end
        end
        function $(Z)(M::Number, C::Number, K::Number)
             return $(Z)(hcat(M), hcat(C), hcat(K))
        end

        statedim(s::$Z) = size(s.C, 1)
        inputdim(::$Z) = 0
        noisedim(::$Z) = 0
        mass_matrix(s::$Z) = s.M
        viscosity_matrix(s::$Z) = s.C
        stiffness_matrix(s::$Z) = s.K
        affine_term(s::$Z) = zeros(eltype(s.C), size(s.C, 1))
    end
    for T in [Z, Type{<:eval(Z)}]
        @eval begin
            islinear(::$T) = true
            isaffine(::$T) = true
            ispolynomial(::$T) = false
            isnoisy(::$T) = false
            iscontrolled(::$T) = false
            isconstrained(::$T) = false
        end
    end
end

@doc """
    SecondOrderAffineContinuousSystem

Continuous-time second order affine system of the form:

```math
    Mx''(t) + Cx'(t) + Kx(t) = b\\; \\forall t.
```

### Fields

- `M` -- mass matrix
- `C` -- viscosity matrix
- `K` -- stiffness matrix
- `b` -- affine term
"""
SecondOrderAffineContinuousSystem

@doc """
    SecondOrderAffineDiscreteSystem

Discrete-time second order affine system of the form:

```math
    Mx_{k+2} + Cx_{k+1} + Kx_k = b\\; \\forall k.
```

### Fields

- `M` -- mass matrix
- `C` -- viscosity matrix
- `K` -- stiffness matrix
- `b` -- affine term
"""
SecondOrderAffineDiscreteSystem

for (Z, AZ) in ((:SecondOrderAffineContinuousSystem, :AbstractContinuousSystem),
                (:SecondOrderAffineDiscreteSystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z){T, MTM <: AbstractMatrix{T},
                       MTC <: AbstractMatrix{T},
                       MTK <: AbstractMatrix{T},
                       VT <: AbstractVector{T}} <: $(AZ)
            M::MTM
            C::MTC
            K::MTK
            b::VT
            function $(Z)(M::MTM, C::MTC, K::MTK, b::VT) where {T, MTM <: AbstractMatrix{T},
                                                                   MTC <: AbstractMatrix{T},
                                                                   MTK <: AbstractMatrix{T},
                                                                   VT <: AbstractVector{T}}
                @assert checksquare(M) == checksquare(C) == checksquare(K) == length(b)
                return new{T, MTM, MTC, MTK, VT}(M, C, K, b)
            end
        end
        function $(Z)(M::Number, C::Number, K::Number, b::Number)
             return $(Z)(hcat(M), hcat(C), hcat(K), [b])
        end

        statedim(s::$Z) = size(s.C, 1)
        inputdim(::$Z) = 0
        noisedim(::$Z) = 0
        mass_matrix(s::$Z) = s.M
        viscosity_matrix(s::$Z) = s.C
        stiffness_matrix(s::$Z) = s.K
        affine_term(s::$Z) = s.b
    end
    for T in [Z, Type{<:eval(Z)}]
        @eval begin
            islinear(::$T) = true
            isaffine(::$T) = true
            ispolynomial(::$T) = false
            isnoisy(::$T) = false
            iscontrolled(::$T) = false
            isconstrained(::$T) = false
        end
    end
end

@doc """
    SecondOrderConstrainedLinearControlContinuousSystem

Continuous-time second order constrained linear control system of the form:

```math
    Mx''(t) + Cx'(t) + Kx(t) = Bu(t), \\; x(t) ∈ \\mathcal{X}, \\; u(t) ∈ \\mathcal{U} \\; \\forall t.
```

### Fields

- `M` -- mass matrix
- `C` -- viscosity matrix
- `K` -- stiffness matrix
- `B` -- input matrix
- `X` -- state constraints
- `U` -- input constraints
"""
SecondOrderConstrainedLinearControlContinuousSystem

@doc """
    SecondOrderConstrainedLinearControlDiscreteSystem

Discrete-time second order constrained linear control system of the form:

```math
    Mx_{k+2} + Cx_{k+1} + Kx_k = Bu_k, \\; x_k ∈ \\mathcal{X}, \\; u_k ∈ \\mathcal{U} \\; \\forall k.
```

### Fields

- `M` -- mass matrix
- `C` -- viscosity matrix
- `K` -- stiffness matrix
- `B` -- input matrix
- `X` -- state constraints
- `U` -- input constraints
"""
SecondOrderConstrainedLinearControlDiscreteSystem

for (Z, AZ) in ((:SecondOrderConstrainedLinearControlContinuousSystem, :AbstractContinuousSystem),
                (:SecondOrderConstrainedLinearControlDiscreteSystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z){T, MTM <: AbstractMatrix{T},
                       MTC <: AbstractMatrix{T},
                       MTK <: AbstractMatrix{T},
                       MTB <: AbstractMatrix{T},
                       ST,
                       UT} <: $(AZ)
            M::MTM
            C::MTC
            K::MTK
            B::MTB
            X::ST
            U::UT
            function $(Z)(M::MTM, C::MTC, K::MTK, B::MTB, X::ST, U::UT) where {T, MTM <: AbstractMatrix{T},
                                                                                  MTC <: AbstractMatrix{T},
                                                                                  MTK <: AbstractMatrix{T},
                                                                                  MTB <: AbstractMatrix{T},
                                                                                  ST,
                                                                                  UT}
                @assert checksquare(M) == checksquare(C) == checksquare(K) == size(B, 1)
                return new{T, MTM, MTC, MTK, MTB, ST, UT}(M, C, K, B, X, U)
            end
        end
        function $(Z)(M::Number, C::Number, K::Number, B::Number, X, U)
             return $(Z)(hcat(M), hcat(C), hcat(K), hcat(B), X, U)
        end

        statedim(s::$Z) = size(s.C, 1)
        inputdim(::$Z) = size(s.B, 2)
        noisedim(::$Z) = 0
        mass_matrix(s::$Z) = s.M
        viscosity_matrix(s::$Z) = s.C
        stiffness_matrix(s::$Z) = s.K
        affine_term(s::$Z) = zeros(eltype(s.C), size(s.C, 1))
        input_matrix(s::$Z) = s.B
        stateset(s::$Z) = s.X
        inputset(s::$Z) = s.U
    end
    for T in [Z, Type{<:eval(Z)}]
        @eval begin
            islinear(::$T) = true
            isaffine(::$T) = true
            ispolynomial(::$T) = false
            isnoisy(::$T) = false
            iscontrolled(::$T) = true
            isconstrained(::$T) = true
        end
    end
end

@doc """
    SecondOrderConstrainedAffineControlContinuousSystem

Continuous-time second order constrained affine control system of the form:

```math
    Mx''(t) + Cx'(t) + Kx(t) = Bu(t) + d, \\; x(t) ∈ \\mathcal{X}, \\; u(t) ∈ \\mathcal{U} \\; \\forall t.
```

### Fields

- `M` -- mass matrix
- `C` -- viscosity matrix
- `K` -- stiffness matrix
- `B` -- input matrix
- `d` -- affine term
- `X` -- state constraints
- `U` -- input constraints
"""
SecondOrderConstrainedAffineControlContinuousSystem

@doc """
    SecondOrderConstrainedAffineControlDiscreteSystem

Discrete-time second order constrained affine control system of the form:

```math
    Mx_{k+2} + Cx_{k+1} + Kx_k = Bu_k + d, \\; x_k ∈ \\mathcal{X}, \\; u_k ∈ \\mathcal{U} \\; \\forall k.
```

### Fields

- `M` -- mass matrix
- `C` -- viscosity matrix
- `K` -- stiffness matrix
- `B` -- input matrix
- `d` -- affine term
- `X` -- state constraints
- `U` -- input constraints
"""
SecondOrderConstrainedAffineControlDiscreteSystem

for (Z, AZ) in ((:SecondOrderConstrainedAffineControlContinuousSystem, :AbstractContinuousSystem),
                (:SecondOrderConstrainedAffineControlDiscreteSystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z){T, MTM <: AbstractMatrix{T},
                       MTC <: AbstractMatrix{T},
                       MTK <: AbstractMatrix{T},
                       MTB <: AbstractMatrix{T},
                       VT <: AbstractVector{T},
                       ST,
                       UT} <: $(AZ)
            M::MTM
            C::MTC
            K::MTK
            B::MTB
            d::VT
            X::ST
            U::UT
            function $(Z)(M::MTM, C::MTC, K::MTK, B::MTB, d::VT, X::ST, U::UT) where {T, MTM <: AbstractMatrix{T},
                                                                                  MTC <: AbstractMatrix{T},
                                                                                  MTK <: AbstractMatrix{T},
                                                                                  MTB <: AbstractMatrix{T},
                                                                                  VT <: AbstractVector{T},
                                                                                  ST,
                                                                                  UT}
                @assert checksquare(M) == checksquare(C) == checksquare(K) == size(B, 1) == length(d)
                return new{T, MTM, MTC, MTK, MTB, VT, ST, UT}(M, C, K, B, d, X, U)
            end
        end
        function $(Z)(M::Number, C::Number, K::Number, B::Number, d::Number, X, U)
             return $(Z)(hcat(M), hcat(C), hcat(K), hcat(B), [d], X, U)
        end

        statedim(s::$Z) = size(s.C, 1)
        inputdim(::$Z) = size(s.B, 2)
        noisedim(::$Z) = 0
        mass_matrix(s::$Z) = s.M
        viscosity_matrix(s::$Z) = s.C
        stiffness_matrix(s::$Z) = s.K
        affine_term(s::$Z) = s.d
        input_matrix(s::$Z) = s.B
        stateset(s::$Z) = s.X
        inputset(s::$Z) = s.U
    end
    for T in [Z, Type{<:eval(Z)}]
        @eval begin
            islinear(::$T) = true
            isaffine(::$T) = true
            ispolynomial(::$T) = false
            isnoisy(::$T) = false
            iscontrolled(::$T) = true
            isconstrained(::$T) = true
        end
    end
end
