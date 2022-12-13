
@enum Order begin
    right_order = 1
    wrong_order = 2
    undecided = 3
end

function is_right_order(left :: Int64, right :: Int64) :: Order
    if left > right
        return wrong_order
    elseif left < right
        return right_order
    end

    return undecided
end

function is_right_order(left :: Array, right :: Array) :: Order
    for i in 1:min(length(left), length(right))
        element_order = is_right_order(left[i], right[i]) 

        if element_order != undecided
            return element_order
        end
    end

    if length(left) < length(right)
        return right_order
    elseif length(right) < length(left)
        return wrong_order
    end

    return undecided
end

is_right_order(left :: Int64, right :: Array) = is_right_order([left], right)
is_right_order(left :: Array, right :: Int64) = is_right_order(left, [right])


function parse_line(line)
    result = []

    buffer = ""
    depth = 0

    if line == "[]"
        return []
    end

    number = tryparse(Int64, line)

    if number !== nothing
        return number
    end

    for c in line
        if (c != ',' && c != ']' && depth >= 1) || depth > 1
            buffer *= c
        end 

        if c == '['
            depth += 1
        elseif c == ']'
            depth -= 1

            if depth == 0
                push!(result, parse_line(buffer))
                buffer = ""
            end
        elseif c == ','
            if depth == 1
                push!(result, parse_line(buffer))
                buffer = ""
            end
        end
    end

    return result
end

function main()
    input = []
    current_pair = []
    
    open("input") do file
        for line in eachline(file)
            if line != "" 
                result = parse_line(line)
                push!(current_pair, result)
            else
                push!(input, (current_pair[1], current_pair[2]))
                current_pair = []
            end
        end
    end

    solve(input)
end

function solve(input)
    result = 0

    i = 1
    for (left, right) in input
        if is_right_order(left, right) == right_order
            result += i
        end

        i += 1
    end

    println(result)
end

main()