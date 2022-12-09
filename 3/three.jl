
function calculate_priority(item)
    value = convert(Int64, item)

    if islowercase(item)
        return value - 96
    end

    return value - 38;

end

function find_double_items(first_half, second_half)
    doubles = Set()

    for item in first_half
        if item in second_half
            push!(doubles, item)
        end
    end

    for item in second_half
        if item in first_half
            push!(doubles, item)
        end
    end

    return doubles
end

function main()

    rucksacks = []

    open("input") do file
        for line in eachline(file)
            len = convert(Int64, length(line)/2)
            rucksack = (first(line, len), last(line, len))
            push!(rucksacks, rucksack)
        end
    end

    result = 0

    for (first_half, second_half) in rucksacks
        doubles = find_double_items(first_half, second_half)

        for double in doubles
            result += calculate_priority(double)
        end
    end

    println(result)

end

main()