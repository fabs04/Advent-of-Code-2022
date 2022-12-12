function parse_cell(c) :: Int64
    if c == 'S'
        return parse_cell('a')
    end

    if c == 'E'
        return parse_cell('z')
    end

    return c - 96
end

function main()
    matrix = []
    start_pos = (0,0)
    end_pos = (0,0)

    x = 1

    open("input") do file
        for line in eachline(file)
            
            row = []
            y = 1
            for c in line
                if c == 'S'
                    start_pos = (x,y)
                elseif c == 'E'
                    end_pos = (x,y)
                end


                push!(row, parse_cell(c)) 
                y += 1   
            end

            x += 1
            push!(matrix, row)
        end
    end

    solve(matrix, start_pos, end_pos)
end

function get_neighbors(matrix, x, y)
    neighbors = []

    if x > 1 && matrix[x-1][y] - matrix[x][y] <= 1
        push!(neighbors, (x-1, y))
    end

    if x < length(matrix) && matrix[x+1][y] - matrix[x][y] <= 1
        push!(neighbors, (x+1, y))
    end

    if y > 1 && matrix[x][y-1] - matrix[x][y] <= 1
        push!(neighbors, (x, y-1))
    end

    if y < length(matrix[1]) && matrix[x][y+1] - matrix[x][y] <= 1
        push!(neighbors, (x, y+1))
    end

    return neighbors
end

function solve(matrix, (start_x, start_y), (end_x, end_y))
    shortest_paths = [[typemax(Int64) for i in eachindex(matrix[j])] for j in eachindex(matrix)]

    queue = Set()

    shortest_paths[start_x][start_y] = 0
    push!(queue, (0, start_x, start_y))

    while true
        (distance, x, y) = minimum(queue)
        delete!(queue, (distance, x, y))

        shortest_paths[x][y] = distance

        if x == end_x && y == end_y
            break
        end

        for (neighbor_x, neighbor_y) in get_neighbors(matrix, x,y)
            new_path_length = distance + 1
            old_path_length = shortest_paths[neighbor_x][neighbor_y]

            if new_path_length < old_path_length
                shortest_paths[neighbor_x][neighbor_y] = new_path_length
                
                delete!(queue, (old_path_length, neighbor_x, neighbor_y))
                push!(queue, (new_path_length, neighbor_x, neighbor_y))
            end
        end
    end

    println(shortest_paths[end_x][end_y])

end

main()