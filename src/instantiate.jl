# helper functions to check that the given system can be applied to the states/inputs
@inline _is_conformable_state(system, x) = statedim(system) == length(x)
@inline _is_conformable_input(system, u) = inputdim(system) == length(u)
@inline _is_conformable_noise(system, w) = noisedim(system) == length(w)
@inline _in_stateset(system, x) = x ∈ stateset(system)
@inline _in_inputset(system, u) = u ∈ inputset(system)
@inline _in_noiseset(system, w) = w ∈ noiseset(system)

@inline function _argument_error(sym, set=:none)
    if sym == :x
        vector = "state"
    elseif sym == :u
        vector = "input"
    elseif sym == :w
        vector = "noise"
    end
    if set == :none
        throw(ArgumentError("the $vector vector has the wrong dimensions"))
    else
        throw(ArgumentError("the $vector vector is not contained in the $(vector) set"))
    end
end

# ====================
# Generic _instantiate method
# ====================

"""
    _instantiate(system::AbstractSystem, x::AbstractVector;
                [check_constraints]=true)

Return the result of instantiating an `AbstractSystem` at the current state.

### Input

- `system`            -- `AbstractSystem`
- `x`                 -- state (it should be any vector type)
- `check_constraints` -- (optional, default: `true`) check if the state belongs to
                         the state set

### Output

The result of applying the system to state `x`.

### Notes

The `_instantiate` method generalizes the `successor` of an `AbstractDiscreteSystem`
and the `vector_field` of an `AbstractContinuousSystem` into a single method.
"""
function _instantiate(system::AbstractSystem, x::AbstractVector;
                     check_constraints::Bool=true)
    !_is_conformable_state(system, x) && _argument_error(:x)
    if isconstrained(system) && check_constraints
        !_in_stateset(system, x) && _argument_error(:x,:X)
    end

    if islinear(system)
        return state_matrix(system) * x

    elseif isaffine(system)
        return state_matrix(system) * x + affine_term(system)

    elseif ispolynomial(system) || isblackbox(system)
        return mapping(system)(x)

    else
        throw(ArgumentError("_instantiate not defined for type `$(typename(sys))`"))
    end
end

"""
    _instantiate(system::AbstractSystem, x::AbstractVector, u::AbstractVector;
                [check_constraints]=true)

Return the result of instantiating an `AbstractSystem` at the current state and
applying one input.

### Input

- `system`            -- `AbstractSystem`
- `x`                 -- state (it should be any vector type)
- `u`                 -- input (it should be any vector type) or noise, if `system`
                         is not controlled
- `check_constraints` -- (optional, default: `true`) check if the state belongs to
                         the state set

### Output

The result of applying the system to state `x` and input `u`.

### Notes

If the system is not controlled but noisy, the input `u` is interpreted as noise.

The `_instantiate` method generalizes the `successor` of an `AbstractDiscreteSystem`
and the `vector_field` of an `AbstractContinuousSystem` into a single method.
"""
function _instantiate(system::AbstractSystem, x::AbstractVector, u::AbstractVector;
                     check_constraints::Bool=true)
    # Figure out if `system` is a controlled or noisy system and set the function
    # `matrix` to either `input_matix` or `noise_matrix`
    if iscontrolled(system) && !isnoisy(system)
        input_var = :u; input_set = :U; matrix = input_matrix
        _is_conformable = _is_conformable_input
        _in_set = _in_inputset
    elseif isnoisy(system) && !iscontrolled(system)
        input_var = :w; input_set = :W; matrix = noise_matrix
        _is_conformable = _is_conformable_noise
        _in_set = _in_noiseset
    else
        throw(ArgumentError("successor function for $(typeof(system)) does not have 2 arguments"))
    end

    !_is_conformable_state(system, x) && _argument_error(:x)
    !_is_conformable(system, u) && _argument_error(input_var)

    if isconstrained(system) && check_constraints
        !_in_stateset(system, x) && _argument_error(:x,:X)
        !_in_set(system, u) && _argument_error(input_var, input_set)
    end

    if islinear(system)
        return state_matrix(system) * x + matrix(system) * u

    elseif isaffine(system)
        return state_matrix(system) * x + affine_term(system) + matrix(system) * u

    elseif ispolynomial(system) || isblackbox(system)
        return mapping(system)(x, u)

    else
        throw(ArgumentError("_instantiate not defined for type `$(typename(system))`"))
    end
end

"""
    _instantiate(system::AbstractSystem,
                x::AbstractVector, u::AbstractVector, w::AbstractVector; [check_constraints]=true)

Return the result of instantiating an `AbstractSystem` at the current state and
applying two inputs to an `AbstractSystem`.

### Input

- `system`            -- `AbstractSystem`
- `x`                 -- state (it should be any vector type)
- `u`                 -- input (it should be any vector type)
- `w`                 -- noise (it should be any vector type)
- `check_constraints` -- (optional, default: `true`) check if the state belongs to
                         the state set

### Output

The result of applying the system to state `x`, input `u` and noise `w`.

### Notes

The `_instantiate` method generalizes the `successor` of an `AbstractDiscreteSystem`
and the `vector_field` of an `AbstractContinuousSystem` into a single method.
"""
function _instantiate(system::AbstractSystem, x::AbstractVector, u::AbstractVector, w::AbstractVector;
                     check_constraints::Bool=true)
    !_is_conformable_state(system, x) && _argument_error(:x)
    !_is_conformable_input(system, u) && _argument_error(:u)
    !_is_conformable_noise(system, w) && _argument_error(:w)

    if isconstrained(system) && check_constraints
        !_in_stateset(system, x) && _argument_error(:x,:X)
        !_in_inputset(system, u) && _argument_error(:u,:U)
        !_in_noiseset(system, w) && _argument_error(:w,:W)
    end

    if islinear(system)
        return state_matrix(system) * x + input_matrix(system) * u + noise_matrix(system) * w

    elseif isaffine(system)
        return state_matrix(system) * x + affine_term(system) + input_matrix(system) * u + noise_matrix(system) * w

    elseif ispolynomial(system) || isblackbox(system)
        return mapping(system)(x, u, w)

    else
        throw(ArgumentError("_instantiate not defined for type `$(typename(system))`"))

    end
end
