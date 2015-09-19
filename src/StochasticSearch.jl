VERSION >= v"0.4" && __precompile__()
module StochasticSearch
    using Optim
    # Types
    export Parameter, NumberParameter, IntegerParameter,
           FloatParameter, EnumParameter, StringParameter,
           Configuration, Result, BoolParameter

    # Methods
    export perturb!, perturb_elements!, neighbor!,
           optimize!, optimize, update!,
           unit_value, unit_value!

    # Measurement Tools
    export measure_mean!

    # Search Building Blocks
    export first_improvement,
           probabilistic_improvement,
           greedy_construction,
           random_walk

    # Search Techniques
    export simulated_annealing,
           iterative_gredy_construction,
           iterative_first_improvement,
           randomized_first_improvement,
           iterative_probabilistic_improvement

    # Search Tools
    export initialize_cost, initialize_search_tasks!,
           get_new_best, add_simulated_annealing!,
           add_iterative_first_improvement!,
           add_randomized_first_improvement!,
           add_iterative_greedy_construction!,
           add_iterative_probabilistic_improvement!


    # New Methods for Base Functions
    import Base.convert, Base.show, Base.getindex,
           Base.setindex!

    # Types
    include("core/parameters.jl")
    include("core/configuration.jl")

    # Methods
    include("core/perturb!.jl")
    include("core/perturb_elements!.jl")
    include("core/update!.jl")
    include("core/neighbor!.jl")
    include("core/unit_value.jl")

    # Measurement
    include("core/measurement/measure.jl")
    include("core/measurement/results.jl")

    # Search Blocks
    include("core/search/blocks/first_improvement.jl")
    include("core/search/blocks/probabilistic_improvement.jl")
    include("core/search/blocks/greedy_construction.jl")
    include("core/search/blocks/random_walk.jl")

    # Techniques
    include("core/search/techniques/iterative_first_improvement.jl")
    include("core/search/techniques/iterative_probabilistic_improvement.jl")
    include("core/search/techniques/randomized_first_improvement.jl")
    include("core/search/techniques/iterative_greedy_construction.jl")
    include("core/search/techniques/simulated_annealing.jl")

    # Technique Helpers
    include("core/search/tools/add_simulated_annealing!.jl")
    include("core/search/tools/add_iterative_first_improvement!.jl")
    include("core/search/tools/add_iterative_probabilistic_improvement!.jl")
    include("core/search/tools/add_randomized_first_improvement!.jl")
    include("core/search/tools/add_iterative_greedy_construction!.jl")

    # Tools
    include("core/search/tools/initialize_cost.jl")
    include("core/search/tools/initialize_search_tasks!.jl")
    include("core/search/tools/get_new_best.jl")

    # Optimize
    include("core/search/optimize.jl")

    # Optim.jl interface
    include("optim/optimize!.jl")

    # Utilities
    include("util/random.jl")
    include("util/show.jl")
    include("util/chooseproc.jl")
end
