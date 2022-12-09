function main()
    input = []

    open("input") do file
        for line in eachline(file)
            parts = split(line, " ")

            push!(input, (parts[1], parse(Int64, parts[2])))
        end
    end

    solve(input)
end

function solve(input)
    xPositions = [0 for i in 1:10]
    yPositions = [0 for i in 1:10]

    tail_positions = Set()
    push!(tail_positions, (0,0))

    function normalize(value)
        if value > 0
            return 1
        end

        if value < 0
            return -1
        end

        return 0
    end

    function move(knot, direction)
        if knot == 1
            if direction == "R"
                xPositions[1] += 1
            elseif direction == "L"
                xPositions[1] -= 1
            elseif direction == "U"
                yPositions[1] += 1
            elseif direction == "D"
                yPositions[1] -= 1
            end
        else
            if xPositions[knot-1] - xPositions[knot] == 2
                xPositions[knot] += 1
                yPositions[knot] += normalize(yPositions[knot-1] - yPositions[knot])
            elseif xPositions[knot] - xPositions[knot-1] == 2
                xPositions[knot] -= 1
                yPositions[knot] += normalize(yPositions[knot-1] - yPositions[knot])
            elseif yPositions[knot-1] - yPositions[knot] == 2
                yPositions[knot] += 1
                xPositions[knot] += normalize(xPositions[knot-1] - xPositions[knot])
            elseif yPositions[knot] - yPositions[knot-1] == 2
                yPositions[knot] -= 1
                xPositions[knot] += normalize(xPositions[knot-1] - xPositions[knot])
            end
        end
    end

    for (direction, steps) in input
        for i in 1:steps
            for knot in 1:10
                move(knot, direction)

                push!(tail_positions, (xPositions[10], yPositions[10]))
            end
        end
    end
    
    println(length(tail_positions))
end

main()