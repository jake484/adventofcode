function readData(path, ::Val{3})
    data = readlines(path)
    maps = fill('.', length(data), length(data[1]))
    # convert vector to matrix
    for i in eachindex(data)
        for j in eachindex(data[i])
            maps[i, j] = data[i][j]
        end
    end
    return maps
end

function getVaildMap(data, row, i, j)
    top = left = right = bottom = 0
    if row == 1
        top, bottom = 1, 2
    elseif row == lastindex(data, 1)
        top, bottom = row - 1, row
    else
        top, bottom = row - 1, row + 1
    end
    i == 1 ? (left = 1) : (left = i - 1)
    j == lastindex(data, 2) ? (right = j) : (right = j + 1)
    return data[top:bottom, left:right]
end

function partOne(data)
    su = 0
    for row in axes(data, 1)
        lastind = lastindex(data, 2)
        col = 1
        s = e = 0
        while col <= lastind
            if isdigit(data[row, col])
                s == e && (s = col)
            else
                if s != e
                    e = col - 1
                    su += any(x -> !(isdigit(x) || x == '.'), getVaildMap(data, row, s, e)) ? parse(Int, join(data[row, s:e])) : 0
                    s = e = col
                end
            end
            col += 1
        end
        if s != e
            e = col - 1
            su += any(x -> !(isdigit(x) || x == '.'), getVaildMap(data, row, s, e)) ? parse(Int, join(data[row, s:e])) : 0
            s = e = col
        end
    end
    return su
end

function getVaildIndices(data, row, i, j)
    top = left = right = bottom = 0
    if row == 1
        top, bottom = 1, 2
    elseif row == lastindex(data, 1)
        top, bottom = row - 1, row
    else
        top, bottom = row - 1, row + 1
    end
    i == 1 ? (left = 1) : (left = i - 1)
    j == lastindex(data, 2) ? (right = j) : (right = j + 1)
    return CartesianIndices((top:bottom, left:right))
end

function partTwo(data)
    target = Dict{CartesianIndex{2},Vector{Int}}()
    for row in axes(data, 1)
        lastind = lastindex(data, 2)
        col = 1
        s = e = 0
        while col <= lastind
            if isdigit(data[row, col])
                s == e && (s = col)
            else
                if s != e
                    e = col - 1
                    indices = filter(ind -> data[ind] == ('*'), getVaildIndices(data, row, s, e))
                    for index in indices
                        if haskey(target, index)
                            push!(target[index], parse(Int, join(data[row, s:e])))
                        else
                            target[index] = [parse(Int, join(data[row, s:e]))]
                        end
                    end
                    s = e = col
                end
            end
            col += 1
        end
        if s != e
            e = col - 1
            indices = filter(ind -> data[ind] == ('*'), getVaildIndices(data, row, s, e))
            for index in indices
                if haskey(target, index)
                    push!(target[index], parse(Int, join(data[row, s:e])))
                else
                    target[index] = [parse(Int, join(data[row, s:e]))]
                end
            end
            s = e = col
        end
    end
    return sum(target) do (k, v)
        length(v) == 2 ? prod(v) : 0
    end
end

function day3_main()
    data = readData("data/2023/day3.txt", Val(3))
    return partOne(data), partTwo(data)
end

# test
# data = readData("data/2023/day3.txt", Val(3))
# day3_main()

using BenchmarkTools
@info "day3 性能："
@btime day3_main()

