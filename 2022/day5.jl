function readData(path="data/2022/day5.txt")
    regex = r"move (\d+) from (\d+) to (\d+)"
    return map(x -> parse.(Int, match(regex, x).captures), readlines(path))
end

# part one 
function part1(movedata)
    data = collect.([
        "MFCWTDLB"
        "LBN"
        "VLTHCJ"
        "WJPS"
        "RLTFCSZ"
        "ZNHBGDW"
        "NCGVPSMF"
        "ZCVFJRQW"
        "HLMPR"
    ])
    for move in movedata
        for _ in 1:move[1]
            pushfirst!(data[move[3]], popfirst!(data[move[2]]))
        end
    end
    return join(map(x -> x[1], data))
end

function part2(movedata)
    data = collect.([
        "MFCWTDLB"
        "LBN"
        "VLTHCJ"
        "WJPS"
        "RLTFCSZ"
        "ZNHBGDW"
        "NCGVPSMF"
        "ZCVFJRQW"
        "HLMPR"
    ])
    for move in movedata
        box = Char[]
        for _ in 1:move[1]
            push!(box, popfirst!(data[move[2]]))
        end
        pushfirst!(data[move[3]], box...)
    end
    return join(map(x -> x[1], data))
end

using BenchmarkTools
@btime begin
    data = readData()
    part1(data), part2(data)
end
