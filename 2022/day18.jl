# 读取数据
rawData = readlines("data/2022/day18.txt")
# 将数据转换为二维数组
data = map(line -> map(x -> parse(Int, x), split(line, ",")), rawData)

# 计算data的最大值与最小值
maxVal = maximum.(data) |> maximum
minVal = minimum.(data) |> minimum
r = maxVal - minVal + 1 + 2
offset = minVal == 0 ? 2 : 1
# 构建三维坐标轴
map3D = falses(r, r, r)

# 将数据转换为三维坐标轴
function draw!(map::BitArray{3}, data::Vector{Vector{Int}}, offset::Int=0)
    for i in 1:length(data)
        map[data[i][1]+offset, data[i][2]+offset, data[i][3]+offset] = true
    end
end

# 绘制三维坐标轴
draw!(map3D, data, offset)

# 统计正方体的外表面积
function countSurfaceArea(map::BitArray{3}, cubes::Vector{Vector{Int}}, r::Int, offset::Int=0)
    count = 0
    for cube in cubes
        i, j, k = cube[1] + offset, cube[2] + offset, cube[3] + offset
        if i == 1 || !map[i-1, j, k]
            count += 1
        end
        if i == r || !map[i+1, j, k]
            count += 1
        end
        if j == 1 || !map[i, j-1, k]
            count += 1
        end
        if j == r || !map[i, j+1, k]
            count += 1
        end
        if k == 1 || !map[i, j, k-1]
            count += 1
        end
        if k == r || !map[i, j, k+1]
            count += 1
        end
    end
    return count
end

# 统计正方体的外表面积
sa = countSurfaceArea(map3D, data, r, offset)
println("SurfaceArea:", sa)

# 查找零坐标的邻居坐标
function neighbours(map::BitArray{3}, current::CartesianIndex{3})
    i, j, k = current.I[1], current.I[2], current.I[3]
    neighb = CartesianIndex{3}[]
    if i > 1 && !map[i-1, j, k]
        push!(neighb, CartesianIndex(i - 1, j, k))
    end
    if i < size(map, 1) && !map[i+1, j, k]
        push!(neighb, CartesianIndex(i + 1, j, k))
    end
    if j > 1 && !map[i, j-1, k]
        push!(neighb, CartesianIndex(i, j - 1, k))
    end
    if j < size(map, 2) && !map[i, j+1, k]
        push!(neighb, CartesianIndex(i, j + 1, k))
    end
    if k > 1 && !map[i, j, k-1]
        push!(neighb, CartesianIndex(i, j, k - 1))
    end
    if k < size(map, 3) && !map[i, j, k+1]
        push!(neighb, CartesianIndex(i, j, k + 1))
    end
    return neighb
end


# 递归进行广度优先搜索外部零坐标
function cubeSearch(map::BitArray{3}, currents::Vector{CartesianIndex{3}}, neighb::Vector{Vector{CartesianIndex{3}}})
    newCurrent = CartesianIndex{3}[]
    newNeighb = Vector{CartesianIndex{3}}[]
    for ind ∈ eachindex(currents)
        map[currents[ind]] = true
        for neigh ∈ neighb[ind]
            if !map[neigh]
                push!(newCurrent, neigh)
                map[neigh] = true
            end
        end
    end
    for current in newCurrent
        push!(newNeighb, neighbours(current, map))
    end
    if !isempty(newCurrent)
        cubeSearch(map, newCurrent, newNeighb)
    end
end

# 查找外部零坐标
cubeSearch(map3D, [CartesianIndex(1, 1, 1)], [neighbours(CartesianIndex(1, 1, 1), map3D)])

# 找到所有的零坐标
zeroCubes = findall(x -> !x, map3D)

# 统计正方体内的空心坐标的外表面积
function countInnerSurfaceArea(map::BitArray{3}, cubes::Vector{CartesianIndex{3}}, r::Int)
    count = 0
    for cube in cubes
        i, j, k = cube.I[1], cube.I[2], cube.I[3]
        if i == 1 || map[i-1, j, k]
            count += 1
        end
        if i == r || map[i+1, j, k]
            count += 1
        end
        if j == 1 || map[i, j-1, k]
            count += 1
        end
        if j == r || map[i, j+1, k]
            count += 1
        end
        if k == 1 || map[i, j, k-1]
            count += 1
        end
        if k == r || map[i, j, k+1]
            count += 1
        end
    end
    return count
end

sa - countInnerSurfaceArea(map3D, zeroCubes, r) |> println