const JUMP_MAP = Dict([
    0 => (7, 4)
    1 => (3, 0)
    2 => (3, 1)
    3 => (7, 0)
    4 => (5, 6)
    5 => (2, 1)
    6 => (5, 2)
    7 => (4, 6)
])

const DIV_NUM = Dict([
    0 => 3
    1 => 17
    2 => 2
    3 => 19
    4 => 11
    5 => 5
    6 => 13
    7 => 7
])

const VALUEMANAGER = DIV_NUM |> values |> prod

monkey(::Val{0}, old::Int, ::Val{0}) = (old * 5) ÷ 3
monkey(::Val{1}, old::Int, ::Val{0}) = (old + 6) ÷ 3
monkey(::Val{2}, old::Int, ::Val{0}) = (old + 5) ÷ 3
monkey(::Val{3}, old::Int, ::Val{0}) = (old + 2) ÷ 3
monkey(::Val{4}, old::Int, ::Val{0}) = (old * 7) ÷ 3
monkey(::Val{5}, old::Int, ::Val{0}) = (old + 7) ÷ 3
monkey(::Val{6}, old::Int, ::Val{0}) = (old + 1) ÷ 3
monkey(::Val{7}, old::Int, ::Val{0}) = abs2(old) ÷ 3

monkey(::Val{0}, old::Int, ::Val{1}) = (old * 5) % VALUEMANAGER
monkey(::Val{1}, old::Int, ::Val{1}) = (old + 6) % VALUEMANAGER
monkey(::Val{2}, old::Int, ::Val{1}) = (old + 5) % VALUEMANAGER
monkey(::Val{3}, old::Int, ::Val{1}) = (old + 2) % VALUEMANAGER
monkey(::Val{4}, old::Int, ::Val{1}) = (old * 7) % VALUEMANAGER
monkey(::Val{5}, old::Int, ::Val{1}) = (old + 7) % VALUEMANAGER
monkey(::Val{6}, old::Int, ::Val{1}) = (old + 1) % VALUEMANAGER
monkey(::Val{7}, old::Int, ::Val{1}) = abs2(old) % VALUEMANAGER


function readData(path="data/2022/day11.txt")
    rawData = readlines(path) .|> strip
    filter!(x -> !isempty(x), rawData)
    data = split.(rawData, ':')
    exItems = Expr(:vect)
    for ind in 1:6:length(data)
        oneItem = Expr(:vect)
        append!(oneItem.args, parse.(Int, split(strip(data[ind+1][2]), ",")))
        push!(exItems.args, oneItem)
    end
    return eval(exItems)
end

readData()

function part1(monkeyItems)
    l = length(monkeyItems)
    ts = zeros(Int, l)
    for _ in Base.OneTo(20)
        for i in Base.OneTo(l)
            for _ in Base.OneTo(length(monkeyItems[i]))
                newLevel = monkey(Val(i - 1), popfirst!(monkeyItems[i]), Val(0))
                if newLevel % DIV_NUM[i-1] == 0
                    push!(monkeyItems[JUMP_MAP[i-1][1]+1], newLevel)
                else
                    push!(monkeyItems[JUMP_MAP[i-1][2]+1], newLevel)
                end
                ts[i] += 1
            end
        end
    end
    return prod(sort(ts, rev=true)[1:2])
end

function part2(monkeyItems)
    l = length(monkeyItems)
    ts = zeros(Int, l)
    for _ in 1:10000
        for i in Base.OneTo(length(monkeyItems))
            for _ in Base.OneTo(length(monkeyItems[i]))
                newLevel = monkey(Val(i - 1), popfirst!(monkeyItems[i]), Val(1))
                if newLevel % DIV_NUM[i-1] == 0
                    push!(monkeyItems[JUMP_MAP[i-1][1]+1], newLevel)
                else
                    push!(monkeyItems[JUMP_MAP[i-1][2]+1], newLevel)
                end
                ts[i] += 1
            end
        end
    end
    return prod(sort(ts, rev=true)[1:2])
end


using BenchmarkTools
@btime begin
    items = readData()
    part1(deepcopy(items)), part2(items)
end