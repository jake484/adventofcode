function readData(path, ::Val{12})
    chars, nums = Vector{Char}[], Vector{Int}[]
    for line in readlines(path)
        c, n = split(line, " ")
        push!(chars, collect(c))
        push!(nums, map(x -> parse(Int, x), split(n, ',')))
    end
    return chars, nums
end

function partOne(data)
    return 0
end

function partTwo(data)
    return 0
end

function day12_main()
    data = readData("data/2023/day12.txt", Val(12))
    return partOne(data), partTwo(data)
end

# test
data = readData("data/2023/day12.txt", Val(12))
day12_main()

# using BenchmarkTools
# @info "day12 性能："
# @btime day12_main()

