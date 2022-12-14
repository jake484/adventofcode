# 读取数据
data = readlines("data/day7.txt")
data = split.(data, ' ')

# 定义目录结构
Base.@kwdef mutable struct directory
    name::String = ""
    size::Int64 = 0
    subdirs::Vector{directory} = directory[]
    fileSizes::Vector{Int64} = Int64[]
end

# part one 

# 初始索引
ind = firstindex(data)

# 递归生成目录结构
function generateDirectory(ind::Int64, l::Int64)
    dir = directory(name=data[ind][3])
    ind += 2
    dirNames = String[]
    while ind <= l && data[ind][1] != "\$"
        if data[ind][1] == "dir"
            push!(dirNames, data[ind][2])
        else
            push!(dir.fileSizes, parse(Int, data[ind][1]))
        end
        ind += 1
    end
    while ind <= l && data[ind] == ["\$", "cd", ".."]
        ind += 1
    end
    for i in dirNames
        subdir, ind = generateDirectory(ind, l)
        push!(dir.subdirs, subdir)
    end
    return dir, ind
end
res, ind = generateDirectory(1, lastindex(data));

# 储存每个目录的大小
sizes = Int64[]

# 递归计算目录大小
function calucDirectorySize(dir::directory)
    dir.size = sum(dir.fileSizes)
    for i in dir.subdirs
        dir.size += calucDirectorySize(i)
    end
    push!(sizes, dir.size)
    return dir.size
end

totalszie = calucDirectorySize(res)

# 不超过100MB的目录
sum(x -> x <= 100000 ? x : 0, sizes)

# part two
toDel = totalszie - 40000000
findmin(x -> x > toDel ? x : Inf64, sizes)
