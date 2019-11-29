import MultivariatePolynomials
import MultivariatePolynomials: AbstractPolynomialLike

for (Z, AZ) in ((:ContinuousIdentitySystem, :AbstractContinuousSystem),
                (:DiscreteIdentitySystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z) <: $(AZ)
            statedim::Int
        end
        statedim(s::$Z) = s.statedim
        inputdim(s::$Z) = 0
        islinear(::$Z) = true
        isaffine(::$Z) = true
        ispolynomial(::$Z) = false
    end
end

@doc """
    ContinuousIdentitySystem <: AbstractContinuousSystem

Trivial identity continuous-time system of the form:

```math
    x' = 0.
```

### Fields

- `statedim` -- number of state variables
"""
ContinuousIdentitySystem

@doc """
    DiscreteIdentitySystem <: AbstractDiscreteSystem

Trivial identity discrete-time system of the form:
```math
    x_{k+1} = x_k.
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
        stateset(s::$Z) = s.X
        inputdim(::$Z) = 0
        islinear(::$Z) = true
        isaffine(::$Z) = true
        ispolynomial(::$Z) = false
    end
end

@doc """
    ConstrainedContinuousIdentitySystem <: AbstractContinuousSystem

Trivial identity continuous-time system with state constraints of the form:

```math
    x' = 0, x(t) ∈ \\mathcal{X}.
```

### Fields

- `statedim` -- number of state variables
- `X`        -- state constraints
"""
ConstrainedContinuousIdentitySystem

@doc """
    ConstrainedDiscreteIdentitySystem <: AbstractDiscreteSystem

Trivial identity discrete-time system with state constraints of the form:

```math
    x_{k+1} = x_k, x_k ∈ \\mathcal{X}.
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
        end
        statedim(s::$Z) = checksquare(s.A)
        inputdim(::$Z) = 0
        islinear(::$Z) = true
        isaffine(::$Z) = true
        ispolynomial(::$Z) = false
    end
end

@doc """
    LinearContinuousSystem

Continuous-time linear system of the form:

```math
    x' = A x.
```

### Fields

- `A` -- square matrix
"""
LinearContinuousSystem

@doc """
    LinearDiscreteSystem

Discrete-time linear system of the form:

```math
    x_{k+1} = A x_k.
```

### Fields

- `A` -- square matrix
"""
LinearDiscreteSystem

for (Z, AZ) in ((:AffineContinuousSystem, :AbstractContinuousSystem),
                (:AffineDiscreteSystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z){T, MT <: AbstractMatrix{T}, VT <: AbstractVector{T}} <: $(AZ)
            A::MT
            b::VT
            function $(Z)(A::MT, b::VT) where {T, MT <: AbstractMatrix{T}, VT <: AbstractVector{T}}
                @assert checksquare(A) == length(b)
                return new{T, MT, VT}(A, b)
            end
        end
        statedim(s::$Z) = length(s.b)
        inputdim(::$Z) = 0
        islinear(::$Z) = false
        isaffine(::$Z) = true
        ispolynomial(::$Z) = false
    end
end

@doc """
    AffineContinuousSystem

Continuous-time affine system of the form:

```math
    x' = A x + b.
```

### Fields

- `A` -- square matrix
- `b` -- vector
"""
AffineContinuousSystem

@doc """
    AffineDiscreteSystem

Discrete-time affine system of the form:

```math
    x_{k+1} = A x_k + b.
```

### Fields

- `A` -- square matrix
- `b` -- vector
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
        statedim(s::$Z) = checksquare(s.A)
        inputdim(s::$Z) = size(s.B, 2)
        islinear(::$Z) = true
        isaffine(::$Z) = true
        ispolynomial(::$Z) = false
    end
end

@doc """
    LinearControlContinuousSystem

Continuous-time linear control system of the form:

```math
    x' = A x + B u.
```

### Fields

- `A` -- square matrix
- `B` -- matrix
"""
LinearControlContinuousSystem

@doc """
    LinearControlDiscreteSystem

Discrete-time linear control system of the form:

```math
    x_{k+1} = A x_k + B u_k.
```

### Fields

- `A` -- square matrix
- `B` -- matrix
"""
LinearControlDiscreteSystem

for (Z, AZ) in ((:ConstrainedLinearContinuousSystem, :AbstractContinuousSystem),
                (:ConstrainedLinearDiscreteSystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z){T, MT <: AbstractMatrix{T}, ST} <: $(AZ)
            A::MT
            X::ST
        end
        statedim(s::$Z) = checksquare(s.A)
        stateset(s::$Z) = s.X
        inputdim(::$Z) = 0
        islinear(::$Z) = true
        isaffine(::$Z) = true
        ispolynomial(::$Z) = false
    end
end

@doc """
    ConstrainedLinearContinuousSystem

Continuous-time linear system with state constraints of the form:

```math
    x' = A x, x(t) ∈ \\mathcal{X}.
```

### Fields

- `A` -- square matrix
- `X` -- state constraints
"""
ConstrainedLinearContinuousSystem

@doc """
    ConstrainedLinearDiscreteSystem

Discrete-time linear system with state constraints of the form:

```math
    x_{k+1} = A x_k, x_k ∈ \\mathcal{X}.
```

### Fields

- `A` -- square matrix
- `X` -- state constraints
"""
ConstrainedLinearDiscreteSystem

for (Z, AZ) in ((:ConstrainedAffineContinuousSystem, :AbstractContinuousSystem),
                (:ConstrainedAffineDiscreteSystem, :AbstractDiscreteSystem))
    @eval begin
        struct $(Z){T, MT <: AbstractMatrix{T}, VT <: AbstractVector{T}, ST} <: $(AZ)
            A::MT
            b::VT
            X::ST
            function $(Z)(A::MT, b::VT, X::ST) where {T, MT <: AbstractMatrix{T}, VT <: AbstractVector{T}, ST}
                @assert checksquare(A) == length(b)
                return new{T, MT, VT, ST}(A, b, X)
            end
        end
        statedim(s::$Z) = length(s.b)
        stateset(s::$Z) = s.X
        inputdim(::$Z) = 0
        islinear(::$Z) = false
        isaffine(::$Z) = true
        ispolynomial(::$Z) = false
    end
end

@doc """
    ConstrainedAffineContinuousSystem

Continuous-time affine system with state constraints of the form:

```math
    x' = A x + b, x(t) ∈ \\mathcal{X}.
```

### Fields

- `A` -- square matrix
- `b` -- vector
- `X` -- state constraints
"""
ConstrainedAffineContinuousSystem

@doc """
    ConstrainedAffineDiscreteSystem

Discrete-time affine system with state constraints of the form:

```math
    x_{k+1} = A x_k + b, x_k ∈ \\mathcal{X} \\text{ for all } k.
```

### Fields

- `A` -- square matrix
- `b` -- vector
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
        statedim(s::$Z) = length(s.c)
        stateset(s::$Z) = s.X
        inputdim(s::$Z) = size(s.B, 2)
        inputset(s::$Z) = s.U
        islinear(::$Z) = false
        isaffine(::$Z) = true
        ispolynomial(::$Z) = false
    end
end

@doc """
    ConstrainedAffineControlContinuousSystem

Continuous-time affine control system with state constraints of the form:

```math
    x' = A x + B u + c, x(t) ∈ \\mathcal{X}, u(t) ∈ \\mathcal{U} \\text{ for all } t,
```
and ``c`` a vector.

### Fields

- `A` -- square matrix
- `B` -- matrix
- `c` -- vector
- `X` -- state constraints
- `U` -- input constraints
"""
ConstrainedAffineControlContinuousSystem

@doc """
    ConstrainedAffineControlDiscreteSystem

Continuous-time affine control system with state constraints of the form:

```math
    x_{k+1} = A x_k + B u_k + c, x_k ∈ \\mathcal{X}, u_k ∈ \\mathcal{U} \\text{ for all } k,
```
and ``c`` a vector.

### Fields

- `A` -- square matrix
- `B` -- matrix
- `c` -- vector
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
        statedim(s::$Z) = checksquare(s.A)
        stateset(s::$Z) = s.X
        inputdim(s::$Z) = size(s.B, 2)
        inputset(s::$Z) = s.U
        islinear(::$Z) = true
        isaffine(::$Z) = true
        ispolynomial(::$Z) = false
    end
end

@doc """
    ConstrainedLinearControlContinuousSystem

Continuous-time linear control system with state constraints of the form:
```math
    x' = A x + B u, x(t) ∈ \\mathcal{X}, u(t) ∈ \\mathcal{U} \\text{ for all } t.
```

### Fields

- `A` -- square matrix
- `B` -- matrix
- `X` -- state constraints
- `U` -- input constraints
"""
ConstrainedLinearControlContinuousSystem

@doc """
    ConstrainedLinearControlDiscreteSystem

Discrete-time linear control system with state constraints of the form:

```math
    x_{k+1} = A x_k + B u_k, x_k ∈ \\mathcal{X}, u_k ∈ \\mathcal{U} \\text{ for all } k.
```

### Fields

- `A` -- square matrix
- `B` -- matrix
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
        statedim(s::$Z) = size(s.A, 1)
        inputdim(::$Z) = 0
        islinear(::$Z) = true
        isaffine(::$Z) = true
        ispolynomial(::$Z) = false
    end
end

@doc """
    LinearAlgebraicContinuousSystem

Continuous-time linear algebraic system of the form:

```math
    E x' = A x.
```

### Fields

- `A` -- matrix
- `E` -- matrix, same size as `A`
"""
LinearAlgebraicContinuousSystem

@doc """
    LinearAlgebraicDiscreteSystem

Discrete-time linear algebraic system of the form:

```math
    E x_{k+1} = A x_k.
```

### Fields

- `A` -- matrix
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
        statedim(s::$Z) = size(s.A, 1)
        stateset(s::$Z) = s.X
        inputdim(::$Z) = 0
        islinear(::$Z) = true
        isaffine(::$Z) = true
        ispolynomial(::$Z) = false
    end
end

@doc """
    ConstrainedLinearAlgebraicContinuousSystem

Continuous-time linear system with state constraints of the form:

```math
    E x' = A x, x(t) ∈ \\mathcal{X}.
```

### Fields

- `A` -- matrix
- `E` -- matrix, same size as `A`
- `X` -- state constraints
"""
ConstrainedLinearAlgebraicContinuousSystem

@doc """
    ConstrainedLinearAlgebraicDiscreteSystem

Discrete-time linear system with state constraints of the form:

```math
    E x_{k+1} = A x_k, x_k ∈ \\mathcal{X}.
```

### Fields

- `A` -- matrix
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
        islinear(::$Z) = false
        isaffine(::$Z) = false
        ispolynomial(::$Z) = true

        MultivariatePolynomials.variables(s::$Z) = MultivariatePolynomials.variables(s.p)
        MultivariatePolynomials.nvariables(s::$Z) = s.statedim

        $(Z)(p::AbstractVector{<:AbstractPolynomialLike}) = $(Z)(p, MultivariatePolynomials.nvariables(p))
        $(Z)(p::AbstractPolynomialLike) = $(Z)([p])
    end
end

@doc """
    PolynomialContinuousSystem

Continuous-time polynomial system of the form:

```math
    x' = p(x).
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
    x_{k+1} = p(x_k), x_k ∈ \\mathcal{X}.
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
        stateset(s::$Z) = s.X
        inputdim(::$Z) = 0
        islinear(::$Z) = false
        isaffine(::$Z) = false
        ispolynomial(::$Z) = true

        MultivariatePolynomials.variables(s::$Z) = MultivariatePolynomials.variables(s.p)
        MultivariatePolynomials.nvariables(s::$Z) = s.statedim

        $Z(p::AbstractVector{<:AbstractPolynomialLike}, X::ST) where {ST} = $(Z)(p, MultivariatePolynomials.nvariables(p), X)
        $Z(p::AbstractPolynomialLike, X::ST) where {ST} = $(Z)([p], X)
    end
end

@doc """
    ConstrainedPolynomialContinuousSystem

Continuous-time polynomial system with state constraints:

```math
    x' = p(x), x(t) ∈ \\mathcal{X}
```

### Fields

- `p`        -- polynomial vector field
- `X`        -- constraint set
- `statedim` -- number of state variables
"""
ConstrainedPolynomialContinuousSystem

@doc """
    ConstrainedPolynomialDiscreteSystem

Discrete-time polynomial system with state constraints:

```math
    x_{k+1} = p(x_k), x_k ∈ \\mathcal{X}.
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
        islinear(::$Z) = false
        isaffine(::$Z) = false
    end
end

@doc """
    BlackBoxContinuousSystem <: AbstractContinuousSystem

Continuous-time system defined by a right-hand side of the form:

```math
    x' = f(x(t))
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
    x_{k+1} = f(x_k)
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
        stateset(s::$Z) = s.X
        inputdim(s::$Z) = 0
        islinear(::$Z) = false
        isaffine(::$Z) = false
    end
end

@doc """
    ConstrainedBlackBoxContinuousSystem <: AbstractContinuousSystem

Continuous-time system defined by a right-hand side with state constraints of the
form:

```math
    x' = f(x(t)), x(t) ∈ \\mathcal{X}.
```

### Fields

- `f`        -- function that holds the right-hand side
- `statedim` -- number of state variables
- `X`        -- state constraints
"""
ConstrainedBlackBoxContinuousSystem

@doc """
    ConstrainedBlackBoxDiscreteSystem <: AbstractDiscreteSystem

Discrete-time system defined by a right-hand side with state constraints
of the form:

```math
    x_{k+1} = f(x_k), x_k ∈ \\mathcal{X}.
```

### Fields

- `f`        -- function that holds the right-hand side
- `statedim` -- number of state variables
- `X`        -- state constraints
"""
ConstrainedBlackBoxDiscreteSystem

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
        stateset(s::$Z) = s.X
        inputdim(s::$Z) = s.inputdim
        inputset(s::$Z) = s.U
        islinear(::$Z) = false
        isaffine(::$Z) = false
    end
end

@doc """
    ConstrainedBlackBoxControlContinuousSystem <: AbstractContinuousSystem

Continuous-time control system defined by a right-hand side with state and input constraints
of the form:

```math
    x' = f(x(t), u(t)), x(t) ∈ \\mathcal{X}, u(t) ∈ \\mathcal{U}.
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

Discrete-time control system defined by a right-hand side with state and input constraints
of the form:

```math
    x_{k+1} = f(x_k, u_k), x_k ∈ \\mathcal{X}, u_k ∈ \\mathcal{U}.
```

### Fields

- `f`        -- function that holds the right-hand side
- `statedim` -- number of state variables
- `inputdim` -- number of input variables
- `X`        -- state constraints
- `U`        -- input constraints
"""
ConstrainedBlackBoxControlDiscreteSystem

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
        statedim(s::$Z) = size(s.A,1)
        stateset(s::$Z) = s.X
        noisedim(s::$Z) = size(s.D, 2)
        noiseset(s::$Z) = s.W
        inputdim(::$Z) = 0
        islinear(::$Z) = true
        isaffine(::$Z) = true
        isnoisy(::$Z) = true
    end
end

@doc """
    NoisyConstrainedLinearContinuousSystem

Continuous-time linear system with  additive disturbance and  state constraints of the form:

```math
    x' = A x + D w, x(t) ∈ \\mathcal{X}, w(t) ∈ \\mathcal{W}.
```

### Fields

- `A` -- square matrix
- `D` -- matrix
- `X` -- state constraints
- `W` -- disturbance set
"""
NoisyConstrainedLinearContinuousSystem

@doc """
    NoisyConstrainedLinearDiscreteSystem

Discrete-time linear system with additive disturbance and state constraints of the form:

```math
    x_{k+1} = A x_k + D w_k, x_k ∈ \\mathcal{X}, w(t) ∈ \\mathcal{W} .
```

### Fields

- `A` -- square matrix
- `D` -- matrix
- `X` -- state constraints
- `W` -- disturbance set
"""
NoisyConstrainedLinearDiscreteSystem

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
        statedim(s::$Z) = size(s.A, 1)
        stateset(s::$Z) = s.X
        inputdim(s::$Z) = size(s.B, 2)
        inputset(s::$Z) = s.U
        noisedim(s::$Z) = size(s.D, 2)
        noiseset(s::$Z) = s.W
        islinear(::$Z) = true
        isaffine(::$Z) = true
        isnoisy(::$Z) = true
    end
end

@doc """
    NoisyConstrainedLinearControlContinuousSystem
Continuous-time affine control system with state constraints of the form:
```math
    x' = A x + B u + Dw, x(t) ∈ \\mathcal{X}, u(t) ∈ \\mathcal{U}, w(t) ∈ \\mathcal{W} \\text{ for all } t,
```
and ``c`` a vector.
### Fields
- `A` -- square matrix
- `B` -- matrix
- `D` -- matrix
- `X` -- state constraints
- `U` -- input constraints
- `W` -- disturbance set
"""
NoisyConstrainedLinearControlContinuousSystem

@doc """
    NoisyConstrainedLinearControlDiscreteSystem
Continuous-time affine control system with state constraints of the form:
```math
    x_{k+1} = A x_k + B u_k + D w_k, x_k ∈ \\mathcal{X}, u_k ∈ \\mathcal{U}, w_k ∈ \\mathcal{W} \\text{ for all } k,
```
and ``c`` a vector.
### Fields
- `A` -- square matrix
- `B` -- matrix
- `D` -- matrix
- `X` -- state constraints
- `U` -- input constraints
- `W` -- disturbance set
"""
NoisyConstrainedLinearControlDiscreteSystem

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
        statedim(s::$Z) = length(s.c)
        stateset(s::$Z) = s.X
        inputdim(s::$Z) = size(s.B, 2)
        inputset(s::$Z) = s.U
        noisedim(s::$Z) = size(s.D, 2)
        noiseset(s::$Z) = s.W
        islinear(::$Z) = false
        isaffine(::$Z) = true
        isnoisy(::$Z) = true
    end
end

@doc """
    NoisyConstrainedAffineControlContinuousSystem
Continuous-time affine control system with state constraints of the form:
```math
    x' = A x + B u + c + Dw, x(t) ∈ \\mathcal{X}, u(t) ∈ \\mathcal{U}, w(t) ∈ \\mathcal{W} \\text{ for all } t,
```
and ``c`` a vector.
### Fields
- `A` -- square matrix
- `B` -- matrix
- `c` -- vector
- `D` -- matrix
- `X` -- state constraints
- `U` -- input constraints
- `W` -- disturbance set
"""
NoisyConstrainedAffineControlContinuousSystem

@doc """
    NoisyConstrainedAffineControlDiscreteSystem
Continuous-time affine control system with state constraints of the form:
```math
    x_{k+1} = A x_k + B u_k + c + D w_k, x_k ∈ \\mathcal{X}, u_k ∈ \\mathcal{U}, w_k ∈ \\mathcal{W} \\text{ for all } k,
```
and ``c`` a vector.
### Fields
- `A` -- square matrix
- `B` -- matrix
- `c` -- vector
- `D` -- matrix
- `X` -- state constraints
- `U` -- input constraints
- `W` -- disturbance set
"""
NoisyConstrainedAffineControlDiscreteSystem


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
        stateset(s::$Z) = s.X
        inputdim(s::$Z) = s.inputdim
        inputset(s::$Z) = s.U
        noisedim(s::$Z) = s.noisedim
        noiseset(s::$Z) = s.W
        islinear(::$Z) = false
        isaffine(::$Z) = false
        isnoisy(::$Z) = true
    end
end

@doc """
    NoisyConstrainedBlackBoxControlContinuousSystem <: AbstractContinuousSystem

Continuous-time control system defined by a right-hand side with state constraints
of the form:

```math
    x' = f(x(t), u(t), w(t)), x(t) ∈ \\mathcal{X}, u(t) ∈ \\mathcal{U}, w(t) ∈ \\mathcal{W}.
```

### Fields

- `f`        -- function that holds the right-hand side
- `statedim` -- number of state variables
- `inputdim` -- number of input variables
- `X`        -- state constraints
- `U`        -- input constraints
- `W`        -- disturbance set
"""
NoisyConstrainedBlackBoxControlContinuousSystem

@doc """
    NoisyConstrainedBlackBoxControlDiscreteSystem <: AbstractDiscreteSystem

Discrete-time control system defined by a right-hand side with state constraints
of the form:

```math
    x_{k+1} = f(x_k, u_k), x_k ∈ \\mathcal{X}, u_k ∈ \\mathcal{U},  w_k ∈ \\mathcal{W}.
```

### Fields

- `f`        -- function that holds the right-hand side
- `statedim` -- number of state variables
- `inputdim` -- number of input variables
- `X`        -- state constraints
- `U`        -- input constraints
- `W`        -- disturbance set
"""
NoisyConstrainedBlackBoxControlDiscreteSystem
