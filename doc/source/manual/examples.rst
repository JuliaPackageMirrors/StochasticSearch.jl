.. _ref-examples:

----------------------------
Examples
----------------------------

This page provides examples that
will help you learn the package's
API.

The Rosenbrock Function
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The following is a very simple example, and you can find its source code `here
<https://github.com/phrb/StochasticSearch.jl/blob/master/examples/rosenbrock/rosenbrock.jl>`_.

We will optimize the
`Rosenbrock
<http://en.wikipedia.org/wiki/Rosenbrock_function>`_ cost function.
For this we must define a ``Configuration`` that represents the arguments to
be tuned. We also have to create and configure a tuning run. First, let's
import StochasticSearch and define the cost function::

    @everywhere begin
        using StochasticSearch
        function rosenbrock(x::Configuration, parameters::Dict{Symbol, Any})
            return (1.0 - x["i0"].value)^2 + 100.0 * (x["i1"].value - x["i0"].value^2)^2
        end
    end

We use the ``@everywhere`` macro to define the function in all Julia workers available.

Cost functions must accept a ``Configuration`` and a ``Dict{Symbol, Any}`` as
input. Our cost function simply ignores the parameter dictionary, and uses the
``"i0"`` and ``"i1"`` parameters of the received configuration to calculate a
value. There is no restriction on ``Configuration`` parameter naming.

Our configuration will have two ``FloatParameter``\s, which will be
``Float64`` values constrained to an interval. The intervals are ``[-2.0,
2.0]`` for both parameters, and their values start at ``0.0``. Since we
already used the names ``"i0"`` and ``"i1"``, we name the parameters the same way::

    configuration = Configuration([FloatParameter(-2.0, 2.0, 0.0, "i0"),
                                   FloatParameter(-2.0, 2.0, 0.0, "i1")],
                                   "rosenbrock_config")

Now we must configure a new tuning run using the ``Run`` type. There are many
parameters to configure, but they all have default values. Since we won't be
using them all, please see
`Run
<https://github.com/phrb/StochasticSearch.jl/blob/master/src/core/run.jl>`_\'s
source code for further details::

    tuning_run = Run(cost               = rosenbrock,
                     starting_point     = configuration,
                     methods            = [[:simulated_annealing 1];
                                           [:iterative_first_improvement 1];
                                           [:randomized_first_improvement 1];
                                           [:iterative_greedy_construction 1];
                                           [:iterative_probabilistic_improvement 1];])

The ``methods`` array defines the search methods, and their respective number of
instances, that will be used in this tuning run. This example uses one instance
of every implemented search technique. The search will start at the point
defined by ``starting_point``.

We are ready to create a search task using the ``@task`` macro. For more
information on how tasks work, please check the `Julia Documentation
<http://docs.julialang.org/en/latest/manual/control-flow/#man-tasks>`_.
This new task will run the ``optimize`` method, which receives a tuning run
configuration and runs the search techniques in background. The task will
produce ``optimize``\'s current best result whenever we call ``consume`` on it::

    search_task = @task optimize(tuning_run)
    result = consume(search_task)

The tuning run will use the default neighboring and perturbation methods
implemented by StochasticSearch.jl to find new results. Now we can process the
current result, in this case we just ``print`` it, and loop until ``optimize`` is
done::

    print(result)
    while result.is_final == false
        result = consume(search_task)
        print(result)
    end

Running the complete example, we get::

    $ julia --color=yes examples/rosenbrock/rosenbrock.jl
    [Result]
    Cost              : 40.122073057715546
    Found in Iteration: 1
    Current Iteration : 1
    Technique         : Initialize
    Function Calls    : 1
      ***
    [Final Result]
    Cost                  : 0.03839419856300206
    Found in Iteration    : 237
    Current Iteration     : 1001
    Technique             : Simulated Annealing
    Function Calls        : 237
    Starting Configuration:
      [Configuration]
      name      : rosenbrock_config
      parameters:
        [NumberParameter]
        name : i0
        min  : -2.000000
        max  : 2.000000
        value: 0.787244
        ***
        [NumberParameter]
        name : i1
        min  : -2.000000
        max  : 2.000000
        value: 0.656131
    Minimum Configuration :
      [Configuration]
      name      : rosenbrock_config
      parameters:
        [NumberParameter]
        name : i0
        min  : -2.000000
        max  : 2.000000
        value: 0.813772
        ***
        [NumberParameter]
        name : i1
        min  : -2.000000
        max  : 2.000000
        value: 0.656131

Autotuning Sorting Algorithms Cutoff
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The Travelling Salesperson Problem
~~~~~~~~~~~~~~~~~~~~~~~~~~~~
