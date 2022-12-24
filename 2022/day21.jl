# 读取数据
function readData(path="data/2022/day21.txt")
    numData = Dict{String,Int64}()
    exData = Dict{String,Vector{String}}()
    for line in eachline(path)
        v = split(line, c -> c == ' ' || c == ':')
        filter!(x -> x != "", v)
        if !(tryparse(Int64, v[end]) |> isnothing)
            numData[v[1]] = tryparse(Int64, v[end])
        else
            exData[v[1]] = v[2:end]
        end
    end
    return numData, exData
end

numData, exData = readData()

# 计算
function monkeyYell!(numData::Dict{String,Int64}, exData::Dict{String,Vector{String}})
    while !isempty(exData)
        for (k, v) in exData
            if haskey(numData, v[1]) && haskey(numData, v[3])
                if v[2] == "/" && mod(numData[v[1]], numData[v[3]]) != 0
                    return false
                end
                numData[k] = eval(v[2] |> Symbol)(numData[v[1]], numData[v[3]])
                delete!(exData, k)
            end
        end
    end
    return true
end

# Part two
function humnYell(numData::Dict{String,Int64}, exData::Dict{String,Vector{String}})
    r1, _, r2 = exData["root"]
    ind = Int64[]
    r1s = Int64[]
    r2s = Int64[]
    for i in 1:5000
        mynumData = deepcopy(numData)
        myexData = deepcopy(exData)
        mynumData["humn"] = i
        if monkeyYell!(mynumData, myexData)
            push!(r1s, mynumData[r1])
            push!(r2s, mynumData[r2])
            push!(ind, i)
            if mynumData[r1] == mynumData[r2]
                println("Part two answer: ", i)
                break
            end
        end
        if mod(i, 100) == 0
            println("finish: ", div(i, 100), "%")
        end
    end
    return r1s, r2s, ind
end

# monkeyYell!(numData, exData)
# println("Part one answer: ", numData["root"])
# numData, exData = readData()
# r1s, r2s, ind = humnYell(numData, exData)
# ks = [(r1s[i] - r1s[1]) // (ind[i] - ind[1]) for i in 2:lastindex(ind)]
# if allequal(ks)
#     p2 = (r2s[1] - r1s[1]) // ks[1] + ind[1]
#     println("Part two answer: ", Int(p2))
# end

using BenchmarkTools
function benchmark()
    numData, exData = readData()
    humnYell(numData, exData)
    monkeyYell!(numData, exData)
end
@btime benchmark()

