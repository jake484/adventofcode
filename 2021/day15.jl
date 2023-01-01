using DataStructures

function readData(path="data/2021/day15.txt")
    data = readlines(path)
    s = (length(data), length(data[1]))
    caveMap = zeros(Int8, s...)
    for i in eachindex(data)
        for j in eachindex(data[i])
            caveMap[i, j] = data[i][j] - '0'
        end
    end
    startPos = CartesianIndex(s...)
    endPos = CartesianIndex(1, 1)
    return caveMap, startPos, endPos
end

const directions = (CartesianIndex(0, 1), CartesianIndex(1, 0), CartesianIndex(0, -1), CartesianIndex(-1, 0))

getNeighbours(riskMap::Matrix{Int}, current::CartesianIndex) = (current + x for x in directions if checkbounds(Bool, riskMap, current + x) && riskMap[current+x] == 0)

function addNum(caveMap::Matrix{Int8}, num::Int8)
    caveMap = copy(caveMap)
    for i in eachindex(caveMap)
        caveMap[i] = mod1(caveMap[i] + num, 9)
    end
    return caveMap
end

function expandMap(caveMap::Matrix{Int8})
    caveMap = reduce(hcat, addNum(caveMap, Int8(i)) for i in 1:4; init=caveMap)
    caveMap = reduce(vcat, addNum(caveMap, Int8(i)) for i in 1:4; init=caveMap)
    return caveMap
end

function getShortestPath(caveMap::Matrix{Int8}, start::CartesianIndex, goal::CartesianIndex)
    frontier = PriorityQueue{CartesianIndex{2},Int}(Base.Order.Forward)
    riskMap = zeros(Int, size(caveMap)...)
    riskMap[start] = caveMap[start]
    current = start
    for n in getNeighbours(riskMap, current)
        riskMap[n] = caveMap[n] + riskMap[current]
        enqueue!(frontier, n, riskMap[n])
    end
    while !isempty(frontier)
        current = dequeue!(frontier)
        for n in getNeighbours(riskMap, current)
            n == goal && return riskMap[current]
            riskMap[n] = caveMap[n] + riskMap[current]
            enqueue!(frontier, n, riskMap[n])
        end
    end
    return riskMap[goal]
end

using BenchmarkTools
@btime begin
    caveMap, start, goal = readData()
    getShortestPath(caveMap, start, goal)
    caveMap = expandMap(caveMap)
    getShortestPath(caveMap, CartesianIndex(size(caveMap)...), goal)
end