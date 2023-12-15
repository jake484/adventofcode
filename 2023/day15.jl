function readData(path, ::Val{15})
    return split(readline(path), ',')
end

function handleOneStr(str::AbstractString)
    s = 0
    for c in str
        s += c - '\0'
        s *= 17
        s %= 256
    end
    return s
end

function partOne(data)
    return sum(handleOneStr, data)
end

using DataStructures

function partTwo(data)
    boxes = [OrderedDict{String,Int}() for _ in 1:256]
    for str in data
        if '=' in str
            k, v = split(str, '=')
            boxIndex = handleOneStr(k) + 1
            boxes[boxIndex][k] = parse(Int, v)
        else
            k, v = split(str, '-')
            boxIndex = handleOneStr(k) + 1
            haskey(boxes[boxIndex], k) && pop!(boxes[boxIndex], k)
        end
    end
    return sum(enumerate(boxes)) do (i, box)
        isempty(box) && return 0
        return sum(enumerate(box)) do (j, (_, v))
            i * j * v
        end
    end
end

function day15_main()
    data = readData("data/2023/day15.txt", Val(15))
    return partOne(data), partTwo(data)
end

# test
# data = readData("data/2023/day15.txt", Val(15))
# day15_main()

using BenchmarkTools
@info "day15 性能："
@btime day15_main()

