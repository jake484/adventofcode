# 读取数据
function readData(; path="data/2022/day23.txt", offset=10)
    data = readlines(path)
    ElfMaps = CartesianIndex{2}[]
    for i in eachindex(data)
        for j in eachindex(data[i])
            if data[i][j] == '#'
                push!(ElfMaps, CartesianIndex(i + offset, j + offset))
            end
        end
    end
    return ElfMaps
end

# 找到横纵坐标最大最小值
function findBound(Elfs::Vector{CartesianIndex{2}})
    ma = maximum(Elfs)
    mi = minimum(Elfs)
    minX = mi.I[1]
    maxX = ma.I[1]
    minY = mi.I[2]
    maxY = ma.I[2]
    return minX, maxX, minY, maxY
end

@enum Direction begin
    NORTH = 1
    SOUTH = 2
    WEST = 3
    EAST = 4
end

# 获取方向对应的移动坐标
function getMoveStep(direction::Direction)
    if direction == NORTH
        return CartesianIndex(-1, 0)
    elseif direction == EAST
        return CartesianIndex(0, 1)
    elseif direction == SOUTH
        return CartesianIndex(1, 0)
    else
        return CartesianIndex(0, -1)
    end
end

# 获取正方向以及对角方向的坐标
function getThreeDirections(direction::Direction)
    if direction == NORTH
        return (CartesianIndex(-1, 0), CartesianIndex(-1, 1), CartesianIndex(-1, -1))
    elseif direction == EAST
        return (CartesianIndex(0, 1), CartesianIndex(-1, 1), CartesianIndex(1, 1))
    elseif direction == SOUTH
        return (CartesianIndex(1, 0), CartesianIndex(1, 1), CartesianIndex(1, -1))
    else
        return (CartesianIndex(0, -1), CartesianIndex(-1, -1), CartesianIndex(1, -1))
    end
end

const allDirections = [
    CartesianIndex(-1, 0),
    CartesianIndex(-1, 1),
    CartesianIndex(0, 1),
    CartesianIndex(1, 1),
    CartesianIndex(1, 0),
    CartesianIndex(1, -1),
    CartesianIndex(0, -1),
    CartesianIndex(-1, -1),
]

# 获取下一个位置
function getProposeIndex(elfmap::BitMatrix, elf::CartesianIndex{2}, priority::Int)
    map(x -> !elfmap[elf+x], allDirections) |> all && return elf
    for i in 0:3
        direction = mod1(priority + i, 4) |> Direction
        checkDirection = getThreeDirections(direction)
        map(x -> !elfmap[elf+x], checkDirection) |> all && return elf + getMoveStep(direction)
    end
    return elf
end

# 
function MoveOneRound!(Elfs::Vector{CartesianIndex{2}}, priority::Int, offset=10)
    minX, maxX, minY, maxY = findBound(Elfs)
    ElfMap = falses(maxX - minX + 1 + 2offset, maxY - minY + 1 + 2offset)
    for elf in Elfs
        ElfMap[elf] = true
    end
    ElfPropose = CartesianIndex{2}[]
    for elf in Elfs
        push!(ElfPropose, getProposeIndex(ElfMap, elf, priority))
    end
    proposedMap = zeros(Int, maxX - minX + 1 + 2offset, maxY - minY + 1 + 2offset)
    for index in ElfPropose
        proposedMap[index] += 1
    end
    for i in eachindex(ElfPropose)
        if proposedMap[ElfPropose[i]] <= 1
            Elfs[i] = ElfPropose[i]
        end
    end
end

function countEmptyTiles(Elfs::Vector{CartesianIndex{2}}, offset=10)
    minX, maxX, minY, maxY = findBound(Elfs)
    ElfMap = falses(maxX - minX + 1 + 2offset, maxY - minY + 1 + 2offset)
    for elf in Elfs
        ElfMap[elf] = true
    end
    return count(!, ElfMap[minimum(Elfs):maximum(Elfs)])
end

function solve_P1(offset=10)
    Elfs = readData(offset=offset)
    for i in 1:10
        MoveOneRound!(Elfs, i, offset)
    end
    return countEmptyTiles(Elfs, offset)
end

function solve_P2(offset=10, round=2000)
    Elfs = readData(offset=offset)
    lastRoundElf = CartesianIndex{2}[]
    for i in 1:round
        lastRoundElf = copy(Elfs)
        MoveOneRound!(Elfs, i, offset)
        if lastRoundElf == Elfs
            return i
        end
        if i == round
            println(count(lastRoundElf .== Elfs))
        end
    end
    return -1
end

# println("Part One Answer: ", solve_P1(10))
# println("Part Two Answer: ", solve_P2(20, 2000))
using BenchmarkTools
function day23_benchmark()
    solve_P1(10)
    solve_P2(20, 2000)
end
@btime day23_benchmark()