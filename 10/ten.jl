
function main()
    instructions = []

    open("input") do file
        for line in eachline(file)
            parts = split(line, " ")
            
            push!(instructions, ("noop", 0))

            if parts[1] == "addx"
                push!(instructions, ("addx", parse(Int64, parts[2])))
            end
        end
    end

    solve(instructions)
end

function solve(instructions)
    x = 1
    cycle = 1
    result = 0

    for (instruction, value) in instructions
        if cycle >= 20 && (cycle-20) % 40 == 0
            result += x * cycle
        end

        if instruction == "addx"
            x += value
        end

        cycle += 1
    end

    println(result)
end

main()