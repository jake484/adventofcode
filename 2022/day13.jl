
# 重载compare函数，使其可以比较嵌套数组
compare(a::Int64, b::Int64) = a < b
function compare(a::Vector, b::Int64)
    isempty(a) && return true
    return compare(a, [b])
end
function compare(a::Int64, b::Vector)
    isempty(b) && return false
    return compare([a], b)
end

# 重载isequal函数，使其可以比较嵌套数组
isequal(a::Int64, b::Int64) = a == b
function isequal(a::Vector, b::Int64)
    isempty(a) && return false
    return isequal(a, [b])
end
function isequal(a::Int64, b::Vector)
    isempty(b) && return false
    return isequal([a], b)
end

# 递归比较两个嵌套数组
function compare(a::Vector, b::Vector)
    isempty(a) && !isempty(b) && return true
    isempty(b) && !isempty(a) && return false
    bend = lastindex(b)
    aend = lastindex(a)
    astart = firstindex(a)
    bstart = firstindex(b)
    while astart <= aend && bstart <= bend
        if isequal(a[astart], b[bstart])
            astart += 1
            bstart += 1
        else
            return compare(a[astart], b[bstart])
        end
    end
    return aend < bend
end

# 递归比较两个嵌套数组是否相等
function isequal(a::Vector, b::Vector)
    isempty(a) && isempty(b) && return true
    isempty(a) && !isempty(b) && return false
    isempty(b) && !isempty(a) && return false
    bend = lastindex(b)
    aend = lastindex(a)
    astart = firstindex(a)
    bstart = firstindex(b)
    while astart <= aend && bstart <= bend
        if isequal(a[astart], b[bstart])
            astart += 1
            bstart += 1
        else
            return false
        end
    end
    # 只有当两个数组都遍历完毕时且长度相等时，才返回true
    aend == bend && return true
    return false
end

using BenchmarkTools
@btime begin
    rawData = readlines("data/2022/day13.txt")
    filter!(x -> x != "", rawData)
    data = @. eval(Meta.parse(rawData))
    # part one
    s = 0
    for i in 2:2:lastindex(data)
        if compare(data[i-1], data[i])
            s += i >> 1
        end
    end
    # part two
    newdata = deepcopy(data)
    push!(newdata, [[2]], [[6]])
    sort!(newdata, lt=compare)
    prod(findall(x -> x == [[2]] || x == [[6]], newdata))
end

# println("Part one answer: ", s)
# println("Part two answer: ", prod(findall(x -> x == [[2]] || x == [[6]], newdata)))
