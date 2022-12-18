using JuMP
using Gurobi
using DataFrames

struct Valve
    id::Int64
    name::String
    rate::Int64
    neighbors::Array{Valve}

    Valve(id, name, rate) = new(id, name, rate, [])
end

function main()
    valves = []
    valves_by_name = Dict()
    neighbors_by_name = Dict()

    open("input") do file
        id = 1
        for line in eachline(file)
            parts = split(line, "; ")
            flow_part = parts[1]

            if startswith(parts[2], "tunnels lead to valves ")
                chopstr = "tunnels lead to valves "
            else
                chopstr = "tunnel leads to valve "
            end

            neighbor_part = chop(parts[2], head=length(chopstr), tail=0)

            flow_parts = split(flow_part, " ")
            name = flow_parts[2]
            rate = parse(Int64, split(flow_parts[5], "=")[2])
            valve = Valve(id, name, rate)
            valves_by_name[name] = valve
            push!(valves, valve)
            id += 1

            neighbors = split(neighbor_part, ", ")
            neighbors_by_name[name] = neighbors
        end
    end

    for name in keys(valves_by_name)
        valve = valves_by_name[name]
        neighbors = neighbors_by_name[name]

        for neighbor in neighbors
            push!(valve.neighbors, valves_by_name[neighbor])
        end
    end

    solve(valves)
end

function solve(valves)
    model = Model(Gurobi.Optimizer)

    @variable(model, at[eachindex(valves), 1:26], Bin)
    @variable(model, elephant_at[eachindex(valves), 1:26], Bin)

    @variable(model, move_to[eachindex(valves), 1:26], Bin)
    @variable(model, elephant_move_to[eachindex(valves), 1:26], Bin)

    @variable(model, is_open[eachindex(valves), 1:26], Bin)

    @variable(model, open[eachindex(valves), 1:26], Bin)
    @variable(model, elephant_open[eachindex(valves), 1:26], Bin)

    @objective(
        model,
        Max,
        sum(is_open[v,t] * valves[v].rate for v in eachindex(valves), t in 1:26)
    )

    @constraint(model, at[1,1] == 1)
    @constraint(model, elephant_at[1,1] == 1)

    for v in eachindex(valves)
        @constraint(model, is_open[v,1] == 0)

        for t in 1:26
            @constraint(model, open[v,t] <= at[v,t])
            @constraint(model, elephant_open[v,t] <= elephant_at[v,t])
            
            if t < 26
                @constraint(model, move_to[v,t] <= at[v,t+1])
                @constraint(model, elephant_move_to[v,t] <= elephant_at[v,t+1])
            end

            @constraint(model, move_to[v,t] <= sum(at[n,t] for n in map(x -> x.id, valves[v].neighbors)))
            @constraint(model, elephant_move_to[v,t] <= sum(elephant_at[n,t] for n in map(x -> x.id, valves[v].neighbors)))

            if t > 1
                @constraint(model, is_open[v,t] <= sum(open[v,t2] + elephant_open[v,t2] for t2 in 1:t-1))

                @constraint(model, open[v,t] <= move_to[v,t-1])
                @constraint(model, elephant_open[v,t] <= elephant_move_to[v,t-1])

                @constraint(model, at[v,t-1] <= at[v,t] + sum(move_to[v1,t-1] for v1 in eachindex(valves)))
                @constraint(model, elephant_at[v,t-1] <= elephant_at[v,t] + sum(elephant_move_to[v1,t-1] for v1 in eachindex(valves)))
                
                @constraint(model, move_to[v,t-1] <= at[v,t])
                @constraint(model, elephant_move_to[v,t-1] <= elephant_at[v,t])
            end
        end
    end

    for t in 1:26
        @constraint(model, sum(at[v,t] for v in eachindex(valves)) == 1)
        @constraint(model, sum(elephant_at[v,t] for v in eachindex(valves)) == 1)

        @constraint(model, sum(move_to[v,t] + open[v,t] for v in eachindex(valves)) == 1)
        @constraint(model, sum(elephant_move_to[v,t] + elephant_open[v,t] for v in eachindex(valves)) == 1)
        
    end

    optimize!(model)
    solution_summary(model)
end

main()