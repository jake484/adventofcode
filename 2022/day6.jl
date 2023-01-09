using DataStructures
readData(path="data/2022/day6.txt") = readline(path)
# part one
# function part1(data, n=4)
#     for i in Base.OneTo(length(data) - n + 1)
#         length(unique(data[i:i+n-1])) == n && return i + n - 1
#     end
# end

function part1(data, n=4)
    left, right = 1, n
    cnter = counter(data[left:right])
    len = length(data)
    length(cnter) == n && return right
    left, right = left , right + 1
    while right <= len
        inc!(cnter, data[right])
        dec!(cnter, data[left])
        cnter[data[left]] == 0 && reset!(cnter, data[left])
        length(cnter) == n && return right
        left += 1
        right += 1
    end
end

using BenchmarkTools
@btime begin
    data = readData()
    part1(data), part1(data, 14)
end