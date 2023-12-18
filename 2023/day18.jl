function readData(path, ::Val{18})
    data = readlines(path)
    return map(data) do x
        direction, distance, rgb = split(x)
        return Symbol(direction), parse(Int, distance), rgb[3:8]
    end
end

using Meshes

getDirection(::Val{:R}) = CartesianIndex(0, 1)
getDirection(::Val{:L}) = CartesianIndex(0, -1)
getDirection(::Val{:U}) = CartesianIndex(-1, 0)
getDirection(::Val{:D}) = CartesianIndex(1, 0)

getDirection(::Val{0}) = CartesianIndex(0, 1)
getDirection(::Val{2}) = CartesianIndex(0, -1)
getDirection(::Val{3}) = CartesianIndex(-1, 0)
getDirection(::Val{1}) = CartesianIndex(1, 0)

function partOne(data)
    indices = [CartesianIndex(1, 1)]
    for (direction, distance, _) in data
        push!(indices, indices[end] + getDirection(Val(direction)) * distance)
    end
    pop!(indices)
    rings = Ring([index.I for index in indices])
    return measure(PolyArea(rings)) + measure(rings) / 2 + 1 |> Int
end

function partTwo(data)
    indices = [CartesianIndex(1, 1)]
    for (_, _, rgb) in data
        push!(indices, indices[end] + getDirection(Val(rgb[6] - '0')) * parse(Int, rgb[1:5], base=16))
    end
    pop!(indices)
    rings = Ring([index.I for index in indices])
    # 
    return measure(PolyArea(rings)) + measure(rings) / 2 + 1 |> Int
end

function day18_main()
    data = readData("data/2023/day18.txt", Val(18))
    return partOne(data), partTwo(data)
end

# test
# data = readData("data/2023/day18.txt", Val(18))
# day18_main()

using BenchmarkTools
@info "day18 性能："
@btime day18_main()
