function readData(path="data/2021/day6.txt")
    data = readlines(path)[1]
    data = split(data, ',')
    fishes = zeros(Int, 8)
    for num in data
        fishes[parse(Int, num)+1] += 1
    end
    return fishes
end

function createFish(initFishes::Vector{Int}, day::Int)
    d = 1
    fishes = copy(initFishes)
    fishMap = Vector{Int}[]
    while d <= day
        today = mod1(d, 7)
        if d - 9 < 1
            fishes[end] = fishes[today]
        else
            fishes[today] += fishMap[1][end]
            fishes[end] = fishes[today]
            popfirst!(fishMap)
        end
        push!(fishMap, copy(fishes))
        d += 1
    end
    if day < 9
        return sum(fishMap[end]) + sum(map(x -> x[end], fishMap[1:end-1]))
    else
        return sum(fishMap[end]) + sum(map(x -> x[end], fishMap[end-8:end-1]))
    end
end

using BenchmarkTools
@btime begin
    data = readData()
    createFish(data, 80)
    createFish(data, 256)
end
