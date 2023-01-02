function readData(path="data/2021/day18.txt")
    return readlines(path)
end

addTwoPair(ls::String, rs::String) = "[" * ls * "," * rs * "]"

const regex = r"(\d\d+)"

function scanPair(str::String)
    nestedDepth = 0
    pairStart = 0
    for i in eachindex(str)
        if str[i] == '['
            nestedDepth += 1
            nestedDepth > 4 && (pairStart = i)
        elseif str[i] == ']'
            nestedDepth > 4 && return (pairStart, i)
            nestedDepth -= 1
        end
    end
    return (-1, -1)
end

function scanOneNum(str::String)
    m = match(regex, str)
    isnothing(m) && return -1, -1
    return parse(Int, m.match), m.offset
end

function findFirstRegular(str::String, startIndex::Int, direction::Int)::Tuple{Int,Int}
    startIndex += direction
    while checkbounds(Bool, str, startIndex) && !isdigit(str[startIndex])
        startIndex += direction
    end
    checkbounds(Bool, str, startIndex) || return (-1, -1)
    num = str[startIndex]
    while isdigit(str[startIndex+direction])
        num *= str[startIndex+direction]
        startIndex += direction
    end
    direction == -1 && return parse(Int, reverse(string(num))), startIndex
    return parse(Int, num), startIndex
end

function explodeOnePair(str::String)
    startIndex, stopIndex = scanPair(str)
    startIndex == -1 && return str
    newStr = ""
    oldIndex = firstindex(str)
    l, r = parse.(Int, split(str[startIndex+1:stopIndex-1], ','))
    leftNum, leftNumIndex = findFirstRegular(str, startIndex, -1)
    rightNum, rightNumIndex = findFirstRegular(str, stopIndex, 1)
    if leftNum == -1
        newStr *= str[oldIndex:startIndex-1] * '0'
        oldIndex = stopIndex + 1
    else
        newStr *= str[oldIndex:leftNumIndex-1] * string(leftNum + l)
        oldIndex = leftNumIndex + length(string(leftNum))
        newStr *= str[oldIndex:startIndex-1] * '0'
        oldIndex = stopIndex + 1
    end
    if rightNum == -1
        newStr *= str[oldIndex:end]
    else
        newStr *= str[oldIndex:rightNumIndex-length(string(rightNum))] * string(rightNum + r)
        oldIndex = rightNumIndex + 1
        newStr *= str[oldIndex:end]
    end
    return newStr
end

function explodePair(str::String)
    while true
        newStr = explodeOnePair(str)
        newStr == str && return str
        str = newStr
    end
end

function splitOnePair(str::String)
    num, offset = scanOneNum(str)
    num == -1 && return str
    newStr = ""
    leftNum = fld(num, 2)
    rightNum = fld1(num, 2)
    newStr *= str[1:offset-1] * '[' * string(leftNum) * ',' * string(rightNum) * ']' * str[offset+length(string(num)):end]
    return newStr
end

function explodeAndSplit(str::String)
    while true
        newStr = str |> explodePair |> splitOnePair
        newStr == str && return str
        str = newStr
    end
end

function addPairs(data::Vector{String})
    pair = popfirst!(data)
    while !isempty(data)
        pair = addTwoPair(pair, popfirst!(data))
        pair = explodeAndSplit(pair)
    end
    return pair
end

sumTwoPair(ls::String, rs::String) = addTwoPair(ls, rs) |> explodeAndSplit |> Meta.parse |> eval |> sumMagnitude

solve_P1(data::Vector{String}) = data |> addPairs |> Meta.parse |> eval |> sumMagnitude

function solve_P2(data::Vector{String})
    maxMagnitude = -1
    for i in eachindex(data), j in eachindex(data)
        i == j && continue
        maxMagnitude = max(maxMagnitude, sumTwoPair(data[i], data[j]))
    end
    return maxMagnitude
end
# 递归累加多重数组的和
function sumMagnitude(arr::Vector)
    return 3 * sumMagnitude(arr[1]) + 2 * sumMagnitude(arr[2])
end

sumMagnitude(arr::Int64) = arr


# data = readData()
# solve_P1(copy(data))
using BenchmarkTools
@btime begin
    data = readData()
    solve_P1(copy(data))
    solve_P2(data)
end
