using StaticArrays

function readData(path="data/2021/day5.txt")
    data = readlines(path)
    data = map(x -> parse.(Int, match(r"(-?\d+),(-?\d+) -> (-?\d+),(-?\d+)", x).captures), data)
    return data
end

function getIndices(points::Vector{Int})
    inds = CartesianIndex{2}[]
    if points[1] == points[3]
        rWigth = min(points[2], points[4])+1:max(points[2], points[4])+1
        rHight = (points[1] + 1) * ones(Int, length(rWigth))
    elseif points[2] == points[4]
        rHight = min(points[1], points[3])+1:max(points[1], points[3])+1
        rWigth = (points[2] + 1) * ones(Int, length(rHight))
    else
        rHight = points[1] < points[3] ? (points[1]+1:points[3]+1) : (points[1]+1:-1:points[3]+1)
        rWigth = points[2] < points[4] ? (points[2]+1:points[4]+1) : (points[2]+1:-1:points[4]+1)
    end
    for (i, j) in zip(rHight, rWigth)
        push!(inds, CartesianIndex(j, i))
    end
    return inds
end

function drawLine(lines::Vector{Vector{Int}}, hasDiag::Bool=false)
    lines = hasDiag ? lines : filter(x -> x[1] == x[3] || x[2] == x[4], lines)
    maxHight = (map(x -> max(x[1], x[3]), lines) |> maximum) + 1
    maxWidth = (map(x -> max(x[2], x[4]), lines) |> maximum) + 1
    grid = zeros(maxHight, maxWidth)
    for line in lines
        inds = getIndices(line)
        for ind in inds
            grid[ind] += 1
        end
    end
    return count(x -> x >= 2, grid)
end

using BenchmarkTools
@btime begin
    line = readData()
    grid = drawLine(line)
    grid2 = drawLine(line, true)
end