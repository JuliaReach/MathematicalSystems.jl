var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Home",
    "title": "Home",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#MathematicalSystems.jl-1",
    "page": "Home",
    "title": "MathematicalSystems.jl",
    "category": "section",
    "text": "DocTestFilters = [r\"[0-9\\.]+ seconds \\(.*\\)\"]MathematicalSystems is a Julia package for mathematical systems interfaces."
},

{
    "location": "index.html#Features-1",
    "page": "Home",
    "title": "Features",
    "category": "section",
    "text": "Generic and flexible systems definitions, while being fast and type stable.\nTypes for mathematical systems modeling: continuous, discrete, controlled,linear algebraic, etc.Iterator interfaces to handle constant or time-varying inputs."
},

{
    "location": "index.html#Library-Outline-1",
    "page": "Home",
    "title": "Library Outline",
    "category": "section",
    "text": "Pages = [\n    \"lib/types.md\",\n    \"lib/methods.md\"\n]\nDepth = 2"
},

{
    "location": "lib/types.html#",
    "page": "Types",
    "title": "Types",
    "category": "page",
    "text": ""
},

{
    "location": "lib/types.html#Types-1",
    "page": "Types",
    "title": "Types",
    "category": "section",
    "text": "This section describes systems types implemented in MathematicalSystems.jl.Pages = [\"types.md\"]\nDepth = 3CurrentModule = MathematicalSystems\nDocTestSetup = quote\n    using MathematicalSystems\nend"
},

{
    "location": "lib/types.html#MathematicalSystems.AbstractSystem",
    "page": "Types",
    "title": "MathematicalSystems.AbstractSystem",
    "category": "type",
    "text": "AbstractSystem\n\nAbstract supertype for all system types.\n\n\n\n"
},

{
    "location": "lib/types.html#MathematicalSystems.AbstractContinuousSystem",
    "page": "Types",
    "title": "MathematicalSystems.AbstractContinuousSystem",
    "category": "type",
    "text": "AbstractContinuousSystem\n\nAbstract supertype for all continuous system types.\n\n\n\n"
},

{
    "location": "lib/types.html#MathematicalSystems.AbstractDiscreteSystem",
    "page": "Types",
    "title": "MathematicalSystems.AbstractDiscreteSystem",
    "category": "type",
    "text": "AbstractDiscreteSystem\n\nAbstract supertype for all discrete system types.\n\n\n\n"
},

{
    "location": "lib/types.html#Abstract-Systems-1",
    "page": "Types",
    "title": "Abstract Systems",
    "category": "section",
    "text": "AbstractSystem\nAbstractContinuousSystem\nAbstractDiscreteSystem"
},

{
    "location": "lib/types.html#MathematicalSystems.ContinuousIdentitySystem",
    "page": "Types",
    "title": "MathematicalSystems.ContinuousIdentitySystem",
    "category": "type",
    "text": "ContinuousIdentitySystem <: AbstractContinuousSystem\n\nTrivial identity continuous-time system of the form\n\nx = 0\n\n\n\n"
},

{
    "location": "lib/types.html#MathematicalSystems.ConstrainedContinuousIdentitySystem",
    "page": "Types",
    "title": "MathematicalSystems.ConstrainedContinuousIdentitySystem",
    "category": "type",
    "text": "ConstrainedContinuousIdentitySystem <: AbstractContinuousSystem\n\nTrivial identity continuous-time system with state constraints of the form\n\nx = 0x(t)  mathcalX\n\n\n\n"
},

{
    "location": "lib/types.html#MathematicalSystems.LinearContinuousSystem",
    "page": "Types",
    "title": "MathematicalSystems.LinearContinuousSystem",
    "category": "type",
    "text": "LinearContinuousSystem\n\nContinuous-time linear system of the form\n\nx = A x\n\nFields\n\nA – square matrix\n\n\n\n"
},

{
    "location": "lib/types.html#MathematicalSystems.LinearControlContinuousSystem",
    "page": "Types",
    "title": "MathematicalSystems.LinearControlContinuousSystem",
    "category": "type",
    "text": "LinearControlContinuousSystem\n\nContinuous-time linear control system of the form\n\nx = A x + B u\n\nFields\n\nA – square matrix\nB – matrix\n\n\n\n"
},

{
    "location": "lib/types.html#MathematicalSystems.ConstrainedLinearContinuousSystem",
    "page": "Types",
    "title": "MathematicalSystems.ConstrainedLinearContinuousSystem",
    "category": "type",
    "text": "ConstrainedLinearContinuousSystem\n\nContinuous-time linear system with state constraints of the form\n\nx = A xx(t)  mathcalX\n\nFields\n\nA – square matrix\nX – state constraints\n\n\n\n"
},

{
    "location": "lib/types.html#MathematicalSystems.ConstrainedLinearControlContinuousSystem",
    "page": "Types",
    "title": "MathematicalSystems.ConstrainedLinearControlContinuousSystem",
    "category": "type",
    "text": "ConstrainedLinearControlContinuousSystem\n\nContinuous-time linear control system with state constraints of the form\n\nx = A x + B ux(t)  mathcalXu(t)  mathcalU text for all  t\n\nFields\n\nA – square matrix\nB – matrix\nX – state constraints\nU – input constraints\n\n\n\n"
},

{
    "location": "lib/types.html#MathematicalSystems.LinearAlgebraicContinuousSystem",
    "page": "Types",
    "title": "MathematicalSystems.LinearAlgebraicContinuousSystem",
    "category": "type",
    "text": "LinearAlgebraicContinuousSystem\n\nContinuous-time linear algebraic system of the form\n\nE x = A x\n\nFields\n\nA – matrix\nE – matrix, same size as A\n\n\n\n"
},

{
    "location": "lib/types.html#MathematicalSystems.ConstrainedLinearAlgebraicContinuousSystem",
    "page": "Types",
    "title": "MathematicalSystems.ConstrainedLinearAlgebraicContinuousSystem",
    "category": "type",
    "text": "ConstrainedLinearAlgebraicContinuousSystem\n\nContinuous-time linear system with state constraints of the form\n\nE x = A xx(t)  mathcalX\n\nFields\n\nA – matrix\nE – matrix, same size as A\nX – state constraints\n\n\n\n"
},

{
    "location": "lib/types.html#Continuous-Systems-1",
    "page": "Types",
    "title": "Continuous Systems",
    "category": "section",
    "text": "ContinuousIdentitySystem\nConstrainedContinuousIdentitySystem\nLinearContinuousSystem\nLinearControlContinuousSystem\nConstrainedLinearContinuousSystem\nConstrainedLinearControlContinuousSystem\nLinearAlgebraicContinuousSystem\nConstrainedLinearAlgebraicContinuousSystem"
},

{
    "location": "lib/types.html#MathematicalSystems.DiscreteIdentitySystem",
    "page": "Types",
    "title": "MathematicalSystems.DiscreteIdentitySystem",
    "category": "type",
    "text": "DiscreteIdentitySystem <: AbstractDiscreteSystem\n\nTrivial identity discrete-time system of the form\n\nx_k+1 = x_k\n\n\n\n"
},

{
    "location": "lib/types.html#MathematicalSystems.ConstrainedDiscreteIdentitySystem",
    "page": "Types",
    "title": "MathematicalSystems.ConstrainedDiscreteIdentitySystem",
    "category": "type",
    "text": "ConstrainedDiscreteIdentitySystem <: AbstractDiscreteSystem\n\nTrivial identity discrete-time system with state constraints of the form\n\nx_k+1 = x_kx_k  mathcalX\n\n\n\n"
},

{
    "location": "lib/types.html#MathematicalSystems.LinearDiscreteSystem",
    "page": "Types",
    "title": "MathematicalSystems.LinearDiscreteSystem",
    "category": "type",
    "text": "LinearDiscreteSystem\n\nDiscrete-time linear system of the form\n\nx_k+1 = A x_k\n\nFields\n\nA – square matrix\n\n\n\n"
},

{
    "location": "lib/types.html#MathematicalSystems.LinearControlDiscreteSystem",
    "page": "Types",
    "title": "MathematicalSystems.LinearControlDiscreteSystem",
    "category": "type",
    "text": "LinearControlDiscreteSystem\n\nDiscrete-time linear control system of the form\n\nx_k+1 = A x_k + B u_k\n\nFields\n\nA – square matrix\nB – matrix\n\n\n\n"
},

{
    "location": "lib/types.html#MathematicalSystems.ConstrainedLinearDiscreteSystem",
    "page": "Types",
    "title": "MathematicalSystems.ConstrainedLinearDiscreteSystem",
    "category": "type",
    "text": "ConstrainedLinearDiscreteSystem\n\nDiscrete-time linear system with state constraints of the form\n\nx_k+1 = A x_kx_k  mathcalX\n\nFields\n\nA – square matrix\nX – state constraints\n\n\n\n"
},

{
    "location": "lib/types.html#MathematicalSystems.ConstrainedLinearControlDiscreteSystem",
    "page": "Types",
    "title": "MathematicalSystems.ConstrainedLinearControlDiscreteSystem",
    "category": "type",
    "text": "ConstrainedLinearControlDiscreteSystem\n\nDiscrete-time linear control system with state constraints of the form\n\nx_k+1 = A x_k + B u_kx_k  mathcalXu_k  mathcalU text for all  k\n\nFields\n\nA – square matrix\nB – matrix\nX – state constraints\nU – input constraints\n\n\n\n"
},

{
    "location": "lib/types.html#MathematicalSystems.LinearAlgebraicDiscreteSystem",
    "page": "Types",
    "title": "MathematicalSystems.LinearAlgebraicDiscreteSystem",
    "category": "type",
    "text": "LinearAlgebraicDiscreteSystem\n\nDiscrete-time linear algebraic system of the form\n\nE x_k+1 = A x_k\n\nFields\n\nA – matrix\nE – matrix, same size as A\n\n\n\n"
},

{
    "location": "lib/types.html#MathematicalSystems.ConstrainedLinearAlgebraicDiscreteSystem",
    "page": "Types",
    "title": "MathematicalSystems.ConstrainedLinearAlgebraicDiscreteSystem",
    "category": "type",
    "text": "ConstrainedLinearAlgebraicDiscreteSystem\n\nDiscrete-time linear system with state constraints of the form\n\nE x_k+1 = A x_kx_k  mathcalX\n\nFields\n\nA – matrix\nE – matrix, same size as A\nX – state constraints\n\n\n\n"
},

{
    "location": "lib/types.html#Discrete-Systems-1",
    "page": "Types",
    "title": "Discrete Systems",
    "category": "section",
    "text": "DiscreteIdentitySystem\nConstrainedDiscreteIdentitySystem\nLinearDiscreteSystem\nLinearControlDiscreteSystem\nConstrainedLinearDiscreteSystem\nConstrainedLinearControlDiscreteSystem\nLinearAlgebraicDiscreteSystem\nConstrainedLinearAlgebraicDiscreteSystem"
},

{
    "location": "lib/types.html#MathematicalSystems.InitialValueProblem",
    "page": "Types",
    "title": "MathematicalSystems.InitialValueProblem",
    "category": "type",
    "text": "InitialValueProblem\n\nParametric composite type for initial value problems. It is parameterized in the system\'s type.\n\nFields\n\ns  – system\nx0 – initial state\n\nExamples\n\nThe linear system x = -x with initial condition x_0 = -12 12:\n\njulia> p = InitialValueProblem(LinearContinuousSystem(-eye(2)), [-1/2., 1/2]);\n\njulia> p.x0\n2-element Array{Float64,1}:\n -0.5\n  0.5\njulia> statedim(p)\n  2\njulia> inputdim(p)\n  0\n\n\n\n"
},

{
    "location": "lib/types.html#MathematicalSystems.IVP",
    "page": "Types",
    "title": "MathematicalSystems.IVP",
    "category": "type",
    "text": "IVP\n\nIVP is an alias for InitialValueProblem.\n\n\n\n"
},

{
    "location": "lib/types.html#Initial-Value-Problems-1",
    "page": "Types",
    "title": "Initial Value Problems",
    "category": "section",
    "text": "InitialValueProblem\nIVP"
},

{
    "location": "lib/types.html#MathematicalSystems.AbstractInput",
    "page": "Types",
    "title": "MathematicalSystems.AbstractInput",
    "category": "type",
    "text": "AbstractInput\n\nAbstract supertype for all input types.\n\nNotes\n\nThe input types defined here implement an iterator interface, such that other methods can build upon the behavior of inputs which are either constant or varying.\n\nIteration is supported with an index number called iterator state. The iteration function Base.next takes and returns a tuple (input, state), where input represents the value of the input, and state is an index which counts the number of times this iterator was called.\n\nA convenience function nextinput(input, n) is also provided and it returns the first n elements of input.\n\n\n\n"
},

{
    "location": "lib/types.html#MathematicalSystems.ConstantInput",
    "page": "Types",
    "title": "MathematicalSystems.ConstantInput",
    "category": "type",
    "text": "ConstantInput{UT} <: AbstractInput\n\nType representing an input that remains constant in time.\n\nFields\n\nU – input set\n\nExamples\n\nThe constant input holds a single element and its length is infinite. To access the field U, you can use Base\'s next given a state, or the method  nextinput given the number of desired input elements:\n\njulia> c = ConstantInput(-1//2)\nMathematicalSystems.ConstantInput{Rational{Int64}}(-1//2)\n\njulia> next(c, 1)\n(-1//2, nothing)\n\njulia> next(c, 2)\n(-1//2, nothing)\n\njulia> collect(nextinput(c, 4))\n4-element Array{Rational{Int64},1}:\n -1//2\n -1//2\n -1//2\n -1//2\n\nThe elements of this input are rational numbers:\n\njulia> eltype(c)\nRational{Int64}\n\nTo transform a constant input, you can use map as in:\n\njulia> map(x->2*x, c)\nMathematicalSystems.ConstantInput{Rational{Int64}}(-1//1)\n\n\n\n"
},

{
    "location": "lib/types.html#MathematicalSystems.VaryingInput",
    "page": "Types",
    "title": "MathematicalSystems.VaryingInput",
    "category": "type",
    "text": "VaryingInput{UT} <: AbstractInput\n\nType representing an input that may vary with time.\n\nFields\n\nU – vector of input sets\n\nExamples\n\nThe varying input holds a vector and its length equals the number of elements in the vector. Consider an input given by a vector of rational numbers:\n\njulia> v = VaryingInput([-1//2, 1//2])\nMathematicalSystems.VaryingInput{Rational{Int64}}(Rational{Int64}[-1//2, 1//2])\n\njulia> length(v)\n2\n\njulia> eltype(v)\nRational{Int64}\n\nBase\'s next method receives the input and an integer state and returns the input element and the next iteration state:\n\njulia> next(v, 1)\n(-1//2, 2)\n\njulia> next(v, 2)\n(1//2, 3)\n\nThe method nextinput receives a varying input and an integer n and returns an iterator over the first n elements of this input (where n=1 by default):\n\njulia> typeof(nextinput(v))\nBase.Iterators.Take{MathematicalSystems.VaryingInput{Rational{Int64}}}\n\njulia> collect(nextinput(v, 1))\n1-element Array{Rational{Int64},1}:\n -1//2\n\njulia> collect(nextinput(v, 2))\n2-element Array{Rational{Int64},1}:\n -1//2\n  1//2\n\nYou can collect the inputs in an array, or equivalently use list comprehension, (or use a for loop):\n\njulia> collect(v)\n2-element Array{Rational{Int64},1}:\n -1//2\n  1//2\n\njulia> [2*vi for vi in v]\n2-element Array{Rational{Int64},1}:\n -1//1\n  1//1\n\nSince this input type is finite, querying more elements than its length returns the full vector:\n\njulia> collect(nextinput(v, 4))\n2-element Array{Rational{Int64},1}:\n -1//2\n  1//2\n\nTo transform a varying input, you can use map as in:\n\njulia> map(x->2*x, v)\nMathematicalSystems.VaryingInput{Rational{Int64}}(Rational{Int64}[-1//1, 1//1])\n\n\n\n"
},

{
    "location": "lib/types.html#Input-Types-1",
    "page": "Types",
    "title": "Input Types",
    "category": "section",
    "text": "AbstractInput\nConstantInput\nVaryingInput"
},

{
    "location": "lib/methods.html#",
    "page": "Methods",
    "title": "Methods",
    "category": "page",
    "text": ""
},

{
    "location": "lib/methods.html#Methods-1",
    "page": "Methods",
    "title": "Methods",
    "category": "section",
    "text": "This section describes systems methods implemented in MathematicalSystems.jl.Pages = [\"methods.md\"]\nDepth = 3CurrentModule = MathematicalSystems\nDocTestSetup = quote\n    using MathematicalSystems\nend"
},

{
    "location": "lib/methods.html#MathematicalSystems.statedim",
    "page": "Methods",
    "title": "MathematicalSystems.statedim",
    "category": "function",
    "text": "statedim(s::AbstractSystem)\n\nReturns the dimension of the state space of system s.\n\n\n\n"
},

{
    "location": "lib/methods.html#MathematicalSystems.stateset",
    "page": "Methods",
    "title": "MathematicalSystems.stateset",
    "category": "function",
    "text": "stateset(s::AbstractSystem)\n\nReturns the set of allowed states of system s.\n\n\n\n"
},

{
    "location": "lib/methods.html#States-1",
    "page": "Methods",
    "title": "States",
    "category": "section",
    "text": "statedim\nstateset"
},

{
    "location": "lib/methods.html#MathematicalSystems.inputdim",
    "page": "Methods",
    "title": "MathematicalSystems.inputdim",
    "category": "function",
    "text": "inputdim(s::AbstractSystem)\n\nReturns the dimension of the input space of system s.\n\n\n\n"
},

{
    "location": "lib/methods.html#MathematicalSystems.inputset",
    "page": "Methods",
    "title": "MathematicalSystems.inputset",
    "category": "function",
    "text": "inputset(s::AbstractSystem)\n\nReturns the set of allowed inputs of system s.\n\n\n\n"
},

{
    "location": "lib/methods.html#MathematicalSystems.nextinput",
    "page": "Methods",
    "title": "MathematicalSystems.nextinput",
    "category": "function",
    "text": "nextinput(input::ConstantInput, n::Int=1)\n\nReturns the first n elements of this input.\n\nInput\n\ninput – a constant input\nn     – (optional, default: 1) the number of desired elements\n\nOutput\n\nA repeated iterator that generates n equal samples of this input.\n\n\n\nnextinput(input::VaryingInput, n::Int=1)\n\nReturns the first n elements of this input.\n\nInput\n\ninput – varying input\nn     – (optional, default: 1) number of desired elements\n\nOutput\n\nAn iterator of type Base.Iterators.Take that represents at most the first n elements of this input.\n\n\n\n"
},

{
    "location": "lib/methods.html#Inputs-1",
    "page": "Methods",
    "title": "Inputs",
    "category": "section",
    "text": "inputdim\ninputset\nnextinput"
},

{
    "location": "about.html#",
    "page": "About",
    "title": "About",
    "category": "page",
    "text": ""
},

{
    "location": "about.html#About-1",
    "page": "About",
    "title": "About",
    "category": "section",
    "text": "This page contains some general information about this project, and recommendations about contributing.Pages = [\"about.md\"]"
},

{
    "location": "about.html#Contributing-1",
    "page": "About",
    "title": "Contributing",
    "category": "section",
    "text": "If you like this package, consider contributing! You can send bug reports (or fix them and send your code), add examples to the documentation, or propose new features.Below some conventions that we follow when contributing to this package are detailed. For specific guidelines on documentation, see the Documentations Guidelines wiki."
},

{
    "location": "about.html#Branches-and-pull-requests-(PR)-1",
    "page": "About",
    "title": "Branches and pull requests (PR)",
    "category": "section",
    "text": "We use a standard pull request policy: You work in a private branch and eventually add a pull request, which is then reviewed by other programmers and merged into the master branch.Each pull request should be pushed in a new branch with the name of the author followed by a descriptive name, e.g., mforets/my_feature. If the branch is associated to a previous discussion in one issue, we use the name of the issue for easier lookup, e.g., mforets/7."
},

{
    "location": "about.html#Unit-testing-and-continuous-integration-(CI)-1",
    "page": "About",
    "title": "Unit testing and continuous integration (CI)",
    "category": "section",
    "text": "This project is synchronized with Travis CI such that each PR gets tested before merging (and the build is automatically triggered after each new commit). For the maintainability of this project, it is important to understand and fix the failing doctests if they exist. We develop in Julia v0.6.0, but for experimentation we also build on the nightly branch.When you modify code in this package, you should make sure that all unit tests pass. To run the unit tests locally, you should do:$ julia --color=yes test/runtests.jlAlternatively, you can achieve the same from inside the REPL using the following command:julia> Pkg.test(\"MathematicalSystems\")We also advise adding new unit tests when adding new features to ensure long-term support of your contributions."
},

{
    "location": "about.html#Contributing-to-the-documentation-1",
    "page": "About",
    "title": "Contributing to the documentation",
    "category": "section",
    "text": "New functions and types should be documented according to our guidelines directly in the source code.You can view the source code documentation from inside the REPL by typing ? followed by the name of the type or function. For example, the following command will print the documentation of the AbstractSystem type:julia> ?LinearContinuousSystemThis documentation you are currently reading is written in Markdown, and it relies on Documenter.jl to produce the HTML layout. The sources for creating this documentation are found in docs/src. You can easily include the documentation that you wrote for your functions or types there (see the Documenter.jl guide or our sources for examples).To generate the documentation locally, run make.jl, e.g., by executing the following command in the terminal:$ julia --color=yes docs/make.jlNote that this also runs all doctests which will take some time."
},

{
    "location": "about.html#Related-projects-1",
    "page": "About",
    "title": "Related projects",
    "category": "section",
    "text": "This package originated from Hybrid Systems and systems definitions for reachability problems within JuliaReach.Below we list more related projects.Package name Description\nHybridSystems.jl Hybrid Systems definitions in Julia.\nLTISystems.jl Julia package for representing linear time-invariant system models and operations defined on them.\nControlToolbox.jl Analysis and design tools for control systems.\nronisbr/ControlToolbox.jl A Control Toolbox for Julia language.\nDynamicalSystemsBase.jl Definitions of core system and data types used in the ecosystem of DynamicalSystems.jl.\nControlSystems.jl A Control Systems Toolbox for Julia\nModelingToolkit.jl A toolkit for modeling and creating DSLs for Scientific Computing in Julia"
},

{
    "location": "about.html#Credits-1",
    "page": "About",
    "title": "Credits",
    "category": "section",
    "text": "These persons have contributed to MathematicalSystems.jl (in alphabetic order):Marcelo Forets\nBenoît Legat\nChristian Schilling"
},

]}
