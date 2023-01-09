readData(path="data/2022/day1.txt") = readlines(path)

function part1(data)
    s, m = 0, 0
    for i in data
        if i == ""
            m = max(s, m)
            s = 0
        else
            s += parse(Int, i)
        end
    end
    return m
end

function part2(data)
    s, m = 0, Int[]
    for i in data
        if i == ""
            push!(m, s)
            s = 0
        else
            s += parse(Int, i)
        end
    end
    return sum(sort(m; rev=true)[1:3])
end
using BenchmarkTools
@btime begin
    d = readData()
    part1(d), part2(d)
end
