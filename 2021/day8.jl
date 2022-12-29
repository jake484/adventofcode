const ULIST = [2, 3, 4, 7]
const LENMAP = Dict{Int,Int}(
    2 => 1,
    3 => 7,
    4 => 4,
    7 => 8
)

function readData(path="data/2021/day8.txt")
    data = readlines(path)
    data = split.(data, c -> c == ' ' || c == '|')
    return map(x -> string.(filter(!=(""), x)), data)
end

function isin(a::String, b::String)
    all(map(x -> occursin(x, b), collect(a)))
end

function getMap(str::Vector{String})
    string2num = Dict{String,Int}()
    num2string = Dict{Int,String}()
    for i in 1:10
        if str[i] |> length ∈ ULIST
            string2num[str[i]] = LENMAP[str[i]|>length]
            num2string[LENMAP[str[i]|>length]] = str[i]
        end
    end
    for i in 1:10
        if str[i] |> length == 6
            if isin(num2string[4], str[i])
                string2num[str[i]] = 9
                num2string[9] = str[i]
            elseif isin(num2string[1], str[i])
                string2num[str[i]] = 0
                num2string[0] = str[i]
            else
                string2num[str[i]] = 6
                num2string[6] = str[i]
            end
        end
    end
    for i in 1:10
        if str[i] |> length == 5
            if isin(num2string[1], str[i])
                string2num[str[i]] = 3
                num2string[3] = str[i]
            elseif isin(str[i], num2string[9])
                string2num[str[i]] = 5
                num2string[5] = str[i]
            else
                string2num[str[i]] = 2
                num2string[2] = str[i]
            end
        end
    end
    return string2num
end

function solve_P1(strs::Vector{Vector{String}})
    s = 0
    for str in strs
        s += count(x -> length(x) ∈ ULIST, str[end-3:end])
    end
    return s
end

function solve_P2(strs::Vector{Vector{String}})
    s = 0
    for str in strs
        num = 0
        m = getMap(str)
        for n in str[end-3:end]
            for (k, v) in m
                if length(n) == length(k) && isin(n, k)
                    num = num * 10 + v
                    break
                end
            end
        end
        s += num
    end
    return s
end

using BenchmarkTools
@btime begin
    data = readData()
    solve_P1(data)
    solve_P2(data)
end
