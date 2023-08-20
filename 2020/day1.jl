# 读取数据
function readData(path, ::Val{1})
    data = Int64[]
    for line in eachline(path)
        push!(data, parse(Int64, line))
    end
    return data
end

# 找到和
function findNum(data::Vector, Target::Int=2020)::Int
    dic = Dict{Int,Int}()
    for ind in eachindex(data)
        toFind = data[ind]
        toFind ∈ keys(dic) && return dic[toFind] * data[ind]
        dic[Target-toFind] = toFind
    end
    return 0
end

function findThreeNum!(data::Vector)::Int
    for _ in 1:(length(data)-2)
        popedNum = popfirst!(data)
        res = findNum(data, 2020 - popedNum)
        res > 0 && return res * popedNum
    end
    return 0
end

function day1_main()
    data = readData("data/2020/day1.txt", Val(1))
    data |> findNum
    data |> findThreeNum!
    return nothing
end

# using BenchmarkTools
# @info "day1 性能："
# @btime day1_main()
