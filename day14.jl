# 读取数据
rawData = readlines("data/day14.txt")
Data = split.(rawData, "->")
Data = map(x -> strip.(x), Data)

# 把嵌套数组的字符串坐标转换为整数坐标
Data = map(x -> map(y -> map(z -> parse(Int64, z), split(y, ",")), x), Data)

# 找到嵌套数组最大的y坐标
maxy = maximum(map(x -> maximum(map(y -> y[2], x)), Data))
maxy += 2

# 初始化地图
Map = zeros(Int64, maxy, 1000)

# 根据坐标画线
function drawline!(map::Array, xs::Int64, ys::Int64, xe::Int64, ye::Int64)
    if xs == xe
        for y in min(ys, ye):max(ys, ye)
            map[y, xs] = 1
        end
    else
        for x in min(xs, xe):max(xs, xe)
            map[ys, x] = 1
        end
    end
end

# 画线
for lines in Data
    for ind in 1:lastindex(lines)-1
        (xs, ys) = lines[ind]
        (xe, ye) = lines[ind+1]
        drawline!(Map, xs, ys, xe, ye)
    end
end

# 从[500，1]开始，递归下降，先判断是否能向下，再判断是否能向左，再判断是否能向右，直到到达下边界或者停止
function downSand!(map::Array, x::Int64, y::Int64)
    if y == lastindex(map, 1)
        return (x, y)
    end
    if map[y+1, x] == 0
        downSand!(map, x, y + 1)
    elseif map[y+1, x-1] == 0
        downSand!(map, x - 1, y + 1)
    elseif map[y+1, x+1] == 0
        downSand!(map, x + 1, y + 1)
    else
        map[y, x] = 2
        return (x, y)
    end
end

# Part One 画沙子
while true
    (x, y) = downSand!(Map, 500, 0)
    if y == lastindex(Map, 1)
        break
    end
end

# 统计沙子的个数
println("===Part1===\nMap中沙子的个数: ", count(==(2), Map))

# 在地图中把maxy设为1
Map[maxy, :] .= 1

# Part two 画沙子
while !all(==(2), Map[1, 499:501])
    (x, y) = downSand!(Map, 500, 0)
    if y == lastindex(Map, 1)
        break
    end
end

# 统计沙子的个数
println("===Part2===\nMap中沙子的个数+1: ", count(==(2), Map) + 1)


