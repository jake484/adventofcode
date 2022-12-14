movedata = readlines("data/day5.txt")
movedata = map(x -> parse.(Int, split(x, ' ')[2:2:6]), movedata)

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

# part one 
for move in movedata
    for i in 1:move[1]
        pushfirst!(data[move[3]], popfirst!(data[move[2]]))
    end
end
res = join(map(x -> x[1], data))

# part two
for move in movedata
    box = Char[]
    for i in 1:move[1]
        push!(box, popfirst!(data[move[2]]))
    end
    pushfirst!(data[move[3]], box...)
end
res = join(map(x -> x[1], data))