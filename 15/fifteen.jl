
function main()
    input = []

    open("testinput") do file
        for line in eachline(file)
            line = chop(line, head=length("Sensor at "), tail = 0)
            parts = split(line, ": closest beacon is at ")

            sensor_parts = split(parts[1], ", ")
            beacon_parts = split(parts[2], ", ")

            sensor = (parse(Int64, split(sensor_parts[1], "=")[2]), parse(Int64, split(sensor_parts[2], "=")[2]))
            closest_beacon = (parse(Int64, split(beacon_parts[1], "=")[2]), parse(Int64, split(beacon_parts[2], "=")[2]))

            push!(input, (sensor, closest_beacon))
        end
    end

    solve(input)
end

function distance((x1,y1), (x2,y2))
    return abs(x1-x2) + abs(y1-y2)
end

function solve(input)
    n = 10

    result = Set()

    for ((sensor_x, sensor_y), (beacon_x, beacon_y)) in input
        distance_sb = distance((sensor_x, sensor_y), (beacon_x, beacon_y))
        
        remaining = distance_sb - abs(sensor_y - n)

        for d in 0:remaining

            push!(result, sensor_x-d)
            push!(result, sensor_x+d)
        end
    end

    for ((sensor_x, sensor_y), (beacon_x, beacon_y)) in input
        if beacon_y == n
            delete!(result, beacon_x)
        end
    end

    println(length(result))
end

main()