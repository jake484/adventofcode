using Graphs
function readData(path="data/2021/day12.txt")
    data = readlines(path)
    data = map(x -> string.(split(x, '-')), data)
    name2num = Dict{String,Int}()
    num2name = Dict{Int,String}()
    ind = 0
    g = SimpleGraph()
    while !isempty(data)
        x = popfirst!(data)
        if !haskey(name2num, x[1])
            ind += 1
            name2num[x[1]] = ind
            num2name[ind] = x[1]
            add_vertex!(g)
        end
        if !haskey(name2num, x[2])
            ind += 1
            name2num[x[2]] = ind
            num2name[ind] = x[2]
            add_vertex!(g)
        end
        add_edge!(g, name2num[x[1]], name2num[x[2]])
    end
    return name2num, num2name, g
end

Base.islowercase(s::String) = all(c -> islowercase(c), s |> collect)

function canVisit(n::Int, visited::Dict{Int,Int}, num2name::Dict{Int,String}, ::Val{1})
    haskey(visited, n) && visited[n] >= 1 && return false
    return true
end

function canVisit(n::Int, visited::Dict{Int,Int}, num2name::Dict{Int,String}, ::Val{2})
    if num2name[n] == "end" || num2name[n] == "start"
        haskey(visited, n) && visited[n] >= 1 && return false
    else
        if 2 ∈ values(visited)
            haskey(visited, n) && visited[n] >= 1 && return false
        else
            haskey(visited, n) && visited[n] >= 2 && return false
        end
    end
    return true
end

function findPath!(visited::Dict{Int,Int}, start::String, goal::String, g::SimpleGraph, name2num::Dict{String,Int}, num2name::Dict{Int,String}, ::Val{N}) where {N}
    neighs = neighbors(g, name2num[start])
    path = 0
    ispushed = false
    for n in neighs
        if n == name2num[goal]
            path += 1
        else
            if canVisit(n, visited, num2name, Val(N))
                if islowercase(num2name[n])
                    if haskey(visited, n)
                        visited[n] += 1
                    else
                        visited[n] = 1
                    end
                    ispushed = true
                end
                # push!(ss, num2name[n])
                path += findPath!(visited, num2name[n], goal, g, name2num, num2name, Val(N))
                if ispushed
                    visited[n] -= 1
                    ispushed = false
                end
                # pop!(ss)
            end
        end
    end
    return path
end

using BenchmarkTools
@btime begin
    name2num, num2name, g = readData()
    findPath!(Dict{Int,Int}(name2num["start"] => 1), "start", "end", g, name2num, num2name, Val(1))
    findPath!(Dict{Int,Int}(name2num["start"] => 1), "start", "end", g, name2num, num2name, Val(2))
end