function readData(path, ::Val{2})
    data = Vector{String}[]
    for str in eachline(path)
        push!(data, map(string, split(str, c -> c == ':' || c == ';'))[2:end])
    end
    return data
end

function isVaildCube(cubes)
    for cube in cubes
        num = parse(Int, match(r"(\d+)", cube).match)
        ((occursin("green", cube) && num > 13) || (occursin("red", cube) && num > 12) || (occursin("blue", cube) && num > 14)) && return false
    end
    return true
end

isVaildCubes(strs) = all(str -> isVaildCube(map(strip, split(str, ','))), strs)

function partOne(data)
    s = 0
    for ind in eachindex(data)
        isVaildCubes(data[ind]) && (s += ind)
    end
    return s
end

function findMaxCubes(strs)
    red = green = blue = 0
    for str in strs
        for cube in map(strip, split(str, ','))
            num = parse(Int, match(r"(\d+)", cube).match)
            occursin("red", cube) && (red = max(red, num))
            occursin("green", cube) && (green = max(green, num))
            occursin("blue", cube) && (blue = max(blue, num))
        end
    end
    return red * green * blue
end

function partTwo(data)
    s = 0
    for ind in eachindex(data)
        s += findMaxCubes(data[ind])
    end
    return s
end

function day2_main()
    data = readData("data/2023/day2.txt", Val(2))
    return partOne(data), partTwo(data)
end

# test
# data = readData("data/2023/day2.txt", Val(2))
# isVaildCube(map(strip, split(data[4][1], ',')))
# day2_main()

using BenchmarkTools
@info "day2 性能："
@btime day2_main()

