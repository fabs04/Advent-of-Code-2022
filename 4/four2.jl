
open("input") do file
    result = 0

    for line in eachline(file)
        parts = split(line, ",")
        parts1 = split(parts[1], "-")
        parts2 = split(parts[2], "-")

        part1 = (parse(Int64, parts1[1]), parse(Int64, parts1[2]))
        part2 = (parse(Int64, parts2[1]), parse(Int64, parts2[2]))

        (a1,b1) = part1
        (a2,b2) = part2

        if !(b1 < a2 || a1 > b2 || b2 < a1 || a2 > b1)
            result += 1
        end
    end

    println(result)

end