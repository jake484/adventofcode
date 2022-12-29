function readData(path="data/2021/day9.txt")
    data = readlines(path)
    m = zeros(Int, length(data), length(data[1]))
    for i in eachindex(data)
        for j in eachindex(data[i])
            m[i, j] = data[i][j] - '0'
        end
    end
    return m
end

function addRiskLevel(heightMap::Matrix{Int}, x::Int, y::Int, xmax::Int, ymax::Int)
    inds = CartesianIndex{2}[]
    x > 1 && push!(inds, CartesianIndex(x - 1, y))
    x < xmax && push!(inds, CartesianIndex(x + 1, y))
    y > 1 && push!(inds, CartesianIndex(x, y - 1))
    y < ymax && push!(inds, CartesianIndex(x, y + 1))
    all(map(>(heightMap[x, y]), heightMap[inds])) && return heightMap[x, y] + 1
    return 0
end

function findLowPoints(heightMap::Matrix{Int}, xmax::Int, ymax::Int)
    points = CartesianIndex{2}[]
    for i in 1:xmax
        for j in 1:ymax
            addRiskLevel(heightMap, i, j, xmax, ymax) == 0 || push!(points, CartesianIndex(i, j))
        end
    end
    return points
end

function neighbours(current::CartesianIndex{2}, map::BitArray{2}, heightMap::Matrix{Int}, xmax::Int, ymax::Int)
    i, j = current.I[1], current.I[2]
    neighb = CartesianIndex{2}[]
    if i > 1 && !map[i-1, j] && heightMap[i-1, j] < 9
        push!(neighb, CartesianIndex(i - 1, j))
    end
    if i < xmax && !map[i+1, j] && heightMap[i+1, j] < 9
        push!(neighb, CartesianIndex(i + 1, j))
    end
    if j > 1 && !map[i, j-1] && heightMap[i, j-1] < 9
        push!(neighb, CartesianIndex(i, j - 1))
    end
    if j < ymax && !map[i, j+1] && heightMap[i, j+1] < 9
        push!(neighb, CartesianIndex(i, j + 1))
    end
    return neighb
end


function findBasins(heightMap::Matrix{Int}, points::Vector{CartesianIndex{2}}, xmax::Int, ymax::Int)
    basinSize = Int[]
    ischecked = falses(xmax, ymax)
    for p in points
        s = 1
        neighbs = neighbours(p, ischecked, heightMap, xmax, ymax)
        ischecked[p] = true
        while !isempty(neighbs)
            current = pop!(neighbs)
            if !ischecked[current]
                s += 1
                ischecked[current] = true
            end
            append!(neighbs, neighbours(current, ischecked, heightMap, xmax, ymax))
        end
        push!(basinSize, s)
    end
    return basinSize
end

function solve_P1(heightMap::Matrix{Int})
    xmax, ymax = size(heightMap)
    points = findLowPoints(heightMap, xmax, ymax)
    return sum(heightMap[points]) + length(points)
end

function solve_P2(heightMap::Matrix{Int})
    xmax, ymax = size(heightMap)
    points = findLowPoints(heightMap, xmax, ymax)
    basinSize = findBasins(heightMap, points, xmax, ymax)
    return sort(basinSize, rev=true)[1:3] |> prod
end

using BenchmarkTools
@btime begin
    data = readData()
    solve_P1(data)
    solve_P2(data)
end

# using BenchmarkTools
# @btime begin end
