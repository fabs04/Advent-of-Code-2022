
function calculate_priority(item)
    value = convert(Int64, item)

    if islowercase(item)
        return value - 96
    end

    return value - 38;

end

function find_badges(group)
    badges = Set()

    for item in group[1]
        if item in group[2] && item in group[3]
            push!(badges, item)
        end
    end

    return badges
end

function main()

    groups = []

    open("input") do file
        current_group  = []

        i = 1
        for rucksack in eachline(file)
            push!(current_group, rucksack)

            if i == 3
                i = 1
                push!(groups, current_group)
                current_group = []
            else
                i += 1
            end
        end
    end

    result = 0

    for group in groups
        badges = find_badges(group)

        for badge in badges
            result += calculate_priority(badge)
        end
    end

    println(result)

end

main()