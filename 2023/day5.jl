function readData(path, ::Val{5})
    data = readlines(path)
    seeds = map(x -> parse(Int, x), split(split(popfirst!(data), ':')[2] |> strip, ' '))
    maps = Vector{Vector{Int}}[]
    oneline = Vector{Int}[]
    while !isempty(data)
        line = popfirst!(data)
        if isempty(line)
            popfirst!(data)
            !isempty(oneline) && push!(maps, oneline)
            oneline = Vector{Int}[]
        else
            push!(oneline, map(x -> parse(Int, x), split(line, ' ')))
        end
    end
    push!(maps, oneline)
    return seeds, maps
end

function process(seed::Int, maps)
    product = seed
    for m in maps
        for line in m
            res, source, step = line
            if source <= seed <= source + step - 1
                product = res + (seed - source)
                break
            end
        end
        seed = product
    end
    return product
end

function partOne(data)
    seeds, maps = data
    return minimum(seed -> process(seed, maps), seeds)
end

using Intervals

function process(seed::IntervalSet, maps)
    for m in maps
        sourceinters = IntervalSet()
        product = IntervalSet()
        for line in m
            res, source, step = line
            sourceinter = IntervalSet(source .. (source + step - 1))
            intersected = intersect(seed, sourceinter)
            if !isempty(intersected)
                intersected.items .+= res - source
                product = union(product, intersected)
            end
            sourceinters = union(sourceinters, sourceinter)
        end
        product = union(product, setdiff(seed, sourceinters))
        seed = deepcopy(product)
    end
    return minimum(first, seed.items)
end

function partTwo(data)
    seeds, maps = data
    sets = (IntervalSet(seeds[i] .. (seeds[i] + seeds[i+1] - 1)) for i in 1:2:length(seeds))
    return minimum(x -> process(x, maps), sets)
end

function day5_main()
    data = readData("data/2023/day5.txt", Val(5))
    return partOne(data), partTwo(data)
end

# test
# data = readData("data/2023/day5.txt", Val(5))
# day5_main() |> println

using BenchmarkTools
@info "day5 性能："
@btime day5_main()