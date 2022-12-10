
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
    cycle = 0

    for (instruction, value) in instructions
        if abs(x - (cycle)) <= 1
            print("#")
        else
            print(".")
        end

        if instruction == "addx"
            x += value
        end

        cycle += 1

        if cycle == 40
            println()
            cycle = 0
        end
    end
end

main()