# function readData(path, ::Val{6})
#     strs = Tuple[]
#     str = String[]
#     for line in readlines(path)
#         if isempty(line)
#             push!(strs, tuple(str...))
#             str = String[]
#         else
#             push!(str, line)
#         end
#     end
#     push!(strs, tuple(str...))
#     return strs
# end

function readData(path, ::Val{6})
    strs = Vector{String}[]
    str = String[]
    for line in readlines(path)
        if isempty(line)
            push!(strs, str)
            str = String[]
        else
            push!(str, line)
        end
    end
    push!(strs, str)
    return strs
end

import DataStructures: counter

countQuestions(data::Vector) = sum(x -> x |> join |> Set |> length, data)
countUnionQuestions(data::Vector) =
    sum(data) do item
        return intersect(item...) |> length
    end
function day6_main()
    data = readData("data/2020/day6.txt", Val(6))
    data |> countQuestions
    data |> countUnionQuestions
    return nothing
end

# test
# data = readData("data/2020/day6.txt", Val(6))

# using BenchmarkTools
# @info "day6 性能："
# @btime day6_main()

