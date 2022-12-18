# 读取数据
rawData0 = readlines("data/day17.txt")[1] |> collect
l = length(rawData0)
rawData = repeat(rawData0, 1)
rocksBottom = Dict{Int64,Vector{Tuple{Int64,Int64}}}(
    1 => [(3, 6)],
    2 => [(4, 4), (3, 5), (4, 4)],
    3 => [(3, 5), (5, 5), (5, 5)],
    4 => [(3, 3), (3, 3), (3, 3), (3, 3)],
    0 => [(3, 4), (3, 4)]
)

gameMap = zeros(Int8, 10000, 7)

function moveRock!(gameMap::Array{Int8,2}, rock::Vector{Tuple{Int64,Int64}}, direction::Char, higth::Int64)
    if direction == '<'
        for ind in eachindex(rock)
            if rock[ind][1] <= 1 || gameMap[higth+ind-1, rock[ind][1]-1] == 1
                return
            end
        end
        for ind in eachindex(rock)
            rock[ind] = (rock[ind][1] - 1, rock[ind][2] - 1)
        end
    elseif direction == '>'
        for ind in eachindex(rock)
            if rock[ind][2] >= 7 || gameMap[higth+ind-1, rock[ind][2]+1] == 1
                return
            end
        end
        for ind in eachindex(rock)
            rock[ind] = (rock[ind][1] + 1, rock[ind][2] + 1)
        end
    end
end

function isRockStop(gameMap::Array{Int8,2}, rock::Vector{Tuple{Int64,Int64}}, hight::Int64, isPlusRock::Bool)
    hight < 1 && return true
    if !isPlusRock
        rockRange = rock[1][1]:rock[1][2]
        if any(gameMap[hight, rockRange] .== 1)
            return true
        end
    else
        rockRange = rock[2][1]:rock[2][2]
        if gameMap[hight, rock[1][1]] == 1 || any(gameMap[hight+1, rockRange] .== 1)
            return true
        end
    end
    return false
end

# 在地图上画出石头
function drawRock!(gameMap::Array{Int8,2}, rock::Vector{Tuple{Int64,Int64}}, hight::Int64)
    for ind in eachindex(rock)
        gameMap[hight+ind-1, rock[ind][1]:rock[ind][2]] .= 1
    end
end

maxhight = 0
s = 0
repeattimes = 0
for i in 1:1000000
    rocknum = i % 5
    isrepeat = false
    if rocknum == 1 && length(rawData) == l
        println("isrepeat:", true)
        isrepeat = true
    end
    rock = deepcopy(rocksBottom[rocknum])
    hight = maxhight + 4
    for j in 1:4
        step = popfirst!(rawData)
        global rawData = isempty(rawData) ? repeat(rawData0, 1) : rawData
        moveRock!(gameMap, rock, step, hight)
        hight -= 1
    end
    while !isRockStop(gameMap, rock, hight, rocknum == 2)
        step = popfirst!(rawData)
        global rawData = isempty(rawData) ? repeat(rawData0, 1) : rawData
        moveRock!(gameMap, rock, step, hight)
        hight -= 1
    end
    if isrepeat && rock[1][1] == 3
        println("repeat at:", i)
        break
    end
    drawRock!(gameMap, rock, hight + 1)
    global maxhight = max(maxhight, hight + length(rock))
    if maxhight > 9950
        maxhights = minimum(map(x -> findlast(gameMap[:, x] .== 1), 1:7))
        cache = gameMap[maxhights:10000, :]
        global gameMap = zeros(Int8, 10000, 7)
        global gameMap[1:size(cache, 1), :] .= cache
        global s += maxhight
        global maxhight -= maxhights
    end
end

s

# 找到每列的最高点


# 打印地图前 100 行
# for i in maxhight:-1:1
#     for j in 1:7
#         if gameMap[i, j] == 1
#             print("#")
#         else
#             print(".")
#         end
#     end
#     println()
# end
