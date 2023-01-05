function readData(path="data/2021/day25.txt")
    data = readlines(path)
    mapSize = (length(data), length(data[1]))
    eastFaceingIndices = CartesianIndex{2}[]
    southFaceingIndices = CartesianIndex{2}[]
    for i in eachindex(data)
        for j in eachindex(data[i])
            data[i][j] == '>' && push!(eastFaceingIndices, CartesianIndex(i, j))
            data[i][j] == 'v' && push!(southFaceingIndices, CartesianIndex(i, j))
        end
    end
    locationMap = falses(mapSize)
    foreach(index -> locationMap[index] = true, eastFaceingIndices)
    foreach(index -> locationMap[index] = true, southFaceingIndices)
    return (eastFaceingIndices, southFaceingIndices, locationMap)
end

const TOEAST = CartesianIndex(0, 1)
const TOSOUTH = CartesianIndex(1, 0)

function inbounds(A::BitMatrix, I::CartesianIndex, ::Val{:east})
    toMoveIndex = I + TOEAST
    return checkbounds(Bool, A, toMoveIndex) ? toMoveIndex : CartesianIndex(I.I[1], 1)
end

function inbounds(A::BitMatrix, I::CartesianIndex, ::Val{:south})
    toMoveIndex = I + TOSOUTH
    return checkbounds(Bool, A, toMoveIndex) ? toMoveIndex : CartesianIndex(1, I.I[2])
end

function moveOneHerd(locationMap::BitMatrix, index::CartesianIndex{2}, ::Val{N}) where {N}
    toMoveIndex = inbounds(locationMap, index, Val(N))
    locationMap[toMoveIndex] && return index
    return toMoveIndex
end

function moveOneStep!(eastFaceingIndices, southFaceingIndices, locationMap)
    old = copy(eastFaceingIndices)
    for (i, index) in enumerate(eastFaceingIndices)
        eastFaceingIndices[i] = moveOneHerd(locationMap, index, Val(:east))
    end
    foreach(index -> locationMap[index] = false, old)
    foreach(index -> locationMap[index] = true, eastFaceingIndices)
    old = copy(southFaceingIndices)
    for (i, index) in enumerate(southFaceingIndices)
        southFaceingIndices[i] = moveOneHerd(locationMap, index, Val(:south))
    end
    foreach(index -> locationMap[index] = false, old)
    foreach(index -> locationMap[index] = true, southFaceingIndices)
end

function moveAllSteps!(eastFaceingMap, southFaceingMap, locationMap::BitMatrix)
    steps = 0
    while true
        old = copy(locationMap)
        moveOneStep!(eastFaceingMap, southFaceingMap, locationMap)
        # display(old)
        steps += 1
        old == locationMap && return steps
    end
end

using BenchmarkTools
@btime begin
    eastFaceingMap, southFaceingMap, locationMap = readData()
    moveAllSteps!(eastFaceingMap, southFaceingMap, locationMap)
end
