
function main()
    lines = []

    open("input") do file

        for line in eachline(file)
            parts = split(line, " -> ")
            
            points = []

            for part in parts
                (x,y) = split(part, ",")

                push!(points, (parse(Int64, x)+1, parse(Int64, y)+1))
            end

            push!(lines, points)
        end
    end

    solve(lines)
end

function get_points_between((x1,y1), (x2,y2))
    result = []

    if x1 == x2
        for y in min(y1,y2):max(y1,y2)
            push!(result, (x1,y))
        end
    end

    if y1 == y2
        for x in min(x1,x2):max(x1,x2)
            push!(result, (x,y1))
        end
    end

    return result
end

function solve(lines)
    matrix::Array{Array{Bool}} = [[false for j in 1:1000] for i in 1:1000]
    lowest_y_by_x = [-1 for i in 1:1000]
    lowest_y = -1

    for points in lines
        for i in 1:length(points)-1
            for (x,y) in get_points_between(points[i], points[i+1])
                matrix[x][y] = true

                lowest_y_by_x[x] = max(lowest_y_by_x[x], y)
                lowest_y = max(lowest_y, y)
            end
        end
    end

    for x in 1:1000
        matrix[x][lowest_y + 2] = true
    end

    (sand_x, sand_y) = (501,1)
    sand = 0

    while true
        if !matrix[sand_x][sand_y + 1]
            matrix[sand_x][sand_y] = false
            sand_y += 1
            matrix[sand_x][sand_y] = true
        elseif !matrix[sand_x - 1][sand_y + 1]
            matrix[sand_x][sand_y] = false
            sand_y += 1
            sand_x -= 1
            matrix[sand_x][sand_y] = true
        elseif !matrix[sand_x + 1][sand_y + 1]
            matrix[sand_x][sand_y] = false
            sand_y += 1
            sand_x += 1
            matrix[sand_x][sand_y] = true
        else
            sand += 1

            if (sand_x, sand_y) == (501,1)
                break
            end

            (sand_x, sand_y) = (501,1)
        end        
    end

    println(sand)
end

main()