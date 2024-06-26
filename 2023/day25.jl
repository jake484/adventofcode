function readData(path, ::Val{25})
    data = Dict{String,Vector{String}}()
    components = Dict{String,Int}()
    no = 1
    for line in readlines(path)
        # println(line)
        name, lists = split(line, ": ")
        data[String(name)] = map(x -> String(x), split(lists, " "))
        if !haskey(components, String(name))
            components[String(name)] = no
            no += 1
        end
        for x in data[String(name)]
            if !haskey(components, x)
                components[x] = no
                no += 1
            end
        end
    end
    connections, vertices = data, components
    gp = SimpleGraph(length(vertices))
    for (k, v) in connections
        for x in v
            add_edge!(gp, vertices[k], vertices[x])
        end
    end
    return gp
end

using Graphs

function partOne(gp)
    es = collect(edges(gp))
    len = length(es)
    for i in 1:len
        e1 = es[i]
        rem_edge!(gp, e1)
        if length(connected_components(gp)) > 2
            add_edge!(gp, e1)
            continue
        end
        for j in i+1:len
            e2 = es[j]
            rem_edge!(gp, e2)
            if length(connected_components(gp)) > 2
                add_edge!(gp, e2)
                continue
            end
            for k in j+1:len
                e3 = es[k]
                rem_edge!(gp, e3)
                cc = connected_components(gp)
                if length(cc) == 2
                    prod(map(x -> length(x), cc)) |> println
                end
                add_edge!(gp, e3)
            end
            add_edge!(gp, e2)
        end
        add_edge!(gp, e1)
    end
    return 0
end

function partTwo(data)
    return 0
end

function day25_main()
    data = readData("data/2023/day25.txt", Val(25))
    return partOne(data), partTwo(data)
end

# test
data = readData("data/2023/day25.txt", Val(25))
day25_main()
