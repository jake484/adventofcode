function readData(path, ::Val{14})
    data = readlines(path)
    maps = fill('.', length(data), length(data[1]))
    # convert vector to matrix
    for i in eachindex(data)
        for j in eachindex(data[i])
            data[i][j] != '.' && (maps[i, j] = data[i][j])
        end
    end
    return maps
end

function findToMove(col, index)
    toMove = index + 1
    while toMove < length(col) && col[toMove] != '.'
        toMove += 1
    end
    return toMove
end

function partOne(data, ::Val{T}) where {T}
    type = T == 1 || T == 3 ? eachcol(data) : eachrow(data)
    if T == 3
        reverse!(data, dims=1)
        reverse
    elseif T == 4
        reverse!(data, dims=2)
    end
    for col in type
        rock = 0
        toMove = findToMove(col, rock)
        for index in eachindex(col)
            if col[index] == '#'
                rock, toMove = index, findToMove(col, index)
            elseif col[index] == 'O' && toMove <= index
                col[index], col[toMove] = '.', 'O'
                toMove = findToMove(col, toMove)
            end
        end
    end
    return sum(x -> size(data, 1) - x.I[1] + 1, findall(x -> x == 'O', data))
end

function partTwo(data)
    return 0
end

function day14_main()
    data = readData("data/2023/day14.txt", Val(14))
    return partOne(data), partTwo(data)
end

# test
data = readData("data/2023/day14.txt", Val(14))
day14_main()

# using BenchmarkTools
# @info "day14 性能："
# @btime day14_main()

