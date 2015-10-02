function unit_value{T <: NumberParameter}(parameter::T)
    (parameter.value - parameter.min) / (parameter.max - parameter.min)
end

function unit_value{T <: EnumParameter}(parameter::T)
    (parameter.value - 1) / (length(parameter.values) - 1)
end

function unit_value!{T <: EnumParameter}(parameter::T, unit::Float64)
    @assert 0.0 <= unit <= 1.0
    value = round((unit * (length(parameter.values) - 1)) + 1)
    @inbounds parameter.current = parameter.values[parameter.value]
    parameter.value
end

function unit_value!(parameter::IntegerParameter, unit::Float64)
    @assert 0.0 <= unit <= 1.0
    value = int((unit * (parameter.max - parameter.min)) + parameter.min)
    parameter.value
end

function unit_value!(parameter::FloatParameter, unit::Float64)
    @assert 0.0 <= unit <= 1.0
    value = (unit * (parameter.max - parameter.min)) + parameter.min
    parameter.value
end
