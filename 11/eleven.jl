@enum Operation begin
    addition = 1
    multiplication = 2
    square = 3
end

mutable struct Monkey
    items::Array{Int64} # worry levels of items
    operation::Operation
    operation_value::Int64
    test_divisor::Int64
    test_true::Int64 # Monkey to which the item is thrown if the test condition is true
    test_false::Int64 # Monkey to which the item is thrown if the test condition is false

    activity::Int64
end

function main()
    monkeys::Array{Monkey} = []

    items::Array{Int64} = []
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
                    push!(items, parse(Int64, part))
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

    for i in 1:20
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
                item ^= 2
            end

            item = floor(item / 3)

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