
struct Move
    amount::Int64
    from::Int64
    to::Int64
end

function main()
    temp_stacks = []
    moves::Array{Move} = []

    open("input") do file
        first_part = true

        for line in eachline(file)
            if first_part
                if line[2] == '1'
                    first_part = false
                    continue
                end

                stack = []
                
                while !isempty(line)
                    line = chop(line, head=1, tail=0)
                    push!(stack, first(line))
                    line = chop(line, head=3, tail=0)
                end

                push!(temp_stacks, stack)
            else
                if strip(line) == ""
                    continue
                end

                parts = split(line, " ")
                amount = parse(Int64, parts[2])
                from = parse(Int64, parts[4])
                to = parse(Int64, parts[6])

                push!(moves, Move(amount, from, to))
            end
        end
    end

    stacks::Array{Array{Char}} = []

    for x in 1:length(temp_stacks[1])
        stack = []
        for y in 1:length(temp_stacks)
        
            if temp_stacks[y][x] != ' '
                push!(stack, temp_stacks[y][x])
            end
        end

        push!(stacks, reverse(stack))
    end

    solve(stacks, moves)
end

function solve(stacks::Array{Array{Char}}, moves::Array{Move})
    for move in moves
        
        for i in 1:move.amount
            crate = pop!(stacks[move.from])
            push!(stacks[move.to], crate)
        end
    end

    for stack in stacks
        print(last(stack))
    end
    println()

end


main()