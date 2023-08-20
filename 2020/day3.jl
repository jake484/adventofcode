function readData(path, ::Val{3})
    return [line for line in readlines(path)]
end

function countTree(data::Vector, step::Int, down::Int=1)
    len = length(data[1])
    j = 1
    numTree = 0
    for i in 1:down:length(data)
        '#' == data[i][j] && (numTree += 1)
        j = mod1(j + step, len)
    end
    return numTree
end

function countMultTree(data::Vector)
    toDo = [(1, 1), (3, 1), (5, 1), (7, 1), (1, 2)]
    return prod(toDo) do todo
        step, down = todo
        return countTree(data, step, down)
    end
end

function day3_main()
    data = readData("data/2020/day3.txt", Val(3))
    countTree(data, 3, 1)
    data |> countMultTree
    return nothing
end

# using BenchmarkTools
# @info "day3 性能："
# @btime day3_main()

