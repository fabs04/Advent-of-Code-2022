

function main()
    input = open("input") do file
        read(file, String)
    end

    for i in 1:length(input)
        if length(unique(first(input, 14))) == 14
            println(i+13)
            break
        end

        input = chop(input, head=1, tail=0)
    end
end

main()