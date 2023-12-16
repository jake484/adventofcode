function readData(path, ::Val{16})
    data = readlines(path)
    maps = fill('.', length(data), length(data[1]))
    # convert vector to matrix
    for i ∈ eachindex(data)
        for j ∈ eachindex(data[i])
            data[i][j] != '.' && (maps[i, j] = data[i][j])
        end
    end
    return maps
end

const ToN = CartesianIndex(-1, 0)
const ToS = CartesianIndex(1, 0)
const ToW = CartesianIndex(0, -1)
const ToE = CartesianIndex(0, 1)
const END = CartesianIndex(0, 0)

function findNext(data, index, indices, ::Val{:N})
    d = []
    if index + ToN ∈ indices
        if data[index+ToN] ∈ ('.', '|')
            d = [:N]
        elseif data[index+ToN] == '/'
            d = [:E]
        elseif data[index+ToN] == '\\'
            d = [:W]
        elseif data[index+ToN] == '-'
            d = [:E, :W]
        end
    else
        d = [:END]
    end
    return index + ToN, d
end

function findNext(data, index, indices, ::Val{:S})
    if index + ToS ∈ indices
        if data[index+ToS] ∈ ('.', '|')
            d = [:S]
        elseif data[index+ToS] == '/'
            d = [:W]
        elseif data[index+ToS] == '\\'
            d = [:E]
        elseif data[index+ToS] == '-'
            d = [:E, :W]
        end
    else
        d = [:END]
    end
    return index + ToS, d
end

function findNext(data, index, indices, ::Val{:W})
    if index + ToW ∈ indices
        if data[index+ToW] ∈ ('.', '-')
            d = [:W]
        elseif data[index+ToW] == '/'
            d = [:S]
        elseif data[index+ToW] == '\\'
            d = [:N]
        elseif data[index+ToW] == '|'
            d = [:N, :S]
        end
    else
        d = [:END]
    end
    return index + ToW, d
end

function findNext(data, index, indices, ::Val{:E})
    if index + ToE ∈ indices
        if data[index+ToE] ∈ ('.', '-')
            d = [:E]
        elseif data[index+ToE] == '/'
            d = [:N]
        elseif data[index+ToE] == '\\'
            d = [:S]
        elseif data[index+ToE] == '|'
            d = [:N, :S]
        end
    else
        d = [:END]
    end
    return index + ToE, d
end


function partOne(data, balls=[(CartesianIndex(1, 0), :E)])
    indices = CartesianIndices(data)
    hasGone = zeros(Int8, size(data))
    hasGoneBall = Tuple{CartesianIndex{2},Symbol}[]
    while !isempty(balls)
        index, direction = pop!(balls)
        startPos = (index, direction)
        startPos ∈ hasGoneBall && continue
        while true
            nextIndex, direction = findNext(data, index, indices, Val(direction))
            direction[1] == :END && break
            hasGone[nextIndex] = 1
            if length(direction) > 1
                for d ∈ direction
                    toCheck = (nextIndex, d)
                    toCheck ∉ hasGoneBall && push!(balls, toCheck)
                end
                break
            else
                toCheck = (nextIndex, direction[1])
                startPos == toCheck && break
                index, direction = toCheck
            end
        end
        push!(hasGoneBall, startPos)
    end
    return sum(hasGone)
end

# function search(data, startPos, hasGoneBall=Tuple{CartesianIndex{2},Symbol}[], dic=Dict{Tuple{CartesianIndex{2},Symbol},Int}(), startSteps=1, hasGone=zeros(Int8, size(data)))
#     haskey(dic, startPos) && return dic[startPos], 0
#     index, direction = startPos
#     nextIndex, direction = findNext(data, index, CartesianIndices(data), Val(direction))
#     if direction[1] == :END
#         dic[startPos] = 1
#         return dic[startPos], 0
#     elseif length(direction) > 1
#         toCheck1 = (nextIndex, direction[1])
#         toCheck2 = (nextIndex, direction[2])
#         newGone1 = zeros(Int8, size(data))
#         newGone2 = zeros(Int8, size(data))
#         for (check, gone) in zip((toCheck1, toCheck2), (newGone1, newGone2))
#             if check ∈ hasGoneBall
#                 dic[check] = startSteps
#                 gone[check[1]] = 1
#                 return startSteps, 1
#             else
#                 push!(hasGoneBall, check)
#                 s, iss = search(data, check, hasGoneBall, dic, 1, gone)
#                 dic[check] = iss == 1 ? s : s + 1
#                 gone[check[1]] = 1
#             end
#         end
#         hasGone[nextIndex] = 1
#         newGone = newGone1 .| newGone2
#         dic[startPos] = count(>(0), newGone)
#         for i in CartesianIndices(data)
#             hasGone[i] = newGone[i] | hasGone[i]
#         end
#         return dic[startPos], 0
#     else
#         s, iss = search(data, (nextIndex, direction[1]), hasGoneBall, dic, startSteps + 1, hasGone)
#         hasGone[nextIndex] = 1
#         dic[startPos] = iss == 1 ? s : count(>(0), hasGone)
#         return dic[startPos], iss
#     end
# end

function search(data, startPos, hasGoneBall=Tuple{CartesianIndex{2},Symbol}[], dic=Dict{Tuple{CartesianIndex{2},Symbol},Int}(), startSteps=1, hasGone=zeros(Int8, size(data)))
    haskey(dic, startPos) && return dic[startPos], 0
    index, direction = startPos
    nextIndex, direction = findNext(data, index, CartesianIndices(data), Val(direction))
    if direction[1] == :END
        dic[startPos] = 1
        return dic[startPos], 0
    elseif length(direction) > 1
        toCheck1 = (nextIndex, direction[1])
        toCheck2 = (nextIndex, direction[2])
        newGone1 = zeros(Int8, size(data))
        newGone2 = zeros(Int8, size(data))
        for (check, gone) in zip((toCheck1, toCheck2), (newGone1, newGone2))
            if check ∈ hasGoneBall
                dic[check] = startSteps
                gone[check[1]] = 1
                return startSteps, 1
            else
                push!(hasGoneBall, check)
                s, iss = search(data, check, hasGoneBall, dic, 1, gone)
                dic[check] = iss == 1 ? s : s + 1
                gone[check[1]] = 1
            end
        end
        hasGone[nextIndex] = 1
        newGone = newGone1 .| newGone2
        dic[startPos] = count(>(0), newGone)
        for i in CartesianIndices(data)
            hasGone[i] = newGone[i] | hasGone[i]
        end
        return dic[startPos], 0
    else
        s, iss = search(data, (nextIndex, direction[1]), hasGoneBall, dic, startSteps + 1, hasGone)
        hasGone[nextIndex] = 1
        dic[startPos] = iss == 1 ? s : count(>(0), hasGone)
        return dic[startPos], iss
    end
end

function partTwo(data)
    edges = reduce(vcat, [
        [(CartesianIndex(i, 0), :E) for i in 1:size(data, 1)],
        [(CartesianIndex(i, size(data, 2)), :W) for i in 1:size(data, 1)],
        [(CartesianIndex(0, i), :S) for i in 1:size(data, 2)],
        [(CartesianIndex(size(data, 1), i), :N) for i in 1:size(data, 2)]
    ])
    return maximum(x -> partOne(data, [x]), edges)
end

function partT2(data)
    dic = Dict{Tuple{CartesianIndex{2},Symbol},Int}()
    edges = reduce(vcat, [
        [(CartesianIndex(i, 0), :E) for i in 1:size(data, 1)],
        [(CartesianIndex(i, size(data, 2)), :W) for i in 1:size(data, 1)],
        [(CartesianIndex(0, i), :S) for i in 1:size(data, 2)],
        [(CartesianIndex(size(data, 1), i), :N) for i in 1:size(data, 2)]
    ])
    # find maximum
    m = 0
    for x in edges
        s, iss = search(data, x, Tuple{CartesianIndex{2},Symbol}[], dic)
        m = max(m, s)
    end
    display(dic)
    return m
end

function day16_main()
    data = readData("data/2023/day16.txt", Val(16))
    return partOne(data), partTwo(data)
end

# test
data = readData("data/2023/day16.txt", Val(16))
day16_main()

# function test()
#     edges = reduce(vcat, [
#         [(CartesianIndex(i, 0), :E) for i in 1:size(data, 1)],
#         [(CartesianIndex(i, size(data, 2)), :W) for i in 1:size(data, 1)],
#         [(CartesianIndex(0, i), :S) for i in 1:size(data, 2)],
#         [(CartesianIndex(size(data, 1), i), :N) for i in 1:size(data, 2)]
#     ])
#     tocheck = Tuple{CartesianIndex{2},Symbol}[]
#     for x in edges
#         if search(data, x)[1] != partOne(data, [x])
#             push!(tocheck, x)
#         end
#     end
#     for x in tocheck
#         println("search: ", search(data, x)[1], " partOne: ", partOne(data, [x]))
#     end
# end
# test()
using BenchmarkTools
@info "day16 性能："
@btime day16_main()
# @time partT2(data)
