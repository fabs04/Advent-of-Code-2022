
value_dict = Dict([("A", 1), ("B", 2), ("C", 3), ("X", 1), ("Y", 2), ("Z", 3)])

# A: Rock
# B: Paper
# C: Scissors

# X Rock
# Y Paper
# Z Scissors

function calculate_winning_move(other_move)
    if other_move == "A"
        return "Y"
    elseif other_move == "B"
        return "Z"
    elseif other_move == "C"
        return "X"
    end
end

function calculate_loosing_move(other_move)
    if other_move == "A"
        return "Z"
    elseif other_move == "B"
        return "X"
    elseif other_move == "C"
        return "Y"
    end
end

function calculate_draw_move(other_move)
    if other_move == "A"
        return "X"
    elseif other_move == "B"
        return "Y"
    elseif other_move == "C"
        return "Z"
    end
end

function calculate_move(other_move, indicator)
    if indicator == "X"
        return calculate_loosing_move(other_move)
    elseif indicator == "Y"
        return calculate_draw_move(other_move)
    elseif indicator == "Z"
        return calculate_winning_move(other_move)
    end
end

function get_win_score(other_move, my_move)
    if value_dict[my_move] == value_dict[other_move]
        return 3
    end

    if (other_move == "A" && my_move == "Y") || (other_move == "B" && my_move == "Z") || (other_move == "C" && my_move == "X")
        return 6
    end

    if (other_move == "A" && my_move == "Z") || (other_move == "B" && my_move == "X") || (other_move == "C" && my_move == "Y")
        return 0
    end

    error("Invalid combination: " * string(my_move) * string(other_move))
end

function main()

    score = 0

    open("input") do file
        for line in eachline(file)
            line = strip(line)
            parts = split(line, " ")

            other_move = strip(parts[1])
            indicator = strip(parts[2])
            my_move = calculate_move(other_move, indicator)

            win_score = get_win_score(other_move, my_move)
            move_score = value_dict[my_move]

            score += win_score
            score += move_score
        end
    end

    println(score)

end

main()
