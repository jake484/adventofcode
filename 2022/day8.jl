function readData(path="data/2022/day8.txt")
    data = readlines(path)
    l = length(data)
    map = zeros(Int8, l, l)
    for i in Base.OneTo(l), j in Base.OneTo(l)
        map[i, j] = data[i][j] - '0'
    end
    return map
end

# part one 
function part1(map)
    l = size(map)[1]
    isVisalbeMatrix = zeros(Int8, size(map))
    for i in 1:l
        m = -1
        for j in 1:l-1
            isVisalbeMatrix[i, j] == 0 && map[i, j] > m && (isVisalbeMatrix[i, j] = 1)
            m = max(m, map[i, j])
        end
    end
    for i in 1:l
        m = -1
        for j in l:-1:2
            isVisalbeMatrix[i, j] == 0 && map[i, j] > m && (isVisalbeMatrix[i, j] = 1)
            m = max(m, map[i, j])
        end
    end
    for j in 1:l
        m = -1
        for i in 1:l-1
            isVisalbeMatrix[i, j] == 0 && map[i, j] > m && (isVisalbeMatrix[i, j] = 1)
            m = max(m, map[i, j])
        end
    end
    for j in 1:l
        m = -1
        for i in l:-1:2
            isVisalbeMatrix[i, j] == 0 && map[i, j] > m && (isVisalbeMatrix[i, j] = 1)
            m = max(m, map[i, j])
        end
    end
    return sum(isVisalbeMatrix)
end



# part two
function part2(map)
    l = size(map)[1]
    res = ones(Int, l, l)
    for i in 1:l
        for j in 1:l
            canSee = ones(Int, 4)
            m = i - 1
            while m > 1 && map[i, j] > map[m, j]
                canSee[1] += 1
                m -= 1
            end
            m = i + 1
            while m < l && map[i, j] > map[m, j]
                canSee[2] += 1
                m += 1
            end
            m = j - 1
            while m > 1 && map[i, j] > map[i, m]
                canSee[3] += 1
                m -= 1
            end
            m = j + 1
            while m < l && map[i, j] > map[i, m]
                canSee[4] += 1
                m += 1
            end
            res[i, j] = prod(canSee)
        end
    end
    maximum(res)
end

using BenchmarkTools
@btime begin
    map = readData()
    part1(map), part2(map)
end