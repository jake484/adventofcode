# 读取数据
rawData = readlines("data/2022/day12.txt")
mountain = fill('0', length(rawData), length(rawData[1]))
for i in eachindex(rawData)
    for j in eachindex(rawData[i])
        mountain[i, j] = rawData[i][j]
    end
end

# 找到起点和终点
startPos = findfirst(x -> x == 'S', mountain)
endPos = findfirst(x -> x == 'E', mountain)

# 替换起点和终点
replace!(mountain, 'S' => 'a', 'E' => 'z')
mountain = mountain .- 'a'

# 步数表
costs = fill(size(mountain) |> prod, size(mountain))
visited = falses(size(mountain))
costs[endPos] = 0

# 搜索领域
function neighbours(index::CartesianIndex{2}, M::Int, N::Int)
    neighb = CartesianIndex{2}[]
    i, j = index.I
    i - 1 >= 1 && push!(neighb, CartesianIndex(i - 1, j))
    j - 1 >= 1 && push!(neighb, CartesianIndex(i, j - 1))
    i + 1 <= M && push!(neighb, CartesianIndex(i + 1, j))
    j + 1 <= N && push!(neighb, CartesianIndex(i, j + 1))
    return neighb
end

# 从终点开始，递归向起点逆向进行广度优先搜索
function reverseSearch(costs::Matrix{Int64}, visited::BitMatrix, mountain::Matrix{Int64}, currents::Vector{CartesianIndex{2}}, neighb::Vector{Vector{CartesianIndex{2}}})
    newCurrent = CartesianIndex{2}[]
    newNeighb = Vector{CartesianIndex{2}}[]
    for ind ∈ eachindex(currents)
        current = currents[ind]
        for neigh ∈ neighb[ind]
            if !visited[neigh] && mountain[current] - mountain[neigh] <= 1
                push!(newCurrent, neigh)
                push!(newNeighb, neighbours(neigh, size(mountain)...))
                costs[neigh] = costs[current] + 1
                visited[neigh] = true
            end
        end
    end
    if !isempty(newCurrent)
        reverseSearch(costs, visited, mountain, newCurrent, newNeighb)
    end
end

# 从终点开始搜索
reverseSearch(costs, visited, mountain, [endPos], [neighbours(endPos, size(mountain)...)])

# 找到起点的步数
p1 = costs[startPos]
p2 = costs[findall(x -> x == 0, mountain)] |> minimum
println("Part 1: ", p1)
println("Part 2: ", p2)