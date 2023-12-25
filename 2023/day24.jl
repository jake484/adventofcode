using Meshes
using JuMP, COPT, HiGHS

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

# function partTwo(data)
#     model = Model(COPT.Optimizer)
#     @variable(model, X >= 0, Int)
#     @variable(model, V, Int)
#     @variable(model, t[1:length(data)] >= 0, Int)
#     for i in eachindex(data)
#         x, y, z, vx, vy, vz = data[i]
#         x = x + y + z
#         vx = vx + vy + vz
#         @constraint(model, X == x + vx * t[i])
#     end
#     @objective(model, Min, sum(t))
#     optimize!(model)
#     return round(objective_value(model))
# end

function partTwo(data)
    newdata = map(x -> (sum(x[1:3]), sum(x[4:6])), data)
    minx2 = minimum(map(x -> Int128(x[2]), newdata))
    newdata = map(x -> (x[1], x[2] - minx2 + 1), newdata)
    ranges = intersect(typemax(Int):-1:1, map(x -> x[1]:x[2]:typemax(Int), newdata)...)
    # ranges = map(x -> x[2] < 0 ? (x[1]:x[2]:typemin(Int)) : (x[1]:x[2]:typemax(Int)), newdata)
    return ranges
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