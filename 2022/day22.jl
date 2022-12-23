const HIGHT = 200
const WIDTH = 150

function parsePath(str)
    s = e = 1
    path = String[]
    l = length(str)
    while e <= l
        if str[e] == 'R' || str[e] == 'L' || e == l
            push!(path, str[s:e-1], str[e] |> string)
            s = e + 1
        end
        e += 1
    end
    return path
end
# 读取数据
function readData(path="data/2022/day22.txt")
    data = readlines(path)
    gameMap = zeros(Int, 200, 150)
    for i in 1:HIGHT
        for j in 1:WIDTH
            if length(data[i]) < j
                break
            end
            gameMap[i, j] = data[i][j] == '#' ? -1 : data[i][j] == '.' ? 1 : 0
        end
    end
    pathDescription = parsePath(data[end])
    return gameMap, pathDescription
end

@enum Direction begin
    U = 3
    R = 0
    D = 1
    L = 2
end

getDirectionNum(direction::Direction) = direction |> Int

function getMoveStep(direction::Direction)
    if direction == U
        return CartesianIndex(-1, 0)
    elseif direction == R
        return CartesianIndex(0, 1)
    elseif direction == D
        return CartesianIndex(1, 0)
    else
        return CartesianIndex(0, -1)
    end
end

function inBound(pos::CartesianIndex{2})
    pos.I[1] < 1 && return CartesianIndex(HIGHT, pos.I[2])
    pos.I[1] > HIGHT && return CartesianIndex(1, pos.I[2])
    pos.I[2] < 1 && return CartesianIndex(pos.I[1], WIDTH)
    pos.I[2] > WIDTH && return CartesianIndex(pos.I[1], 1)
    return pos
end

function inBound(pos::CartesianIndex{2}, d::Direction)

    pos.I[1] < 1 && 51 <= pos.I[2] <= 100 && d == U && return CartesianIndex(150 + pos.I[2] - 50, 1), R
    pos.I[2] < 1 && 151 <= pos.I[1] <= 200 && d == L && return CartesianIndex(1, 50 + pos.I[1] - 150), D
    pos.I[1] > 150 && 51 <= pos.I[2] <= 100 && d == D && return CartesianIndex(150 + pos.I[2] - 50, 50), L
    pos.I[2] > 50 && 151 <= pos.I[1] <= 200 && d == R && return CartesianIndex(150, 50 + pos.I[1] - 150), U

    pos.I[1] < 101 && 1 <= pos.I[2] <= 50 && d == U && return CartesianIndex(50 + pos.I[2], 51), R
    pos.I[2] < 51 && 51 <= pos.I[1] <= 100 && d == L && return CartesianIndex(101, pos.I[1] - 50), D
    pos.I[1] > 50 && 101 <= pos.I[2] <= 150 && d == D && return CartesianIndex(50 + pos.I[2] - 100, 100), L
    pos.I[2] > 100 && 51 <= pos.I[1] <= 100 && d == R && return CartesianIndex(50, 100 + pos.I[1] - 50), U
    pos.I[1] < 1 && 101 <= pos.I[2] <= 150 && d == U && return CartesianIndex(200, pos.I[2] - 100), U
    pos.I[1] > 200 && 1 <= pos.I[2] <= 50 && d == D && return CartesianIndex(1, pos.I[2] + 100), D

    pos.I[2] < 51 && 1 <= pos.I[1] <= 50 && d == L && return CartesianIndex(151 - pos.I[1], 1), R
    pos.I[2] < 1 && 101 <= pos.I[1] <= 150 && d == L && return CartesianIndex(51 - (pos.I[1] - 100), 51), R
    pos.I[2] > 150 && 1 <= pos.I[1] <= 50 && d == R && return CartesianIndex(151 - pos.I[1], 100), L
    pos.I[2] > 100 && 101 <= pos.I[1] <= 150 && d == R && return CartesianIndex(51 - (pos.I[1] - 100), 150), L
    return pos, d
end

function getNewPos(gameMap::Array{Int,2}, pos::CartesianIndex{2}, direction::Direction, step::Int, ::Val{1})
    tomove = getMoveStep(direction)
    iszero = false
    tryPos = pos
    while step > 0
        tryPos = iszero ? inBound(tryPos + tomove) : inBound(pos + tomove)
        if gameMap[tryPos] == 1
            pos = tryPos
            step -= 1
        elseif gameMap[tryPos] == -1
            break
        else
            iszero = true
        end
    end
    return pos, direction
end

function getNewPos(gameMap::Array{Int,2}, pos::CartesianIndex{2}, direction::Direction, step::Int, ::Val{2})
    while step > 0
        tomove = getMoveStep(direction)
        tryPos, trydirection = inBound(pos + tomove, direction)
        if gameMap[tryPos] == 1
            pos = tryPos
            direction = trydirection
            step -= 1
        elseif gameMap[tryPos] == -1
            break
        end
    end
    return pos, direction
end

function move(gameMap::Array{Int,2}, startPos::CartesianIndex{2}, pathDescription::Vector{String}, ::Val{N}) where {N}
    pos = startPos
    direction = R
    for i in eachindex(pathDescription)
        if pathDescription[i] == "R"
            direction = mod(getDirectionNum(direction) + 1, 0:3) |> Direction
        elseif pathDescription[i] == "L"
            direction = mod(getDirectionNum(direction) - 1, 0:3) |> Direction
        else
            step = parse(Int, pathDescription[i])
            pos, direction = getNewPos(gameMap, pos, direction, step, Val(N))
        end
    end
    return pos, direction
end

getPassWord(pos::CartesianIndex{2}, d::Direction) = pos.I[1] * 1000 + pos.I[2] * 4 + getDirectionNum(d)

gameMap, pathDescription = readData()
startPos = CartesianIndex(1, findfirst(gameMap[1, :] .== 1))
pos, direction = move(gameMap, startPos, pathDescription, Val(1))
println("Part One Password: $(getPassWord(pos, direction))")
pos, direction = move(gameMap, startPos, pathDescription, Val(2))
# println("Pos: $(pos), Direction: $(direction)")
println("Part Two Password: $(getPassWord(pos, direction))")

using BenchmarkTools
function benchmark()
    gameMap, pathDescription = readData()
    startPos = CartesianIndex(1, findfirst(gameMap[1, :] .== 1))
    move(gameMap, startPos, pathDescription, Val(1))
    move(gameMap, startPos, pathDescription, Val(2))
end
@btime benchmark()