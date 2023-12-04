function readData(path, ::Val{4})
    data = Tuple{Vector{Int64},Vector{Int64},Vector{Int64}}[]
    for line in eachline(path)
        strs = split(line, c -> c == '|' || c == ':')[2:end]
        winners = map(x -> parse(Int64, x), filter(x -> !isempty(x), split(strs[1] |> strip, ' ')))
        cards = map(x -> parse(Int64, x), filter(x -> !isempty(x), split(strs[2] |> strip, ' ')))
        push!(data, (winners, cards, [1]))
    end
    return data
end

function partOne(data)
    return sum(data) do (winners, cards, _)
        l = length(winners ∩ cards)
        l == 0 ? 0 : 2^(l - 1)
    end
end

function partTwo(data)
    lastind = lastindex(data)
    for ind in eachindex(data)
        winners, cards, num = data[ind]
        l = length(winners ∩ cards)
        for i in 1:l
            ind + i <= lastind && (data[ind+i][3][1] += num[1])
        end
    end
    return sum(x -> x[3][1], data)
end

function day4_main()
    data = readData("data/2023/day4.txt", Val(4))
    return partOne(data), partTwo(data)
end

# test
# data = readData("data/2023/day4.txt", Val(4))
# day4_main()

using BenchmarkTools
@info "day4 性能："
@btime day4_main()

