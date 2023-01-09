function readData(path="data/2022/day4.txt")
    data = split.(readlines(path), (c -> c == ',' || c == '-'))
    return map(i -> parse.(Int, i), data)
end

# part one
function part1(data)
    s = 0
    for i in data
        (i[1]:i[2] ⊆ i[3]:i[4] || i[1]:i[2] ⊇ i[3]:i[4]) && (s += 1)
    end
    return s
end


# part two
function part2(data)
    s = 0
    for i in data
        isempty(intersect(i[1]:i[2], i[3]:i[4])) || (s += 1)
    end
    return s
end

using BenchmarkTools
@btime begin
    data = readData()
    part1(data), part2(data)
end