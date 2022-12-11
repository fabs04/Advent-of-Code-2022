import Base.+
import Base.*
import Base.^
import Base.%

@enum Operation begin
    addition = 1
    multiplication = 2
    square = 3
end

struct ModuloValue
    modules::Array{Int64}
    values::Array{Int64}
end

function (+)(n::Int64, v::ModuloValue)
    result = []
    
    for i in eachindex(v.modules)
        m = v.modules[i]
        push!(result, (v.values[i] + n) % m)
    end

    return ModuloValue(v.modules, result)
end

function (+)(v::ModuloValue, n::Int64, )
    return n+v
end

function (*)(n::Int64, v::ModuloValue)
    result = []
    
    for i in eachindex(v.modules)
        m = v.modules[i]
        push!(result, (v.values[i] * n) % m)
    end

    return ModuloValue(v.modules, result)
end

function (*)(v::ModuloValue, n::Int64, )
    return n*v
end

function (*)(v1::ModuloValue, v2::ModuloValue)
    result = []
    
    for i in eachindex(v1.modules)
        m = v1.modules[i]
        push!(result, ((v1.values[i] * v2.values[i]) % m))
    end

    return ModuloValue(v1.modules, result)
end

function (%)(v::ModuloValue, m::Int64, )
    i = findfirst(x->x==m, v.modules)

    return v.values[i] % m
end

mutable struct Monkey
    items::Array{ModuloValue} # worry levels of items
    operation::Operation
    operation_value::Int64
    test_divisor::Int64
    test_true::Int64 # Monkey to which the item is thrown if the test condition is true
    test_false::Int64 # Monkey to which the item is thrown if the test condition is false

    activity::Int64
end

function main()
    monkeys::Array{Monkey} = []

    items::Array{ModuloValue} = []
    operation::Operation = addition
    operation_value::Int64 = 0
    test_divisor::Int64 = 0
    test_true::Int64 = 0 
    test_false::Int64 = 0

    open("input") do file
        for line in eachline(file)
            line = strip(line)

            if line == ""
                monkey = Monkey(items, operation, operation_value, test_divisor, test_true, test_false, 0)
                push!(monkeys, monkey)
                items = []
            elseif startswith(line, "Starting items:")
                parts = split(split(line, ": ")[2], ", ")
                for part in parts
                    push!(items, ModuloValue([0], [parse(Int64, part)]))
                end
            elseif startswith(line, "Operation:")
                if occursin("old * old", line)
                    operation = square
                    operation_value = 0
                elseif occursin("old + old", line)
                    operation = multiplication
                    operation_value = 2
                elseif '+' in line
                    operation = addition
                    operation_value = parse(Int64, chop(line, head=length("Operation: new = old + "), tail=0))
                else
                    operation = multiplication
                    operation_value = parse(Int64, chop(line, head=length("Operation: new = old * "), tail=0))
                end
            elseif startswith(line, "Test:")
                test_divisor = parse(Int64, chop(line, head=length("Test: divisible by "), tail=0))
            elseif startswith(line, "If true:")
                test_true = parse(Int64, chop(line, head=length("If true: throw to monkey "), tail=0)) + 1
            elseif startswith(line, "If false:")
                test_false = parse(Int64, chop(line, head=length("If false: throw to monkey "), tail=0)) + 1
            end
        end 
    end

    for monkey in monkeys
        processed_items = []

        for item in monkey.items        
            modules = []
            values = []

            for inner_monkey in monkeys
                push!(modules, inner_monkey.test_divisor)
                push!(values, item.values[1] % inner_monkey.test_divisor)
            end

            push!(processed_items, ModuloValue(modules, values))
        end

        monkey.items = processed_items
    end
    
    for i in 1:10000
        evaluate(monkeys)
    end

    activities = []
    for monkey in monkeys
        push!(activities, monkey.activity)
    end

    sort!(activities, rev=true)

    println(activities[1] * activities[2])
end

function evaluate(monkeys::Array{Monkey})
    for monkey in monkeys
        for item in monkey.items   
            monkey.activity += 1

            if monkey.operation == addition
                item += monkey.operation_value
            elseif monkey.operation == multiplication
                item *= monkey.operation_value
            elseif monkey.operation == square
                item *= item
            end

            if item % monkey.test_divisor == 0
                next_monkey = monkey.test_true
            else
                next_monkey = monkey.test_false
            end

            push!(monkeys[next_monkey].items, item)
        end

        empty!(monkey.items)
    end
end

main()




