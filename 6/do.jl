
open("in") do file
    for line in eachline(file)
        parts = split(line, " ")

        for part in parts
            if part != ""
                print("\"")
                print(part)
                println("\",")
            end
        end
    end
end