
function main()
    max_food = 0

    current_food = 0

    open("input") do file
        for line in eachline(file)
            if strip(line) == ""
                max_food = max(max_food, current_food)

                current_food = 0
            else
                current_food += parse(Int64, line)
            end
        end
    end

    println(max_food)
end

main()