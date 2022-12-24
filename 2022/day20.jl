using Dates
# 读取数据
function readData(path="data/2022/day20.txt")
    Dictdata = Dict{Int64,Int64}()
    listdata = String[]
    open(path) do f
        for line in eachline(f)
            n = parse(Int64, line)
            if haskey(Dictdata, n)
                Dictdata[n] += 1
            else
                Dictdata[n] = 1
            end
            push!(listdata, line * "," * string(Dictdata[n]))
        end
    end
    return listdata
end

# 获得移动后的坐标
function getIndex(index::Int64, step::Int64, l::Int64)
    index = index + step
    if index ∈ 1:l
        return index
    else
        return mod1(index , l - 1) 
    end
end

# 判断数据是否完成移动
function isMoved(num::Int64, moved::Dict{Int64,Int64}, data::Dict{Int64,Int64})
    return haskey(moved, num) && moved[num] == data[num]
end

# 将数据添加到移动列表
function addMoved!(num::Int64, moved::Dict{Int64,Int64})
    if haskey(moved, num)
        moved[num] += 1
    else
        moved[num] = 1
    end
end

# 移动数据
function moveData!(data::Vector{String}, moved::Vector{String})
    l = length(data)
    while length(moved) < l
        for i in eachindex(data)
            data_i = parse(Int64, split(data[i], ",")[1])
            if data[i] in moved
                continue
            end
            if data_i == 0
                push!(moved, data[i])
            else
                push!(moved, data[i])
                d = data[i]
                index = getIndex(i, data_i, l)
                if i < index
                    data[i:index-1] .= data[i+1:index]
                    data[index] = d
                elseif i == index
                    nothing
                else
                    data[index+1:i] .= data[index:i-1]
                    data[index] = d
                end
            end
            break
        end
        println("Now: $(now()),MOVEED:$(length(moved))")
        # println(data)
    end
end

listdata = readData()
moved = String[]
moveData!(listdata, moved)

zeroindex = findfirst(x -> x[1] == '0', listdata)
l = length(listdata)
sum(x -> parse(Int64, split(x, ",")[1]), listdata[mod1(zeroindex + i, l)] for i in [1000, 2000, 3000])
