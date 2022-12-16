bound = 4000000

function main()
    input = []

    open("input") do file
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

function calculate_values(input, y)
    result = []

    for ((sensor_x, sensor_y), (beacon_x, beacon_y)) in input
        distance_sb = distance((sensor_x, sensor_y), (beacon_x, beacon_y))
        
        remaining = distance_sb - abs(sensor_y - y)

        if remaining >= 0
            from = min(bound, max(0,sensor_x - remaining))
            to = max(0, min(bound, sensor_x + remaining))

            push!(result, (from, to))
        end
    end
    
    sort!(result)

    return result
end

function solve(input)
    for y in 0:bound
        values = calculate_values(input, y)

        x = 0

        for (from, to) in values
            if x > to
                continue
            end

            if x >= from 
                x = to+1
            else
                println(x * 4000000 + y)
                return
            end
        end

    end
end

main()