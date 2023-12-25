using Meshes

function readData(path, ::Val{24})
    data = Tuple[]
    for line ∈ readlines(path)
        point, speed = split(line, " @ ")
        x, y, z = parse.(Int, split(point, ", "))
        vx, vy, vz = parse.(Int, split(speed, ", "))
        push!(data, (x, y, z, vx, vy, vz))
    end
    return data
end

function equal(vec, speed)
    return Int.(sign.(vec)) == sign.(speed)
end

function partOne(data)
    s = 0
    area = PolyArea([
        (200000000000000, 200000000000000),
        (200000000000000, 400000000000000),
        (400000000000000, 400000000000000),
        (400000000000000, 200000000000000)])
    # area = PolyArea([
    #     (7, 7),
    #     (7, 27),
    #     (27, 27),
    #     (27, 7)])
    len = length(data)
    for i in 1:len
        ax, ay, az, avx, avy, avz = data[i]
        a = Line((ax, ay), (ax + avx, ay + avy))
        for j in i+1:len
            bx, by, bz, bvx, bvy, bvz = data[j]
            b = Line((bx, by), (bx + bvx, by + bvy))
            inter = intersect(a, b)
            if !isnothing(inter) && inter ∈ area && equal((inter - Point(ax, ay)).coords, (avx, avy)) && equal((inter - Point(bx, by)).coords, (bvx, bvy))
                s += 1
            end
        end
    end
    return s
end

function partTwo(data)
    return 0
end

function day24_main()
    data = readData("data/2023/day24.txt", Val(24))
    return partOne(data), partTwo(data)
end

# test
data = readData("data/2023/day24.txt", Val(24))
day24_main()

# using BenchmarkTools
# @info "day24 性能："
# @btime day24_main()