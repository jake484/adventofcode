using LinearAlgebra
function readData(path="data/2021/day19.txt")
    scanners = Vector{CartesianIndex{3}}[]
    beacons = CartesianIndex{3}[]
    for line in eachline(path)
        isempty(line) && continue
        m = match(r"(-?\d+),(-?\d+),(-?\d+)", line)
        if isnothing(m)
            isempty(beacons) || push!(scanners, beacons)
            beacons = CartesianIndex{3}[]
        else
            x, y, z = parse.(Int, m.captures)
            push!(beacons, CartesianIndex(x, y, z))
        end
    end
    push!(scanners, beacons)
    return scanners
end

function getOrientationMatrix()
    ori = Matrix{Int}[]
    ms = [
        [1 0 0; 0 0 1; 0 1 0],
        [1 0 0; 0 1 0; 0 0 1],
        [0 0 1; 0 1 0; 1 0 0],
        [0 1 0; 0 0 1; 1 0 0],
        [0 1 0; 1 0 0; 0 0 1],
        [0 0 1; 1 0 0; 0 1 0],
    ]
    for i in (-1, 1), j in (-1, 1), k in (-1, 1)
        append!(ori, map(m -> m * diagm([i, j, k]), ms))
    end
    return ori
end

const ORIENTATION_MATRICES = getOrientationMatrix()

function Base.:*(m::Matrix{Int}, v::CartesianIndex{3})
    return CartesianIndex(m * [v.I...]...)
end

getRelativeCoordinates(beacons, m::Matrix{Int}) = (m * (beacons[i] - beacons[j]) for i in 1:length(beacons)-1 for j in i+1:length(beacons))

getRelativeCoordinates(beacons) = (beacons[i] - beacons[j] for i in 1:length(beacons)-1 for j in i+1:length(beacons))

function compareBeacons(beacons1, beacons2)
    for m in ORIENTATION_MATRICES
        l = intersect(collect(getRelativeCoordinates(beacons1)), getRelativeCoordinates(beacons2, m)) |> length

        l >= 12 && (println(collect(getRelativeCoordinates(beacons1))|>length);return l)
    end
    return nothing
end

data = readData()

for i in 1:length(data)-1
    for j in i+1:length(data)
        m = compareBeacons(data[i], data[j])
        m === nothing && continue
        println("Found match between $i and $j")
        println("Orientation matrix: $m")
        println()
    end
end


# ORIENTATION_MATRICES[1] * (data[1][2] - data[1][1])