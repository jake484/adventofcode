const NORTH = CartesianIndex(-1, 0)
const SOUTH = CartesianIndex(1, 0)
const WEST = CartesianIndex(0, -1)
const EAST = CartesianIndex(0, 1)
# 读取数据
function readData(; path="data/2022/day24.txt")
    data = readlines(path)
    hight = length(data)
    width = length(data[1])
    blizzradMap = CartesianIndex{2}[]
    blizzradDirectionMap = CartesianIndex{2}[]
    for i in 2:hight-1
        for j in 2:width-1
            if data[i][j] != '.'
                push!(blizzradMap, CartesianIndex(i, j))
                if data[i][j] == '>'
                    push!(blizzradDirectionMap, EAST)
                elseif data[i][j] == '<'
                    push!(blizzradDirectionMap, WEST)
                elseif data[i][j] == '^'
                    push!(blizzradDirectionMap, NORTH)
                elseif data[i][j] == 'v'
                    push!(blizzradDirectionMap, SOUTH)
                end
            end
        end
    end
    wallMap = CartesianIndex{2}[]
    for i in 2:width-2
        push!(wallMap, CartesianIndex(hight, i))
    end
    startPos = CartesianIndex(1, findfirst('.', data[1]))
    endPos = CartesianIndex(hight, findfirst('.', data[end]))
    return blizzradMap, wallMap, blizzradDirectionMap, startPos, endPos, hight, width
end

function fixBlizzard!(blizzradMap::Vector{CartesianIndex{2}}, hight::Int, width::Int)
    for i in blizzradMap |> eachindex
        b = blizzradMap[i]
        if b.I[1] < 2
            blizzradMap[i] = CartesianIndex(hight - 1, b.I[2])
            continue
        elseif b.I[1] > hight - 1
            blizzradMap[i] = CartesianIndex(2, b.I[2])
            continue
        elseif b.I[2] < 2
            blizzradMap[i] = CartesianIndex(b.I[1], width - 1)
            continue
        elseif b.I[2] > width - 1
            blizzradMap[i] = CartesianIndex(b.I[1], 2)
            continue
        end
    end
end


function getCanMoveMap(blizzardMap::Vector{CartesianIndex{2}},
    blizzardDirectionMap::Vector{CartesianIndex{2}},
    startPos::CartesianIndex{2}, endPos::CartesianIndex{2},
    hight::Int, width::Int,
    time::Int=1000)
    canMoveList = Vector{CartesianIndex{2}}[]
    for _ in 1:time
        canMove = CartesianIndex{2}[]
        blizzardMap += blizzardDirectionMap
        fixBlizzard!(blizzardMap, hight, width)
        for j in 2:hight-1
            for k in 2:width-1
                if CartesianIndex(j, k) ∉ blizzardMap
                    push!(canMove, CartesianIndex(j, k))
                end
            end
        end
        push!(canMove, startPos)
        push!(canMove, endPos)
        push!(canMoveList, canMove)
    end
    return canMoveList
end

function getToGoPos(map::Vector{CartesianIndex{2}}, current::CartesianIndex{2})
    togo = [
        current + SOUTH,
        current + WEST,
        current,
        current + NORTH,
        current + EAST,
    ]
    filter!(x -> x ∈ map, togo)
    return togo
end

function move!(map::Vector{Vector{CartesianIndex{2}}},
    startPos::CartesianIndex{2}, endPos::CartesianIndex{2},
    hight::Int, width::Int, step::Int=1, box::Dict{Tuple,Int}=Dict{Tuple,Int}())
    
    step > length(map) && return typemax(Int16), startPos

    current = startPos
    togo = getToGoPos(map[step], current)

    if length(togo) == 0
        return typemax(Int16), current
    elseif length(togo) == 1
        togo[1] == endPos && return step, togo[1]
        return move!(map, togo[1], endPos, hight, width, step + 1, box)
    else
        tryMoves = Tuple{Int,CartesianIndex{2}}[]
        for pos in togo
            pos == endPos && return step, pos
            if haskey(box, (step, pos))
                push!(tryMoves, (box[(step, pos)], pos))
                continue
            else
                s, c = move!(map, pos, endPos, hight, width, step + 1, box)
                box[(step, pos)] = s
                push!(tryMoves, (s, c))
            end
        end
        s, index = findmin(first, tryMoves)
        step = s
        current = tryMoves[index][2]
        return step, current
    end
end

using BenchmarkTools
@btime begin
    blizzard, wall, direction, startPos, endPos, hight, width = readData()
    canMoveList = getCanMoveMap(blizzard, direction, startPos, endPos, hight, width)
    # Part One
    s, c = move!(canMoveList, startPos, endPos, hight, width)
    # Part Two
    s, c = move!(canMoveList, endPos, startPos, hight, width, s + 1)
    s, c = move!(canMoveList, startPos, endPos, hight, width, s + 1)
end
