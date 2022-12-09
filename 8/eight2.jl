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
    function find_left_score(x,y)
        result = 0

        for otherX in reverse(Array(1:x-1))
            result += 1
            if matrix[otherX][y] >= matrix[x][y]
                return result
            end
        end

        return result
    end

    function find_right_score(x,y)
        result = 0

        for otherX in x+1:length(matrix)
            result += 1
            if matrix[otherX][y] >= matrix[x][y]
                return result
            end
        end

        return result
    end

    function find_bottom_score(x,y)
        result = 0

        for otherY in reverse(Array(1:y-1))
            result += 1
            if matrix[x][otherY] >= matrix[x][y]
                return result
            end
        end

        return result
    end
    
    function find_top_score(x,y)
        result = 0

        for otherY in y+1:length(matrix[1])
            result += 1
            if matrix[x][otherY] >= matrix[x][y]
                return result
            end
        end

        return result
    end

    function find_scenic_score(x,y)
        return find_bottom_score(x,y) * find_left_score(x,y) * find_right_score(x,y) * find_top_score(x,y)
    end

    result = 0

    for x in eachindex(matrix)
        for y in eachindex(matrix[x])
            result = max(result, find_scenic_score(x,y))
        end
    end

    println(result)
end

main()