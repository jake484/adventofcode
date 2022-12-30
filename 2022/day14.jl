
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

function readData(path="data/2022/day14.txt")
    rawData = readlines(path)
    Data = split.(rawData, "->")
    Data = map(x -> strip.(x), Data)
    # 把嵌套数组的字符串坐标转换为整数坐标
    Data = map(x -> map(y -> map(z -> parse(Int64, z), split(y, ",")), x), Data)
    maxy = maximum(map(x -> maximum(map(y -> y[2], x)), Data))
    maxy += 2
    Map = zeros(Int64, maxy, 1000)
    # 画线
    for lines in Data
        for ind in 1:lastindex(lines)-1
            (xs, ys) = lines[ind]
            (xe, ye) = lines[ind+1]
            drawline!(Map, xs, ys, xe, ye)
        end
    end
    return Map, maxy
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

function solve_P1!(Map)
    while true
        (x, y) = downSand!(Map, 500, 0)
        if y == lastindex(Map, 1)
            break
        end
    end
    return count(==(2), Map)
end

function solve_P2(Map, maxy)
    # 在地图中把maxy设为1
    Map[maxy, :] .= 1
    while !all(==(2), Map[1, 499:501])
        (x, y) = downSand!(Map, 500, 0)
        if y == lastindex(Map, 1)
            break
        end
    end
    return count(==(2), Map) + 1
end

using BenchmarkTools
@btime begin
    Map, maxy = readData()
    solve_P1!(Map)
    solve_P2(Map, maxy)
end



