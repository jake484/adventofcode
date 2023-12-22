function main(index::Int, year::Int=2023)
    str = """
    function readData(path, ::Val{$index})
        
    end
    
    function partOne(data)
        return 0
    end
    
    function partTwo(data)
        return 0
    end
    
    function day$(index)_main()
        data = readData("data/$year/day$index.txt", Val($index))
        return partOne(data), partTwo(data)
    end

    # test
    data = readData("data/$year/day$index.txt", Val($index))
    day$(index)_main()

    # using BenchmarkTools
    # @info "day$index 性能："
    # @btime day$(index)_main()

    """
    open("data/$year/day$index.txt", "w") do io
        write(io, "")
    end

    open("$year/day$index.jl", "w") do io
        write(io, str)
    end
end

main(22)
