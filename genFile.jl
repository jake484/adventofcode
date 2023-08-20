function main(index::Int, year::Int=2020)
    str = """
    function readData(path, ::Val{$index})
        
    end
    
    function day$(index)_main()
        data = readData("data/$year/day$index.txt", Val($index))

        return nothing
    end

    # test
    data = readData("data/$year/day$index.txt", Val($index))


    using BenchmarkTools
    @info "day$index 性能："
    @btime day$(index)_main()

    """
    open("data/$year/day$index.txt", "w") do io
        write(io, "")
    end

    open("$year/day$index.jl", "w") do io
        write(io, str)
    end
end

main(18)