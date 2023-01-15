struct Cube
    ison::Bool
    coordinate::CartesianIndices{3,Tuple{UnitRange{Int64},UnitRange{Int64},UnitRange{Int64}}}
end

function readData(path="data/2021/day22.txt")
    regex = r"(\D+) x=(-?\d+)..(-?\d+),y=(-?\d+)..(-?\d+),z=(-?\d+)..(-?\d+)"
    cubes = Cube[]
    for line in eachline(path)
        m = match(regex, line).captures
        ison = m[1] == "on"
        xyz = parse.(Int, m[2:end])
        push!(cubes, Cube(ison, CartesianIndices((xyz[1]:xyz[2], xyz[3]:xyz[4], xyz[5]:xyz[6]))))
    end
    return cubes
end

function intersectCubes(cubes::Vector{Cube})
    newCubes = Cube[]
    for cube in cubes
        toAddCubes = Cube[]
        for nc in newCubes
            interCoor = nc.coordinate ∩ cube.coordinate
            isempty(interCoor) || push!(toAddCubes, Cube(!nc.ison, interCoor))
        end
        cube.ison && push!(toAddCubes, cube)
        append!(newCubes, toAddCubes)
    end
    return newCubes
end

const MAPAREA = CartesianIndices((-50:50, -50:50, -50:50))

part1(cubes::Vector{Cube}) = sum((newCube.ison ? 1 : -1) * prod(size(newCube.coordinate ∩ MAPAREA)) for newCube in cubes)

part2(cubes::Vector{Cube}) = sum((newCube.ison ? 1 : -1) * prod(size(newCube.coordinate)) for newCube in cubes)

using BenchmarkTools
@btime begin
    data = readData() |> intersectCubes
    part1(data), part2(data)
end