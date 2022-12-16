# 读取数据
rawData = readlines("data/day15.txt")

# 用':'和','分割数据
rawData = split.(rawData, (c -> c == ',' || c == ':'))

# 用正则表达式提取数字字符串数组中的数字
data = map(x -> map(y -> parse(Int, match(r"[0-9]+", y).match), x), rawData)

# 将data中的数字转换坐标
coordinates = map(x -> [x[1], x[2], abs(x[3] - x[1]) + abs(x[4] - x[2])], data)

# 在y=2000000的x范围
yTarget = 2000000
xRanges = map(coordinates) do x
    if x[2] - x[3] <= yTarget <= x[2] + x[3]
        xl = x[3] - abs(yTarget - x[2])
        return x[1]-xl:x[1]+xl
    else
        return nothing
    end
end

# 打印coordinates与xRanges
for i in eachindex(coordinates)
    println(data[i], "\n", xRanges[i], "\n================")
end

# 将xRanges中的nothing去掉
r = filter(x -> !isnothing(x), xRanges)

# 计算data中y=2000000的个数
tominus = Tuple{Int64,Int64}[]
for i in data
    if i[4] == yTarget
        push!(tominus, (i[3], i[4]))
    end
    if i[2] == yTarget
        push!(tominus, (i[1], i[2]))
    end
end
# 将r中的范围合并
r = union(r...)

# 减去Beacon
for i in tominus
    if i[1] in r
        popat!(r, findfirst(x -> x == i[1], r))
    end
end
println(lastindex(r))
