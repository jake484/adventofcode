function readData(path, ::Val{17})
    data = readlines(path)
    maps = fill(0, length(data), length(data[1]))
    # convert vector to matrix
    for i ∈ eachindex(data)
        for j ∈ eachindex(data[i])
            maps[i, j] = parse(Int, data[i][j])
        end
    end
    return maps
end

const RIGHT = :R
const LEFT = :L
const STRAIGHT = :S

function getDirection(index, direction, turn::Symbol)
    if turn == RIGHT
        if direction == :R
            return index + CartesianIndex(1, 0), :D
        elseif direction == :D
            return index + CartesianIndex(0, -1), :L
        elseif direction == :L
            return index + CartesianIndex(-1, 0), :U
        else
            return index + CartesianIndex(0, 1), :R
        end
    elseif turn == LEFT
        if direction == :R
            return index + CartesianIndex(-1, 0), :U
        elseif direction == :U
            return index + CartesianIndex(0, -1), :L
        elseif direction == :L
            return index + CartesianIndex(1, 0), :D
        else
            return index + CartesianIndex(0, 1), :R
        end
    elseif turn == STRAIGHT
        if direction == :R
            return index + CartesianIndex(0, 1), :R
        elseif direction == :U
            return index + CartesianIndex(-1, 0), :U
        elseif direction == :L
            return index + CartesianIndex(0, -1), :L
        else
            return index + CartesianIndex(1, 0), :D
        end
    end
end

function search(maps, index, dic=Dict{CartesianIndex{2},Int}(), stepGone=0, direction=:R, END=last(CartesianIndices(maps)), hasGone=Tuple[])
    push!(hasGone, (index, direction))
    index == END && return maps[index]
    haskey(dic, index) && return dic[index]
    res = map((RIGHT, LEFT, STRAIGHT)) do turn
        nextIndex, nextDirection = getDirection(index, direction, turn)
        if nextIndex ∈ CartesianIndices(maps) && (nextIndex, nextDirection) ∉ hasGone
            if direction == nextDirection
                return stepGone > 2 ? typemax(Int32) : search(maps, nextIndex, dic, stepGone + 1, nextDirection, END, hasGone)
            else
                return search(maps, nextIndex, dic, 1, nextDirection, END, hasGone)
            end
        else
            return typemax(Int32)
        end
    end
    if all(>=(typemax(Int32)), res)
        println("index: $index, direction: $direction")
        display(hasGone)
    end
    res = res |> minimum
    dic[index] = res + maps[index]
    return dic[index]
end

function partOne(data)
    dic = Dict{CartesianIndex{2},Int}()
    search(data, CartesianIndex(1, 1), dic)
    res = zeros(Int, size(data))
    for (k, v) ∈ dic
        res[k] = v
    end
    display(res)
    return dic[CartesianIndex(1, 1)]
end

function partTwo(data)
    return 0
end

function day17_main()
    data = readData("data/2023/day17.txt", Val(17))
    return partOne(data), partTwo(data)
end

# test
data = readData("data/2023/day17.txt", Val(17))
# day17_main()

# using BenchmarkTools
# @info "day17 性能："
# @btime day17_main()

