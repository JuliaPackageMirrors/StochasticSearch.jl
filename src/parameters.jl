abstract Parameter

type NumberParameter{T <: Number} <: Parameter
    min::T
    max::T
    value::T
    name::Symbol
    NumberParameter(min::T, max::T, value::T, name::Symbol) = begin
        if min > max
            error("invalid bounds: min > max")
        elseif value < min || value > max
            error("value out of bounds.")
        else
            new(min, max, value, name)
        end
    end
end

typealias IntegerParameter NumberParameter{Integer}
typealias FloatParameter   NumberParameter{FloatingPoint}

perturbate!(number::NumberParameter) = begin
    number.value = rand_in(number.min, number.max)
end

perturbate!(number::NumberParameter, interval::Number) = begin
    if interval <= 0
        error("interval must be greater than zero.")
    end
    max = number.value + interval > number.max ? number.max : number.value + interval
    min = number.value - interval < number.min ? number.min : number.value - interval
    number.value = rand_in(min, max)
end

type Enum{T <: Parameter} <: Parameter
    values::AbstractArray{T}
    current::Int
    name::Symbol
    value::Parameter
    Enum{T <: Parameter}(values::AbstractArray{T}, current::Int, name::Symbol) = begin
        if current > length(values) || current < 1
            error("current is out of bounds.")
        end
        new(values, current, name, values[current])
    end
    Enum{T <: Parameter}(values::AbstractArray{T}, name::Symbol) = begin
        new(values, rand(1:length(values)), name)
    end
end

typealias EnumParameter Enum{Parameter}

perturbate_elements!(enum::Enum, element::Int) = begin
    perturbate!(enum.values[element])
end

perturbate_elements!(enum::Enum) = begin
    for parameter in enum.values
        perturbate!(parameter)
    end
end

perturbate!(enum::Enum) = begin
    enum.current = rand(1:length(enum.values))
    enum.value   = enum.values[enum.current]
end

type StringParameter <: Parameter
    value::String
    name::Symbol
end

perturbate!(string::StringParameter) = begin
    string.value
end

include("util.jl")