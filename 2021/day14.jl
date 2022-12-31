function readData(path="data/2021/day14.txt")
    reg = r"(\D+) -> (\D)"
    data = readlines(path)
    template = popfirst!(data)
    popfirst!(data)
    pairs = Dict{String,Char}()
    for pair in data
        caps = match(reg, pair).captures
        pairs[caps[1]] = caps[2][1]
    end
    return template, pairs
end

function solve(template, pairs)
    elements = unique(vcat(collect(values(pairs)), collect(template)))
    pairc = Dict{String,Int}()
    for i = eachindex(elements)
        for j = eachindex(elements)
            pairc[join((elements[i], elements[j]))] = 0
        end
    end
    charDict = Dict(c => 0 for c in elements)
    for i = 1:length(template)-1
        pairc[template[i:i+1]] += 1
    end
    paircountsleftright = []
    leftmostpair = template[1:2]
    rightmostpair = template[end-1:end]
    for i = 1:40
        paircc = copy(pairc)
        pairc = Dict(x => 0 for x in keys(pairc))
        for (k, v) in paircc
            pairc[join((k[1], pairs[k]))] += v
            pairc[join((pairs[k], k[2]))] += v
        end
        leftmostpair = join((leftmostpair[1], pairs[leftmostpair]))
        rightmostpair = join((pairs[rightmostpair], rightmostpair[2]))
        if i == 10
            push!(paircountsleftright, (copy(pairc), leftmostpair, rightmostpair))
        end
    end
    push!(paircountsleftright, (pairc, leftmostpair, rightmostpair))
    solutions = Int[]
    for (pairc, lp, rp) ∈ paircountsleftright
        charDict = Dict(c => 0 for c in elements)
        for (k, v) in pairc
            for c in k
                charDict[c] += v
            end
        end
        charDict[lp[1]] += 1
        charDict[rp[2]] += 1
        push!(solutions, -(extrema(values(charDict) .÷ 2)...) |> abs)
    end
    return solutions
end

using BenchmarkTools
@btime begin
    template, pairs = readData()
    solve(template, pairs)
end
