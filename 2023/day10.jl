function readData(path, ::Val{10})
    data = readlines(path)
    maps = fill('.', length(data), length(data[1]))
    # convert vector to matrix
    for i in eachindex(data)
        for j in eachindex(data[i])
            maps[i, j] = data[i][j]
        end
    end
    return maps, findfirst(==('S'), maps)
end

const ToN = CartesianIndex(-1, 0)
const ToS = CartesianIndex(1, 0)
const ToW = CartesianIndex(0, -1)
const ToE = CartesianIndex(0, 1)
const END = CartesianIndex(0, 0)

function findNext(data, index, indices, ::Val{:|})
    (index + ToN in indices && data[index+ToN] == -1) && return index + ToN
    (index + ToS in indices && data[index+ToS] == -1) && return index + ToS
    return END
end

function findNext(data, index, indices, ::Val{:F})
    (index + ToE in indices && data[index+ToE] == -1) && return index + ToE
    (index + ToS in indices && data[index+ToS] == -1) && return index + ToS
    return END
end

function findNext(data, index, indices, ::Val{:J})
    (index + ToN in indices && data[index+ToN] == -1) && return index + ToN
    (index + ToW in indices && data[index+ToW] == -1) && return index + ToW
    return END
end

function findNext(data, index, indices, ::Val{:L})
    (index + ToN in indices && data[index+ToN] == -1) && return index + ToN
    (index + ToE in indices && data[index+ToE] == -1) && return index + ToE
    return END
end


function findNext(data, index, indices, ::Val{:-})
    (index + ToE in indices && data[index+ToE] == -1) && return index + ToE
    (index + ToW in indices && data[index+ToW] == -1) && return index + ToW
    return END
end

function findNext(data, index, indices, ::Val{Symbol("7")})
    (index + ToW in indices && data[index+ToW] == -1) && return index + ToW
    (index + ToS in indices && data[index+ToS] == -1) && return index + ToS
    return END
end

findNext(data, index, indices, ::Val{:.}) = END
findNext(data, index, indices, ::Val{:S}) = END

function findNext(data, index, indices)
    E, N, S, W = (index + ToE, index + ToN, index + ToS, index + ToW)
    canN = ('7', '|', 'F')
    canE = ('-', 'J', '7')
    canW = ('-', 'L', 'F')
    canS = ('|', 'J', 'L')
    if N in indices && data[N] in canN && S in indices && data[S] in canS
        return [N, S]
    elseif N in indices && data[N] in canN && E in indices && data[E] in canE
        return [N, E]
    elseif N in indices && data[N] in canN && W in indices && data[W] in canW
        return [N, W]
    elseif S in indices && data[S] in canS && E in indices && data[E] in canE
        return [S, E]
    elseif S in indices && data[S] in canW && W in indices && data[W] in canW
        return [S, W]
    elseif E in indices && data[E] in canE && W in indices && data[W] in canW
        return [E, W]
    end
    return [END]
end

function partOne(data)
    maps, start = data
    indices = CartesianIndices(maps)
    starts = findNext(maps, start, indices)
    records = [fill(-1, size(maps, 1), size(maps, 2)) for _ in eachindex(starts)]
    for record in records
        record[start] = 0
    end
    for (record, index) in zip(records, starts)
        step = 1
        while index != END
            record[index] = step
            step += 1
            index = findNext(record, index, indices, Val(Symbol(maps[index])))
        end
    end
    steps = fill(0, size(maps, 1), size(maps, 2))
    for index in eachindex(maps)
        if all(x -> x[index] > -1, records)
            steps[index] = minimum(x -> x[index], records)
        else
            steps[index] = maximum(x -> x[index], records)
        end
    end
    return maximum(steps)
end

function partTwo(data)
    return 0
end

function day10_main()
    data = readData("data/2023/day10.txt", Val(10))
    return partOne(data), partTwo(data)
end

# test
data = readData("data/2023/day10.txt", Val(10))
day10_main()

# using BenchmarkTools
# @info "day10 性能："
# @btime day10_main()

