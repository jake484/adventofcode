function readData(path, ::Val{21})
    data = readlines(path)
    maps = fill('.', length(data), length(data[1]))
    for i ∈ eachindex(data)
        for j ∈ eachindex(data[i])
            data[i][j] != '.' && (maps[i, j] = data[i][j])
        end
    end
    return maps
end

const ToN = CartesianIndex(-1, 0)
const ToS = CartesianIndex(1, 0)
const ToW = CartesianIndex(0, -1)
const ToE = CartesianIndex(0, 1)

function canGoIndices(index, maps)
    indices = CartesianIndex{2}[]
    for i in (index + ToN, index + ToS, index + ToW, index + ToE)
        i ∉ CartesianIndices(maps) && println("error: ", i)
        i ∈ CartesianIndices(maps) && maps[i] != '#' && push!(indices, i)
    end
    return indices
end

function search(maps, n, toSearch)
    for _ in 1:n
        markMaps = fill(false, size(maps))
        for i in toSearch
            map(i -> markMaps[i] = true, canGoIndices(i, maps))
        end
        toSearch = findall(markMaps)
    end
    return length(toSearch)
end

partOne(data) = search(data, 64, findall(==('S'), data))

function partTwo(data)
    return 0
end

function day21_main()
    data = readData("data/2023/day21.txt", Val(21))
    return partOne(data), partTwo(data)
end

# test
data = readData("data/2023/day21.txt", Val(21))
day21_main()

# map(x -> println(search(data, x, [CartesianIndex(1, 1)]), " "), 1:300);
# using BenchmarkTools
# @info "day21 性能："
# @btime day21_main()

