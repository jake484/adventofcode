function readData(path, ::Val{19})
    
end

function partOne(data)
    return 0
end

function partTwo(data)
    return 0
end

function day19_main()
    data = readData("data/2023/day19.txt", Val(19))
    return partOne(data), partTwo(data)
end

# test
data = readData("data/2023/day19.txt", Val(19))
day19_main()

# using BenchmarkTools
# @info "day19 性能："
# @btime day19_main()

