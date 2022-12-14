data = readlines("data/day10.txt")
data = split.(data, ' ')
# part one 
cycles = 1
x = 1
signal = Vector{Int}[]
for instruction in data
    if instruction[1] == "noop"
        push!(signal, [cycles, x])
        global cycles += 1
    else
        push!(signal, [cycles, x])
        global cycles += 1
        push!(signal, [cycles, x])
        global cycles += 1
        global x += parse(Int, instruction[2])
    end
end

sum(map(x -> prod(x), signal[20:40:220]))

# part two
begin
    CRTs = String[]
    crt = ""
    cyclePos = 1
    for ind in signal
        global crt *= cyclePos in ind[2]:ind[2]+2 ? "#" : "."
        global cyclePos += 1
        if ind[1] % 40 == 0
            global cyclePos = 1
            push!(CRTs, crt)
            global crt = ""
        end
    end
    CRTs
end
map(x -> x[36:40], CRTs)