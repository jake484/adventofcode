readData(path="data/2022/day2.txt") = readlines(path)

const PART1_MAP = Dict([
    "A X" => 4
    "A Y" => 8
    "A Z" => 3
    "B X" => 1
    "B Y" => 5
    "B Z" => 9
    "C X" => 7
    "C Y" => 2
    "C Z" => 6
])

const PART2_MAP = Dict([
    "A X" => 3
    "A Y" => 4
    "A Z" => 8
    "B X" => 1
    "B Y" => 5
    "B Z" => 9
    "C X" => 2
    "C Y" => 6
    "C Z" => 7
])

function part1(data)
    s = 0
    for i in data
        s += PART1_MAP[i]
    end
    return s
end

function part2(data)
    s = 0
    for i in data
        s += PART2_MAP[i]
    end
    return s
end

using BenchmarkTools
@btime begin
    d = readData()
    part1(d), part2(d)
end