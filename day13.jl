rawData = readlines("data/day13.txt")
filter!(x -> x != "", rawData)
data = @. eval(Meta.parse(rawData))

compare(a::Int64, b::Int64) = a < b

function compare(a::Vector, b::Int64)
    isempty(a) && return true
    return compare(a, [b])
end
function compare(a::Int64, b::Vector)
    isempty(b) && return false
    return compare([a], b)
end

isequal(a::Int64, b::Int64) = a == b
function isequal(a::Vector, b::Int64)
    isempty(a) && return false
    return isequal(a, [b])
end
function isequal(a::Int64, b::Vector)
    isempty(b) && return false
    return isequal([a], b)
end

# function compare(a::Vector, b::Vector)
#     isempty(a) && isempty(b) && return true
#     isempty(a) && !isempty(b) && return true
#     isempty(b) && !isempty(a) && return false
#     if isequal(first(a), first(b))
#         popfirst!(a)
#         popfirst!(b)
#         return compare(a, b)
#     else
#         return compare(a[1], b[1])
#     end
# end

# compare([10, 1], [[10, 0], 6, [8, 6, 7], 1, 2]
# )

# 展平嵌套数组
# function flatten(arr::Vector)
#     res = Int64[]
#     for i in arr
#         if isa(i, Vector)
#             append!(res, flatten(i))
#         else
#             push!(res, i)
#         end
#     end
#     if all(map(==(-1), res)) || isempty(res)
#         push!(res, -1)
#     end
#     return res
# end

# 递归比较两个嵌套数组

# s = 0
# for i in 2:2:lastindex(data)
#     fa = flatten(data[i-1])
#     fb = flatten(data[i])
#     # println(fa)
#     # println(fb)
#     if fa < fb
#         global s += i >> 1
#     end
#     println("******* s = $s *******")
# end
# s

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
    return true
end

s = 0
for i in 2:2:lastindex(data)
    if compare(data[i-1], data[i])
        global s += i >> 1
    end
end
s

# v = [
#     [[[4,5,10],[7,[10,3,1],[2,6],10],[[6,0,8,9,6],4,[]],[]],[9,[],10]],
#     [[],[7],[10,10,[6]],[[[2,4],[6,2,2],0],6],[[[2,3,0,0,2],[6,5,7,2],2,4],6,6]]
    
# ]
# compare(v[1], v[2])