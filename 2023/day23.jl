function readData(path, ::Val{23})
    data = readlines(path)
    maps = fill('.', length(data), length(data[1]))
    s, e = CartesianIndex(1, 1), CartesianIndex(length(data), length(data[1]))
    for i ∈ eachindex(data)
        for j ∈ eachindex(data[i])
            i == 1 && data[i][j] == '.' && (s = CartesianIndex(i, j))
            i == lastindex(data) && data[i][j] == '.' && (e = CartesianIndex(i, j))
            data[i][j] != '.' && (maps[i, j] = data[i][j])
        end
    end
    return maps, s, e
end

const ToN = CartesianIndex(-1, 0)
const ToS = CartesianIndex(1, 0)
const ToW = CartesianIndex(0, -1)
const ToE = CartesianIndex(0, 1)

function canSearch(maps, pos, nextPos)
    maps[nextPos] == '#' && return false
    if maps[pos] == '>'
        return nextPos == pos + ToE
    elseif maps[pos] == '<'
        return nextPos == pos + ToW
    elseif maps[pos] == '^'
        return nextPos == pos + ToN
    elseif maps[pos] == 'v'
        return nextPos == pos + ToS
    else
        return true
    end
end

function getNeighbours(maps, hasGone, pos)
    neighbours = (pos + ToN, pos + ToS, pos + ToW, pos + ToE)
    return filter(i -> checkbounds(Bool, maps, i) && !hasGone[i] && canSearch(maps, pos, i), neighbours)
end

function search(maps, hasGone, dic, pos, END)
    haskey(dic, pos) && return dic[pos]
    pos == END && (return 0)
    hasGone[pos] = true
    neighbours = getNeighbours(maps, hasGone, pos)
    isempty(neighbours) && (hasGone[pos] = false; return typemin(Int))
    dic[pos] = maximum(x -> search(maps, hasGone, dic, x, END), neighbours) + 1
    hasGone[pos] = false
    return dic[pos]
end

function partOne(data)
    maps, s, e = data
    return search(maps, falses(size(maps)), Dict(), s, e)
end

function partTwo(data)
    return 0
end

function day23_main()
    data = readData("data/2023/day23.txt", Val(23))
    return partOne(data), partTwo(data)
end

# test
data = readData("data/2023/day23.txt", Val(23))
day23_main()

# using BenchmarkTools
# @info "day23 性能："
# @btime day23_main()

