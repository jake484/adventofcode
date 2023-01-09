readData(path="data/2022/day3.txt") = readlines(path)

function part1(data)
    s = 0
    for i in eachindex(data)
        l = length(data[i]) >> 1
        ch = intersect(data[i][1:l], data[i][l+1:end])[1]
        s += isuppercase(ch) ? 27 + ch - 'A' : ch - 'a' + 1
    end
    return s
end

# part two
function part2(data)
    s = 0
    for i in 1:3:lastindex(data)
        ch = intersect(data[i:i+2]...)[1]
        s += isuppercase(ch) ? 27 + ch - 'A' : ch - 'a' + 1
    end
    return s
end

using BenchmarkTools
@btime begin
    data = readData()
    part1(data), part2(data)
end
