data = readlines("data/2022/day8.txt")
l = length(data)

# part one 
isVisalbeMatrix = falses(l, l)
for i in 1:l
    m = -1
    for j in 1:l-1
        if !isVisalbeMatrix[i, j]
            isVisalbeMatrix[i, j] = parse(Int, data[i][j]) > m ? true : false
        end
        m = max(m, parse(Int, data[i][j]))
    end
end
for i in 1:l
    m = -1
    for j in l:-1:2
        if !isVisalbeMatrix[i, j]
            isVisalbeMatrix[i, j] = parse(Int, data[i][j]) > m ? true : false
        end
        m = max(m, parse(Int, data[i][j]))
    end
end
for j in 1:l
    m = -1
    for i in 1:l-1
        if !isVisalbeMatrix[i, j]
            isVisalbeMatrix[i, j] = parse(Int, data[i][j]) > m ? true : false
        end
        m = max(m, parse(Int, data[i][j]))
    end
end
for j in 1:l
    m = -1
    for i in l:-1:2
        if !isVisalbeMatrix[i, j]
            isVisalbeMatrix[i, j] = parse(Int, data[i][j]) > m ? true : false
        end
        m = max(m, parse(Int, data[i][j]))
    end
end

count(isVisalbeMatrix)

# part two
res = ones(Int, l, l)
data = map(x -> parse.(Int, collect(x)), data)
for i in 1:l
    for j in 1:l
        canSee = ones(Int, 4)
        m = i - 1
        while m > 1 && data[i][j] > data[m][j]
            canSee[1] += 1
            m -= 1
        end
        m = i + 1
        while m < l && data[i][j] > data[m][j]
            canSee[2] += 1
            m += 1
        end
        m = j - 1
        while m > 1 && data[i][j] > data[i][m]
            canSee[3] += 1
            m -= 1
        end
        m = j + 1
        while m < l && data[i][j] > data[i][m]
            canSee[4] += 1
            m += 1
        end
        res[i, j] = prod(canSee)
    end
end

maximum(res)