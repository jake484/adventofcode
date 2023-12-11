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
    ps = Vector{CartesianIndex{2}}[]
    if N in indices && data[N] in canN && S in indices && data[S] in canS
        push!(ps, [N, S])
    elseif N in indices && data[N] in canN && E in indices && data[E] in canE
        push!(ps, [N, E])
    elseif N in indices && data[N] in canN && W in indices && data[W] in canW
        push!(ps, [N, W])
    elseif S in indices && data[S] in canS && E in indices && data[E] in canE
        push!(ps, [S, E])
    elseif S in indices && data[S] in canW && W in indices && data[W] in canW
        push!(ps, [S, W])
    elseif E in indices && data[E] in canE && W in indices && data[W] in canW
        push!(ps, [E, W])
    end
    return ps
end

function getSteps(data)
    maps, start = data
    indices = CartesianIndices(maps)
    starts = findNext(maps, start, indices)[1]
    records = [fill(-1, size(maps, 1), size(maps, 2)) for _ in eachindex(starts)]
    for record in records
        record[start] = 0
    end
    stepIndex, addstepindex = [start], true
    for (record, index) in zip(records, starts)
        step = 1
        while index != END
            addstepindex && push!(stepIndex, index)
            record[index] = step
            step += 1
            index = findNext(record, index, indices, Val(Symbol(maps[index])))
        end
        addstepindex = false
    end
    steps = fill(-1, size(maps, 1), size(maps, 2))
    for index in eachindex(maps)
        if all(x -> x[index] > -1, records)
            steps[index] = minimum(x -> x[index], records)
        else
            steps[index] = maximum(x -> x[index], records)
        end
    end
    return steps, stepIndex
end

function partOne(steps)
    return maximum(steps)
end

function findRing(maps, start, hasSearched)
    indices = CartesianIndices(maps)
    index = findNext(hasSearched, start, indices, Val(Symbol(maps[start])))
    if index == END
        hasSearched[start] = 1
        return CartesianIndex{2}[]
    else
        for _ in 1:2
            stepIndex = [start]
            while !(index == END || index == start)
                push!(stepIndex, index)
                hasSearched[index] = 1
                index = findNext(hasSearched, index, indices, Val(Symbol(maps[index])))
            end
            if index == start
                hasSearched[index] = 1
                return length(stepIndex) > 4 ? stepIndex : CartesianIndex{2}[]
            end
        end
        return CartesianIndex{2}[]
    end
end

using Meshes

function partTwo(maps, steps, stepIndex)
    rings = [stepIndex]
    newSteps = copy(steps)
    indices = CartesianIndices(maps)
    for ind in indices
        if steps[ind] == -1 && maps[ind] != '.'
            r = findRing(maps, ind, steps)
            !isempty(r) && push!(rings, r)
            newSteps[r] .= 1
        end
    end
    toSearchs = filter(x -> newSteps[x] == -1, indices)
    areas = map(x -> PolyArea([Point(index.I) for index in x]), rings)
    return sum(toSearchs) do index
        return any(area -> Point(index.I) in area, areas) ? 1 : 0
    end
end

function day10_main()
    data = readData("data/2023/day10.txt", Val(10))
    steps, stepIndex = getSteps(data)
    return partOne(steps), partTwo(data[1], copy(steps), stepIndex)
end

using BenchmarkTools
@info "day10 性能："
@btime day10_main()

