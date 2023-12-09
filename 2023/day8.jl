function readData(path, ::Val{8})
    data = readlines(path)
    instructions = popfirst!(data)
    popfirst!(data)

    return instructions, Dict(
        map(data) do nodes
            nodes = match(r"([A-Z]+) = \(([A-Z]+), ([A-Z]+)\)", nodes).captures
            return String(nodes[1]) => (String(nodes[2]), String(nodes[3]))
        end
    )
end

function partOne(data, node="AAA")
    instructions, nodes = data
    len, ind = length(instructions), 1
    while node != "ZZZ"
        direction = instructions[mod1(ind, len)] == 'L' ? 1 : 2
        node = nodes[node][direction]
        ind += 1
    end
    return ind - 1
end

function partTwo(data)
    instructions, nodes = data
    len, ns = length(instructions), filter(x -> x[3] == 'A', keys(nodes) |> collect)
    inds = map(ns) do node
        ind = 1
        while node[3] != 'Z'
            direction = instructions[mod1(ind, len)] == 'L' ? 1 : 2
            node = nodes[node][direction]
            ind += 1
        end
        return ind - 1
    end
    return lcm(inds)
end

function day8_main()
    data = readData("data/2023/day8.txt", Val(8))
    return partOne(data), partTwo(data)
end

# test
# data = readData("data/2023/day8.txt", Val(8))
# day8_main()

using BenchmarkTools
@info "day8 性能："
@btime day8_main()

