function readData(path="data/2021/day22.txt")
    regex = r"(\D+) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)"
    steps = Tuple{Bool,CartesianIndices}[]
    for line in eachline(path)
        m = match(regex, line).captures
        ison = m[1] == "on"
        xyz = parse.(Int, m[2:end])
        push!(steps, (ison, CartesianIndices((xyz[1]:xyz[2], xyz[3]:xyz[4], xyz[5]:xyz[6]))))
    end
    return steps
end

const MAPAREA = CartesianIndices((-50:50, -50:50, -50:50))
const MAPOFFSET = maximum(MAPAREA)

function turnOnce!(grid::Array{Int8,3}, indices::CartesianIndices, ::Val{N}) where {N}
    for index in indices ∩ MAPAREA
        grid[index+MAPOFFSET] = Int8(N)
    end
end

function turnCube(steps::Vector{Tuple{Bool,CartesianIndices}})
    grid = zeros(Int8, size(MAPAREA))
    for (isOn, indices) in steps
        turnOnce!(grid, indices, Val(isOn))
    end
    return sum(grid)
end

minIndex(a::CartesianIndices) = CartesianIndex(minimum(a.indices[1]), minimum(a.indices[2]), minimum(a.indices[3]))

maxIndex(a::CartesianIndices) = CartesianIndex(maximum(a.indices[1]), maximum(a.indices[2]), maximum(a.indices[3]))

Base.in(a::CartesianIndices, b::CartesianIndices) = minIndex(a) in b && maxIndex(a) in b

function turnAllCube!(data::Vector{Tuple{Bool,CartesianIndices}})
    lastStepIndex = lastindex(data)
    toPop = Int[]
    while data[lastStepIndex][1] != false
        lastStepIndex -= 1
        for i in Base.OneTo(lastStepIndex)
            data[i][2] ∈ data[lastStepIndex+1][2] && push!(toPop, i)
        end
    end
    println("lastStepIndex: ", length(toPop))
    for i in sort(toPop, rev=true)
        popat!(data, i)
    end
end



# using BenchmarkTools
# @btime begin
#     data = readData()
#     turnCube(data)
# end

Ref(end)
CartesianIndices((1:2, 1:2, 1:2))[1, 2, 2]
data = readData()
turnAllCube!(data)