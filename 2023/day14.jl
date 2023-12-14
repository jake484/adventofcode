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

function moveOneTime(data, ::Val{T}) where {T}
    if T == 3
        reverse!(data, dims=1)
    elseif T == 4
        reverse!(data, dims=2)
    end
    type = T == 1 || T == 3 ? eachcol(data) : eachrow(data)
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
    if T == 3
        reverse!(data, dims=1)
    elseif T == 4
        reverse!(data, dims=2)
    end
    return 0
end

function partOne(data)
    moveOneTime(data, Val(1))
    return sum(x -> size(data, 1) - x.I[1] + 1, findall(x -> x == 'O', data))
end

function has_cycle(arr)
    for i in 1:length(arr)
        if arr == circshift(arr, i)
            return i
        end
    end
    return -1
end

function partTwo(data)
    arr = Int[]
    for _ in 1:200
        for i in 1:4
            moveOneTime(data, Val(i))
        end
        res = sum(x -> size(data, 1) - x.I[1] + 1, findall(x -> x == 'O', data))
        push!(arr, res)
    end
    len = 1
    str = join(arr)
    while len < length(arr)
        occursin(repeat(join(arr[101:101+len]), 2), str) && break
        len += 1
    end
    return arr[(1000000000-100)%(len+1)+100]
end

function day14_main()
    data = readData("data/2023/day14.txt", Val(14))
    return partOne(copy(data)), partTwo(data)
end

# test
# data = readData("data/2023/day14.txt", Val(14))
# day14_main()

using BenchmarkTools
@info "day14 性能："
@btime day14_main()


