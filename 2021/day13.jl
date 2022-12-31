function readData(path="data/2021/day13.txt")
    reg = r"fold along (\D)=(\d+)"
    indices = CartesianIndex{2}[]
    foldInfo = Tuple{Char,Int}[]
    for line in eachline(path)
        if occursin(',', line)
            points = parse.(Int, split(line, ','))
            points .+= 1
            push!(indices, CartesianIndex(points[2], points[1]))
        elseif occursin("fold", line)
            caps = match(reg, line).captures
            push!(foldInfo, (caps[1][1], parse(Int, caps[2]) + 1))
        end
    end
    size = maximum(indices).I
    paper = falses(size...)
    paper[indices] .= true
    return paper, foldInfo
end

function fold!(paper::BitArray{2}, foldIndex::Int, ::Val{true})
    for i in Base.OneTo(foldIndex - 1)
        paper[:, i] .|= paper[:, 2foldIndex-i]
    end
    return paper[:, 1:foldIndex-1]
end

function fold!(paper::BitArray{2}, foldIndex::Int, ::Val{false})
    for i in Base.OneTo(foldIndex - 1)
        paper[i, :] .|= paper[2foldIndex-i, :]
    end
    return paper[1:foldIndex-1, :]
end

function fold!(paper::BitArray{2}, foldInfo::Vector{Tuple{Char,Int}})
    for instruction in foldInfo
        paper = fold!(paper, instruction[2], Val(instruction[1] == 'x'))
    end
    return paper
end

function foldOnce!(paper::BitArray{2}, foldInfo::Vector{Tuple{Char,Int}})
    paper = fold!(paper, foldInfo[1][2], Val(foldInfo[1][1] == 'x'))
    return count(paper)
end

using BenchmarkTools
@btime begin
    paper, foldInfo = readData()
    foldOnce!(copy(paper), foldInfo)
    fold!(paper, foldInfo)
end