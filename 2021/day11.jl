function readData(path="data/2021/day11.txt")
    data = readlines(path)
    m = zeros(Int, length(data), length(data[1]))
    for i in eachindex(data[1])
        for j in eachindex(data)
            m[j, i] = data[j][i] - '0'
        end
    end
    return m
end

function neighbours(current::CartesianIndex{2}, flashMap::Matrix{Int}, xmax::Int, ymax::Int)
    i, j = current.I[1], current.I[2]
    neighb = CartesianIndex{2}[]
    i > 1 && (1 <= flashMap[i-1, j]) && push!(neighb, CartesianIndex(i - 1, j))
    i > 1 && j > 1 && (1 <= flashMap[i-1, j-1]) && push!(neighb, CartesianIndex(i - 1, j - 1))
    i > 1 && j < ymax && (1 <= flashMap[i-1, j+1]) && push!(neighb, CartesianIndex(i - 1, j + 1))
    i < xmax && (1 <= flashMap[i+1, j]) && push!(neighb, CartesianIndex(i + 1, j))
    i < xmax && j > 1 && (1 <= flashMap[i+1, j-1]) && push!(neighb, CartesianIndex(i + 1, j - 1))
    i < xmax && j < ymax && (1 <= flashMap[i+1, j+1]) && push!(neighb, CartesianIndex(i + 1, j + 1))
    j > 1 && (1 <= flashMap[i, j-1]) && push!(neighb, CartesianIndex(i, j - 1))
    j < ymax && (1 <= flashMap[i, j+1]) && push!(neighb, CartesianIndex(i, j + 1))
    return neighb
end

findallToFlash(flashMap::Matrix{Int}) = findall(x -> x > 9, flashMap)

function addNeighbours!(flashMap::Matrix{Int}, current::CartesianIndex{2}, xmax::Int, ymax::Int)
    for n in neighbours(current, flashMap, xmax, ymax)
        flashMap[n] += 1
    end
end

function flash!(flashMap::Matrix{Int}, toFlashList::Vector{CartesianIndex{2}})
    xmax, ymax = size(flashMap)
    for p in toFlashList
        flashMap[p] = 0
        addNeighbours!(flashMap, p, xmax, ymax)
    end
end

function flashOneRound!(flashMap::Matrix{Int})
    for i in eachindex(flashMap)
        flashMap[i] += 1
    end
    toFlashList = findallToFlash(flashMap)
    while !isempty(toFlashList)
        flash!(flashMap, toFlashList)
        toFlashList = findallToFlash(flashMap)
    end
    return count(x -> x == 0, flashMap)
end

function solve_P1(data::Matrix{Int}, round::Int=100)
    s = 0
    flashMap = copy(data)
    for _ in Base.OneTo(round)
        s += flashOneRound!(flashMap)
    end
    return s
end

function solve_P2(data::Matrix{Int})
    flashMap = copy(data)
    target = size(data) |> prod
    round = 1
    while flashOneRound!(flashMap) != target
        round += 1
    end
    return round
end

using BenchmarkTools
@btime begin
    data = readData()
    solve_P1(data)
    solve_P2(data)
end
