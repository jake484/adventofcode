readData(path="data/2022/day10.txt") = split.(readlines(path), ' ')

# part one 
function part1(data)
    cycles, x = 1, 1
    signal = Tuple{Int,Int}[]
    for instruction in data
        if instruction[1] == "noop"
            push!(signal, (cycles, x))
            cycles += 1
        else
            push!(signal, (cycles, x))
            cycles += 1
            push!(signal, (cycles, x))
            cycles += 1
            x += parse(Int, instruction[2])
        end
    end
    return signal, sum(map(x -> prod(x), signal[20:40:220]))
end

function part2(signal)
    CRTs = String[]
    crt = ""
    cyclePos = 1
    for ind in signal
        crt *= cyclePos in ind[2]:ind[2]+2 ? "#" : "."
        cyclePos += 1
        if ind[1] % 40 == 0
            cyclePos = 1
            push!(CRTs, crt)
            crt = ""
        end
    end
    return CRTs
end

using BenchmarkTools
@btime begin
    data = readData()
    signal, s = part1(data)
    CRTs = part2(signal)
end