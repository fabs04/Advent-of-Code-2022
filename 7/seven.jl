
function main()
    commands::Array{Tuple{String, Array{String}}} = []

    open("input") do file
        command::String = ""
        answers::Array{String} = []
        first = true
        
        for line in eachline(file) 
            if line[1] == '\$'
                if command != "" && !first
                    push!(commands, (command, answers))
                end

                first = false                
                command = line
                answers = []
            else
                push!(answers, line)
            end
        end
    
        push!(commands, (command, answers))
    end
    
    root_directory = build_directory_tree(commands)
    calculate_sizes!(root_directory)

    println(calculate_sum(root_directory))
end

struct File
    name::String
    size::Int64
end

mutable struct Directory
    name::String
    children::Array{Directory}
    files::Array{File}
    size::Int64
    parent::Directory

    Directory(name, parent) = new(name, [], [], 0, parent)
    Directory(name) = new(name, [], [], 0)
end

function build_directory_tree(commands::Array{Tuple{String, Array{String}}})::Directory
    directories_by_name::Dict{String, Directory} = Dict()
    files_by_name = Dict()

    root = Directory("/")
    directories_by_name["/"] = root
    current_directory::Directory = root

    for (command, answers) in commands
        #println((command, answers))
        println(current_directory.name)

        command_parts = split(command, " ")

        if command_parts[2] == "cd"
            directory_name = command_parts[3]

            if directory_name == ".."
                current_directory = current_directory.parent
            elseif directory_name == "/"
                current_directory = directories_by_name[directory_name]
            else
                directory_name = current_directory.name * " - " * directory_name
                current_directory = directories_by_name[directory_name]
            end
        elseif command_parts[2] == "ls"
            for subdirectory in answers
                subdirectory_parts = split(subdirectory, " ")

                if subdirectory_parts[1] == "dir"
                    subdirectory_name = current_directory.name * " - " * subdirectory_parts[2]
                    if subdirectory_name in keys(directories_by_name)
                        directory = directories_by_name[subdirectory_name]
                    else
                        directory = Directory(current_directory.name * " - " * subdirectory_parts[2], current_directory)
                        push!(current_directory.children, directory)
                        directories_by_name[subdirectory_name] = directory
                    end
                else
                    size = parse(Int64, subdirectory_parts[1])
                    filename = current_directory.name * " - " *  subdirectory_parts[2]
                    file = File(filename, size)

                    if !(filename in keys(files_by_name))
                        push!(current_directory.files, file)
                        files_by_name[filename] = file
                    end
                end
            end
        end


    end

    return root
end

function calculate_sizes!(directory::Directory)
    size = 0

    for file in directory.files
        size += file.size
    end

    for subdir in directory.children
        size += calculate_sizes!(subdir)
    end

    directory.size = size

    return size
end 

function calculate_sum(directory::Directory)
    sum = 0

    if directory.size <= 100000
        sum += directory.size
    end

    for child in directory.children
        sum += calculate_sum(child)
    end

    return sum
end

main()

