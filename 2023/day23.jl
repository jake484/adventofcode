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

function canSearch(maps, pos, nextPos, ::Val{1})
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

canSearch(maps, pos, nextPos, ::Val{2}) = maps[nextPos] != '#'


function getNeighbours(maps, hasGone, pos, ::Val{T}) where {T}
    neighbours = [pos + ToN, pos + ToS, pos + ToW, pos + ToE]
    return filter(i -> checkbounds(Bool, maps, i) && !hasGone[i] && canSearch(maps, pos, i, Val(T)), neighbours)
end

function search(maps, hasGone, dic, pos, END, ::Val{1})
    haskey(dic, pos) && dic[pos] > 0 && return dic[pos]
    pos == END && (return 0)
    hasGone[pos] = true
    neighbours = getNeighbours(maps, hasGone, pos, Val(1))
    isempty(neighbours) && (hasGone[pos] = false; return typemin(Int))
    dic[pos] = maximum(x -> search(maps, hasGone, dic, x, END, Val(1)), neighbours) + 1
    hasGone[pos] = false
    return dic[pos]
end

function search(maps, hasGone, dic, pos, END, ::Val{2})
    haskey(dic, pos) && dic[pos] > 0 && return dic[pos]
    pos == END && (return 0)
    hasGone[pos] = true
    neighbours = getNeighbours(maps, hasGone, pos, Val(2))
    indices = CartesianIndex{2}[]
    while length(neighbours) <= 1
        haskey(dic, pos) && dic[pos] > 0 && break
        pos == END && (break)
        if isempty(neighbours)
            hasGone[pos] = false
            hasGone[indices] .= false
            return typemin(Int)
        end
        push!(indices, pos)
        pos = neighbours[1]
        hasGone[pos] = true
        neighbours = getNeighbours(maps, hasGone, pos, Val(2))
    end
    if length(neighbours) > 1
        println("here")
        dic[pos] = maximum(x -> search(maps, hasGone, dic, x, END, Val(2)), neighbours) + 1
    elseif pos == END
        dic[pos] = 0
    end
    hasGone[pos] = false
    while !isempty(indices)
        index = pop!(indices)
        (haskey(dic, index) && dic[index] > 0) || (dic[index] = dic[pos] + 1)
        (haskey(dic, index) && dic[index] > 0) || (hasGone[index] = false)
        pos = index
    end
    return dic[pos]
end

# function search(maps, hasGone, dic, pos, END, ::Val{3})
#     pos == END && (return 0)
#     hasGone[pos] = true
#     neighbours = getNeighbours(maps, hasGone, pos, Val(2))
#     indices = CartesianIndex{2}[]
#     while length(neighbours) <= 1
#         if isempty(neighbours)
#             hasGone[pos] = false
#             hasGone[indices] .= false
#             return typemin(Int)
#         end
#         push!(indices, pos)
#         pos = neighbours[1]
#         hasGone[pos] = true
#         if pos == END
#             hasGone[pos] = false
#             hasGone[indices] .= false
#             return length(indices)
#         end
#         neighbours = getNeighbours(maps, hasGone, pos, Val(2))
#     end
#     m = maximum(x -> search(maps, hasGone, dic, x, END, Val(3)), neighbours) + 1
#     hasGone[indices] .= false
#     hasGone[pos] = false
#     return m + length(indices)
# end


function partOne(data)
    maps, s, e = data
    dic = Dict{CartesianIndex{2},Int}()
    res = search(maps, falses(size(maps)), dic, s, e, Val(1))
    # display(dic)
    # fs = zeros(Int, size(maps))
    # for (k, v) in dic
    #     fs[k] = v
    # end
    # display(fs)
    return res
end

function partTwo(data)
    maps, s, e = data
    dic = Dict{CartesianIndex{2},Int}()
    res = search(maps, falses(size(maps)), dic, s, e, Val(2))
    # display(dic)
    fs = fill(-1, size(maps))
    for (k, v) in dic
        fs[k] = v
    end
    display(fs)
    return res
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

