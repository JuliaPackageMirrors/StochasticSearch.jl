using StochasticSearch, FactCheck

facts("[NumberParameter] constructors") do
    context("[NumberParameter] constructor") do
        p = NumberParameter{Int8}(convert(Int8, 0), convert(Int8, 2),
                                  convert(Int8, 1), :test)
        @fact (typeof(p.min)   == Int8)               => true
        @fact (typeof(p.max)   == Int8)               => true
        @fact (typeof(p.value) == Int8)               => true
        @fact (p.name          == :test)              => true 
        @fact (typeof(p) <: NumberParameter{Int8})    => true
        p = NumberParameter{Float32}(convert(Float32, 0), convert(Float32, 2),
                                     convert(Float32, 1), :test)
        @fact (typeof(p.min)   == Float32)            => true
        @fact (typeof(p.max)   == Float32)            => true
        @fact (typeof(p.value) == Float32)            => true
        @fact (typeof(p) <: NumberParameter{Float32}) => true
    end
    context("[IntegerParameter] constructor") do
        @fact (IntegerParameter <: NumberParameter)    => true
        p = IntegerParameter(0, 10, 3, :test)
        @fact (typeof(p) <: NumberParameter{Integer})  => true
        @fact (typeof(p) <: IntegerParameter)          => true
        @fact (p.min   == 0 )                          => true
        @fact (p.max   == 10)                          => true
        @fact (p.value == 3 )                          => true
        @fact (p.name  == :test)                       => true 
        @fact_throws ErrorException IntegerParameter(3, 1, 2, :test)
        @fact_throws ErrorException IntegerParameter(1, 3, 0, :test)
        @fact_throws ErrorException IntegerParameter(1, 3, 4, :test)
        @fact_throws MethodError    IntegerParameter("a", 3, 4, :test)
        @fact_throws MethodError    IntegerParameter(1, 3, 2)
        @fact_throws MethodError    IntegerParameter(1, 3, 2, "test")
        @fact_throws MethodError    IntegerParameter(1.0, 3, 4, :test)
        p = IntegerParameter(convert(Int8, 0), convert(Int8, 2),
                             convert(Int8, 1), :test)
        @fact (typeof(p) == NumberParameter{Integer}) => true
        @fact (typeof(p) <: IntegerParameter)         => true
        @fact (typeof(p.min)   == Int8)               => true
        @fact (typeof(p.max)   == Int8)               => true
        @fact (typeof(p.value) == Int8)               => true
        @fact (p.min   == 0)                          => true
        @fact (p.max   == 2)                          => true
        @fact (p.value == 1)                          => true
    end
    context("[IntegerParameter] perturbate") do
        value    = 3
        interval = 10
        p = IntegerParameter(0, 100, value, :rand_test)
        perturbate!(p)
        @fact (typeof(p.value) <: Integer)  => true
        @fact (p.value <= p.max)            => true
        @fact (p.value >= p.min)            => true
        perturbate!(p, interval)
        value = p.value
        @fact (typeof(p.value) <: Integer)  => true
        @fact (p.value <= p.max)            => true
        @fact (p.value <= value + interval) => true
        @fact (p.value >= p.min)            => true
        @fact (p.value >= value - interval) => true
        interval = 103 
        perturbate!(p, interval)
        @fact (typeof(p.value) <: Integer)  => true
        @fact (p.value <= p.max)            => true
        @fact (p.value >= p.min)            => true
        interval = -1
        @fact_throws ErrorException perturbate!(p, interval)
        interval = 0
        @fact_throws ErrorException perturbate!(p, interval)
    end
    context("[FloatParameter] constructor") do
        p = FloatParameter(0.223, 10.122, 3.12, :test)
        @fact (p.min   == 0.223 ) => true
        @fact (p.max   == 10.122) => true
        @fact (p.value == 3.12  ) => true
        @fact (p.name  == :test) => true 
        @fact_throws ErrorException FloatParameter(3.3, 1.223, 2.4, :test)
        @fact_throws ErrorException FloatParameter(1.443, 3.2332, 1.442, :test)
        @fact_throws ErrorException FloatParameter(1.23, 3.2, 3.23, :test)
        @fact_throws MethodError    FloatParameter("a", 3, 4, :test)
        @fact_throws MethodError    FloatParameter(1, 3, 2, "test")
        @fact_throws MethodError    FloatParameter(1, 3, 2)
        p = FloatParameter(convert(Float32, 0), convert(Float32, 2),
                           convert(Float32, 1), :test)
        @fact (typeof(p.min)   == Float32)                  => true
        @fact (typeof(p.max)   == Float32)                  => true
        @fact (typeof(p.value) == Float32)                  => true
        @fact (typeof(p) == NumberParameter{FloatingPoint}) => true
        @fact (typeof(p) <: FloatParameter)                 => true
        @fact (p.min   == 0)                                => true
        @fact (p.max   == 2)                                => true
        @fact (p.value == 1)                                => true
    end
    context("[FloatParameter] perturbate") do
        value    = 3.2
        interval = 5.6 
        p = FloatParameter(0., 100., value, :rand_test)
        perturbate!(p)
        @fact (typeof(p.value) <: FloatingPoint) => true
        @fact (p.value <= p.max)                 => true
        @fact (p.value >= p.min)                 => true
        perturbate!(p, interval)
        value = p.value
        @fact (typeof(p.value) <: FloatingPoint) => true
        @fact (p.value <= value + interval)      => true
        @fact (p.value <= p.max)                 => true
        @fact (p.value >= p.min)                 => true
        @fact (p.value >= value - interval)      => true
        interval = 103.0 
        perturbate!(p, interval)
        @fact (typeof(p.value) <: FloatingPoint) => true
        @fact (p.value <= p.max)                 => true
        @fact (p.value >= p.min)                 => true
        interval = -1.2
        @fact_throws ErrorException perturbate!(p, interval)
        interval = 0
        @fact_throws ErrorException perturbate!(p, interval)
    end
end

facts("[EnumParameter] constructors") do
    p = EnumParameter([IntegerParameter(1, 4, 3, :a),
                       IntegerParameter(1, 6, 3, :b)], :test)
    @fact (typeof(p) <: Enum{IntegerParameter})             => true
    @fact (typeof(p.values) <: AbstractArray)               => true
    @fact (typeof(p.values)  == Array{IntegerParameter, 1}) => true
    @fact (p.values[1].value == 3)                          => true
    @fact (p.values[2].value == 3)                          => true
    @fact (p.values[1].name  == :a)                         => true
    @fact (p.values[2].name  == :b)                         => true
    @fact (p.name            == :test)                      => true
    p = EnumParameter([IntegerParameter(1, 4, 3, :a),
                       IntegerParameter(1, 6, 2, :b)], 1, :test)
    @fact (p.current       == 1)                            => true
    @fact (p.value.value   == 3)                            => true
    @fact_throws MethodError    EnumParameter([3, 4], :test)
    @fact_throws MethodError    EnumParameter([IntegerParameter(1, 4, 3, :a),
                                               2], :test)
    @fact_throws MethodError    EnumParameter([IntegerParameter(1, 4, 3, :a)])
    context("[EnumParameter] perturbate!") do
    p = EnumParameter([IntegerParameter(1, 4, 3, :a),
        IntegerParameter(1, 6, 3, :b)], 2, :test)
    perturbate_elements!(p)
    @fact (p.current == 2)                                  => true
    p = EnumParameter([FloatParameter(1.1, 4.2, 3.221, :a),
                       FloatParameter(2.3, 4.4, 3.1, :b)], :test)
    perturbate!(p)
    @fact (p.values[1].value == 3.221)                      => true
    p = EnumParameter([StringParameter("valuea", :a),
                       StringParameter("valueb", :b)], :test)
    perturbate!(p)
    @fact (p.values[1].value == "valuea")                   => true
    end
end

facts("[StringParameter] constructors") do
    p = StringParameter("value", :test)
    @fact (typeof(p) == StringParameter) => true
    @fact (typeof(p) <: Parameter)       => true
    @fact (p.value == "value")           => true
    @fact (p.name  == :test)             => true
    perturbate!(p)
    @fact (p.value == "value")           => true
    @fact_throws MethodError StringParameter(2, :test)
    @fact_throws MethodError StringParameter("value")
end