function readData(path, ::Val{6})
    return ([48, 98, 90, 83], [390, 1103, 1112, 1360])
end

function solve(t, d)
    x1 = (t - sqrt(t^2 - 4 * d)) / 2
    x2 = (t + sqrt(t^2 - 4 * d)) / 2
    isinteger(x1) && (x1 += 1)
    isinteger(x2) && (x2 -= 1)
    x1 = x1 <= 0 ? 0 : ceil(Int, x1)
    x2 = floor(Int, x2)
    return x2 - x1 + 1
end

function partOne(data)
    s = 1
    for (t, d) in zip(data...)
        s *= solve(t, d)
    end
    return s
end

function partTwo(data)
    t, d = 48989083, 390110311121360
    return solve(t, d)
end

function day6_main()
    return partOne(data), partTwo(data)
end

# test
# data = readData("data/2023/day6.txt", Val(6))
# day6_main()

using BenchmarkTools
@info "day6 性能："
@btime day6_main()

