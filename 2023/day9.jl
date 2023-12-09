function readData(path, ::Val{9})
    return map(x -> parse.(Int, split(x)), readlines(path))
end

function partOne(data)
    s = 0
    for arr in data
        la, ne = arr, diff(arr)
        s += last(la) + last(ne)
        while !allequal(ne)
            la, ne = copy(ne), diff(ne)
            s += last(ne)
        end
    end
    return s
end

function partTwo(data)
    s = 0
    for arr in data
        la, ne = arr, diff(arr)
        s += first(la) - first(ne)
        flag = false
        while !allequal(ne)
            la, ne = copy(ne), diff(ne)
            s += (flag ? -first(ne) : first(ne))
            flag = !flag
        end
    end
    return s
end

function day9_main()
    data = readData("data/2023/day9.txt", Val(9))
    return partOne(data), partTwo(data)
end

# test
# data = readData("data/2023/day9.txt", Val(9))
# day9_main()

using BenchmarkTools
@info "day9 性能："
@btime day9_main()

