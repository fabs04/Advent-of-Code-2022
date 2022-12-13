
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

    open("input") do file
        for line in eachline(file)
            if strip(line) != "" 
                result = parse_line(line)
                push!(input, result)
            end
        end
    end

    push!(input, [[2]])
    push!(input, [[6]])

    solve(input)
end

function is_less_than(left, right)
    if is_right_order(left, right) == right_order
        return true
    end
    
    return false
end

function solve(input)
    sort!(input, lt = is_less_than)

    divider_packet_1 = findfirst(x -> x == [[2]], input)
    divider_packet_2 = findfirst(x -> x == [[6]], input)

    println(divider_packet_1 * divider_packet_2)
end

main()