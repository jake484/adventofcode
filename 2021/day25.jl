function readData(path="data/2021/day25.txt")
    data = readlines(path)
    mapSize = (length(data), length(data[1]))
    eastFaceingMap = falses(mapSize)
    southFaceingMap = falses(mapSize)
    for i in eachindex(data)
        for j in eachindex(data[i])
            data[i][j] == '>' && (eastFaceingMap[i, j] = true)
            data[i][j] == 'v' && (southFaceingMap[i, j] = true)
        end
    end
    return (eastFaceingMap, southFaceingMap, eastFaceingMap .| southFaceingMap)
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

function moveOneHerd!(map::BitMatrix, locationMap::BitMatrix, index::CartesianIndex{2}, ::Val{N}) where {N}
    toMoveIndex = inbounds(map, index, Val(N))
    if locationMap[toMoveIndex]
        map[index] = true
    else
        map[toMoveIndex] = true
    end
end

function moveOneStep(eastFaceingMap::BitMatrix, southFaceingMap::BitMatrix, locationMap::BitMatrix, mapSize::Tuple{Int,Int})
    newEastFaceingMap, newSouthFaceingMap = falses(mapSize), falses(mapSize)
    for index in (i for i in CartesianIndices(eastFaceingMap) if eastFaceingMap[i])
        moveOneHerd!(newEastFaceingMap, locationMap, index, Val(:east))
    end
    locationMap = newEastFaceingMap .| southFaceingMap
    for index in (i for i in CartesianIndices(southFaceingMap) if southFaceingMap[i])
        moveOneHerd!(newSouthFaceingMap, locationMap, index, Val(:south))
    end
    return (newEastFaceingMap, newSouthFaceingMap, newEastFaceingMap .| newSouthFaceingMap)
end

function moveAllSteps(eastFaceingMap::BitMatrix, southFaceingMap::BitMatrix, locationMap::BitMatrix)
    mapSize = size(eastFaceingMap)
    steps = 0
    while true
        eastFaceingMap, southFaceingMap, newLocationMap = moveOneStep(eastFaceingMap, southFaceingMap, locationMap, mapSize)
        steps += 1
        newLocationMap == locationMap && return steps
        locationMap = newLocationMap
    end
end

using BenchmarkTools
@btime begin
    eastFaceingMap, southFaceingMap, locationMap = readData()
    moveAllSteps(eastFaceingMap, southFaceingMap, locationMap)
end
