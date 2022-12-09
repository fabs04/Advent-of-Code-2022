

function main()
    input = open("input") do file
        read(file, String)
    end

    for i in 1:length(input)
        if length(unique(first(input, 4))) == 4
            println(i+3)
            break
        end

        input = chop(input, head=1, tail=0)
    end
end

main()