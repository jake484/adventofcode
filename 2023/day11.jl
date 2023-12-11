function readData(path, ::Val{11})
    data = readlines(path)
    maps = fill('.', length(data), length(data[1]))
    # convert vector to matrix
    for i in eachindex(data)
        for j in eachindex(data[i])
            data[i][j] != '.' && (maps[i, j] = data[i][j])
        end
    end
    emptyRow = findall(x -> allequal(maps[x, :]), 1:size(maps, 1))
    emptyCol = findall(x -> allequal(maps[:, x]), 1:size(maps, 2))
    return emptyRow, emptyCol, findall(==('#'), maps)
end

getDistances(index::CartesianIndex) = sum(abs, index.I)

function expandNum(time, emptyNums, num)
    for i in eachindex(emptyNums)
        if num < emptyNums[i]
            return num + (time - 1) * (i - 1)
        end
    end
    return num + (time - 1) * (length(emptyNums))
end

function expand(time, emptyRow, emptyCol, indices)
    newIndices = CartesianIndex[]
    for index in indices
        row, col = index.I
        row = expandNum(time, emptyRow, row)
        col = expandNum(time, emptyCol, col)
        push!(newIndices, CartesianIndex(row, col))
    end
    return newIndices
end

function partOne(data, time=2)
    emptyRow, emptyCol, indices = data
    newind = expand(time, emptyRow, emptyCol, indices)
    l, s = length(newind), 0
    for i in 1:l
        for j in i+1:l
            s += getDistances(newind[i] - newind[j])
        end
    end
    return s
end

function day11_main()
    data = readData("data/2023/day11.txt", Val(11))
    return partOne(data), partOne(data, 1000000)
end

# test
# data = readData("data/2023/day11.txt", Val(11))
# day11_main()

using BenchmarkTools
@info "day11 性能："
@btime day11_main()

