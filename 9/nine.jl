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
    headX = 0
    headY = 0
    tailX = 0
    tailY = 0

    tail_positions = Set()
    push!(tail_positions, (tailX, tailY))

    for (direction, steps) in input
        
        for i in 1:steps
            if direction == "R"
                headX += 1
            elseif direction == "L"
                headX -= 1
            elseif direction == "U"
                headY += 1
            elseif direction == "D"
                headY -= 1
            end

            if headX - tailX == 2
                tailX += 1
                tailY += (headY - tailY)
            elseif tailX - headX == 2
                tailX -= 1
                tailY += (headY - tailY)
            elseif headY - tailY == 2
                tailY += 1
                tailX += (headX - tailX)
            elseif tailY - headY == 2
                tailY -= 1
                tailX += (headX - tailX)
            end
            
            push!(tail_positions, (tailX, tailY))
        end

    end
    
    println(length(tail_positions))
end

main()