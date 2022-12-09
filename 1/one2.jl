
function main()
    foods = []

    current_food = 0

    open("input") do file
        for line in eachline(file)
            if strip(line) == ""
                push!(foods, current_food)

                current_food = 0
            else
                current_food += parse(Int64, line)
            end
        end

        push!(foods, current_food)

        current_food = 0
    end

    sort!(foods, rev=true)

    println(foods[1] + foods[2] + foods[3])
end

main()