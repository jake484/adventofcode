function readData(path, ::Val{5})
    return map(readlines(path)) do str
        str = replace(str, 'F' => 0, 'B' => 1, 'L' => 0, 'R' => 1)
        (parse(Int, str[1:7], base=2), parse(Int, str[8:10], base=2))
    end
end

import DataStructures: counter

function seatID(data::Vector)
    return maximum(i[1] * 8 + i[2] for i in data)
end
function findSeat(data::Vector)
    cnter = counter(i[1] for i in data)
    rowNum = findall(x -> values(x) <= 7, cnter)
    return map(rowNum) do ind
        return ind * 8 + sum(0:7) - sum(x -> x[1] == ind ? x[2] : 0, data)
    end
end

function day5_main()
    data = readData("data/2020/day5.txt", Val(5))
    data |> seatID
    data |> findSeat
    return nothing
end

# test
# data = readData("data/2020/day5.txt", Val(5))

# using BenchmarkTools
# @info "day5 性能："
# @btime day5_main()

