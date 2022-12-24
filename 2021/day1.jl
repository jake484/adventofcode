# 读取数据
function readData(path="data/2021/day1.txt")
    data = Int64[]
    for line in eachline(path)
        push!(data, parse(Int64, line))
    end
    return data
end

# 记录前一个数比后一个数小的次数
function count(data, r=1)
    count = 0
    for i in 1:lastindex(data)-r
        if data[i:i+r-1] |> sum < data[i+1:i+r] |> sum
            count += 1
        end
    end
    return count
end

data = readData()
println("Part 1: ", count(data))
println("Part 2: ", count(data, 3))

using BenchmarkTools
@btime begin
    data = readData()
    count(data)
    count(data, 3)
end
