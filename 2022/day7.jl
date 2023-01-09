Base.@kwdef mutable struct directory
    name::String = ""
    size::Int64 = 0
    subdirs::Vector{directory} = directory[]
    fileSizes::Vector{Int64} = Int64[]
end

function generateDirectory(data, ind::Int64=firstindex(data), l::Int64=lastindex(data))
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
        subdir, ind = generateDirectory(data, ind, l)
        push!(dir.subdirs, subdir)
    end
    return dir, ind
end

readData(path="data/2022/day7.txt") = split.(readlines(path), ' ') |> generateDirectory

function calucDirectorySize!(sizes::Vector{Int}, dir::directory)
    dir.size = sum(dir.fileSizes)
    for i in dir.subdirs
        dir.size += calucDirectorySize!(sizes, i)
    end
    push!(sizes, dir.size)
    return dir.size
end

function solve(dir)
    sizes = Int64[]
    totalszie = calucDirectorySize!(sizes, dir)
    toDel = totalszie - 40000000
    return sum(x -> x <= 100000 ? x : 0, sizes), findmin(x -> x > toDel ? x : Inf64, sizes)
end

using BenchmarkTools
@btime solve(readData()[1])