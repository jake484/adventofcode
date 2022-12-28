# 读取数据
function readData(path="data/2021/day4.txt")
    data = readlines(path)
    nums = parse.(Int, split(popfirst!(data), ','))
    maps = Array{Int,2}[]
    m = zeros(Int, 5, 5)
    while !isempty(data)
        if first(data) == ""
            m = zeros(Int, 5, 5)
            popfirst!(data)
        else
            for i in 1:5
                s = popfirst!(data) |> strip
                s = filter(x -> x != "", split(s, " "))
                m[i, :] = parse.(Int, s)
            end
            push!(maps, m)
        end
    end
    return nums, maps
end

function markMaps!(markmaps::Vector{BitMatrix}, maps::Vector{Array{Int,2}}, num::Int)
    for i in eachindex(maps)
        ind = findfirst(x -> x == num, maps[i])
        if !isnothing(ind)
            markmaps[i][ind] = true
        end
    end
end

function isBingo(markmaps::Vector{BitMatrix})
    for i in eachindex(markmaps)
        m = markmaps[i]
        for j in 1:5
            if all(m[j, :]) || all(m[:, j])
                return i
            end
        end
    end
    return 0
end

function bingo(nums::Vector{Int}, maps::Vector{Array{Int,2}})
    markmaps = map(x -> falses(5, 5), maps)
    for i in eachindex(nums)
        markMaps!(markmaps, maps, nums[i])
        bingo = isBingo(markmaps)
        if bingo != 0
            inds = findall(x -> x == false, markmaps[bingo])
            return sum(maps[bingo][inds]) * nums[i]
        end
    end
    return 0
end

function isBingos(markmaps::Vector{BitMatrix})
    inds = Int[]
    for i in eachindex(markmaps)
        m = markmaps[i]
        for j in 1:5
            if all(m[j, :]) || all(m[:, j])
                push!(inds, i)
                break
            end
        end
    end
    return inds
end

function lastBingo!(nums::Vector{Int}, maps::Vector{Array{Int,2}})
    markmaps = map(x -> falses(5, 5), maps)
    markmap = markmaps |> first
    m = maps |> first
    lastBingo = 0
    for i in eachindex(nums)
        markMaps!(markmaps, maps, nums[i])
        bingos = isBingos(markmaps)
        if !isempty(bingos)
            sort!(bingos, rev=true)
            for bingo in bingos
                markmap = popat!(markmaps, bingo)
                m = popat!(maps, bingo)
                lastBingo = i
            end
            if isempty(markmaps)
                inds = findall(x -> x == false, markmap)
                return sum(m[inds]) * nums[i]
            end
        end
    end
    return sum(m[findall(x -> x == false, markmap)]) * nums[lastBingo]
end

using BenchmarkTools
@btime begin
    nums, maps = readData()
    bingo(nums, maps) # Part One
    lastBingo!(nums, maps) # Part Two
end