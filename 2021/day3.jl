# 读取数据
function readData(path="data/2021/day3.txt")
    data = readlines(path)
    bMap = falses(length(data), length(data[1]))
    for (i, line) in enumerate(data)
        for (j, c) in enumerate(line)
            bMap[i, j] = c == '1'
        end
    end
    return bMap
end

function getRate(bmap::BitMatrix)
    gammaRate = 0b0
    epsilonRate = 0b0
    for c in eachcol(bmap)
        gammaRate <<= 1
        epsilonRate <<= 1
        if count(c) > length(c) >> 1
            gammaRate += 1
        else
            epsilonRate += 1
        end
    end
    return gammaRate, epsilonRate
end

function delRaws!(raws::Vector{Int}, todel::Vector{Int})
    for i in raws |> eachindex
        if raws[i] in todel
            raws[i] = -1
        end
    end
    filter!(x -> x != -1, raws)
end

function getRate(bmap::BitMatrix, ::Val{true})
    step = 1
    raws = 1:size(bmap, 1) |> collect
    while step <= size(bmap, 2) && length(raws) > 1
        c = count(x -> x == true, bmap[raws, step])
        if c >= length(raws) - c
            delRaws!(raws, findall(x -> x[step] == false, eachrow(bmap)))
        else
            delRaws!(raws, findall(x -> x[step] == true, eachrow(bmap)))
        end
        step += 1
    end
    return reduce(bmap[raws, :]) do x, y
        x <<= 1
        x += y
    end
end

function getRate(bmap::BitMatrix, ::Val{false})
    step = 1
    raws = 1:size(bmap, 1) |> collect
    while step <= size(bmap, 2) && length(raws) > 1
        c = count(x -> x == false, bmap[raws, step])
        if c <= length(raws) - c
            delRaws!(raws, findall(x -> x[step] == true, eachrow(bmap)))
        else
            delRaws!(raws, findall(x -> x[step] == false, eachrow(bmap)))
        end
        step += 1
    end
    return reduce(bmap[raws, :]) do x, y
        x <<= 1
        x += y
    end
end

using BenchmarkTools
const oxygen = true
const co2 = false
@btime begin
    d = readData()
    getRate(d) |> prod
    (getRate(d, Val(oxygen)), getRate(d, Val(co2))) |> prod
end