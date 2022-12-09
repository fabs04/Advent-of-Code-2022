function main()
    matrix::Array{Array{Int64}} = []

    open("input") do file
        for line in eachline(file)
            row = []
            for c in line
                push!(row, parse(Int64, c))
            end

            push!(matrix, row)
        end
    end

    evaluate(matrix)
end

function evaluate(matrix::Array{Array{Int64}})    
    function is_visible_from_left(x,y)
        for otherX in 1:x-1
            if otherX != x && matrix[otherX][y] >= matrix[x][y]
                return false
            end
        end

        return true
    end

    function is_visible_from_right(x,y)
        for otherX in x+1:length(matrix)
            if otherX != x && matrix[otherX][y] >= matrix[x][y]
                return false
            end
        end

        return true
    end

    function is_visible_from_bottom(x,y)
        for otherY in 1:y-1
            if otherY != y && matrix[x][otherY] >= matrix[x][y]
                return false
            end
        end

        return true
    end
    
    function is_visible_from_top(x,y)
        for otherY in y+1:length(matrix[1])
            if otherY != y && matrix[x][otherY] >= matrix[x][y]
                return false
            end
        end

        return true
    end

    function is_visible(x,y)
        return is_visible_from_bottom(x,y) || is_visible_from_left(x,y) || is_visible_from_right(x,y) || is_visible_from_top(x,y)
    end

    result = 0

    for x in eachindex(matrix)
        for y in eachindex(matrix[x])
            if is_visible(x,y)
                result += 1
            end
        end
    end

    println(result)
end

main()