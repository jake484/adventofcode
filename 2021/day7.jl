function readData(path="data/2021/day7.txt")
    data = readlines(path)[1]
    data = split(data, ',')
    return map(x -> parse(Int, x), data)
end

function solve(data::Vector{Int}, f::Function=abs)
    return map(x -> sum(f, map(y -> x - y, data)), data) |> minimum
end

using BenchmarkTools
@btime begin
    data = readData()
    solve(data)
    solve(data, x -> (abs2(x) + abs(x)) >> 1)
end
