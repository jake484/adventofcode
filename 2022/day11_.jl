function readData(path="data/2022/day11.txt")
    rawData = readlines(path) .|> strip
    filter!(x -> !isempty(x), rawData)
    data = split.(rawData, ':')

    valueManager = 1
    for ind in 1:6:length(data)
        valueManager *= parse(Int, split(strip(data[ind+3][2]), " ")[end])
    end
    println(valueManager)

    ex = Expr(:block)
    for ind in 1:6:length(data)
        push!(ex.args, :(
            function $(Symbol(replace(data[ind][1], " " => "")))(old::Int, ::Val{1})
                $(Meta.parse(strip(data[ind+2][2])))
                new ÷= 3
                if new % $(parse(Int, split(strip(data[ind+3][2]), " ")[end])) == 0
                    return $(parse(Int, split(strip(data[ind+4][2]), " ")[end])), new
                else
                    return $(parse(Int, split(strip(data[ind+5][2]), " ")[end])), new
                end
            end
        ))
        push!(ex.args, :(
            function $(Symbol(replace(data[ind][1], " " => "")))(old::Int, ::Val{2})
                $(Meta.parse(strip(data[ind+2][2])))
                new %= $valueManager
                if new % $(parse(Int, split(strip(data[ind+3][2]), " ")[end])) == 0
                    return $(parse(Int, split(strip(data[ind+4][2]), " ")[end])), new
                else
                    return $(parse(Int, split(strip(data[ind+5][2]), " ")[end])), new
                end
            end
        ))
    end
    eval(ex)

    exItems = Expr(:vect)
    for ind in 1:6:length(data)
        oneItem = Expr(:vect)
        append!(oneItem.args, parse.(Int, split(strip(data[ind+1][2]), ",")))
        push!(exItems.args, oneItem)
    end
    return eval(exItems)
end

function part1(monkeyItems)
    l = length(monkeyItems)
    ts = zeros(Int, l)
    for _ in Base.OneTo(20)
        for i in Base.OneTo(l)
            if length(monkeyItems[i]) != 0
                for _ in 1:length(monkeyItems[i])
                    poped, newLevel = eval(Symbol("Monkey" * string(i - 1)))(popfirst!(monkeyItems[i]), Val(1))
                    push!(monkeyItems[poped+1], newLevel)
                    ts[i] += 1
                end
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
            if length(monkeyItems[i]) != 0
                for _ in 1:length(monkeyItems[i])
                    poped, newLevel = eval(Symbol("Monkey" * string(i - 1)))(popfirst!(monkeyItems[i]), Val(2))
                    push!(monkeyItems[poped+1], newLevel)
                    ts[i] += 1
                end
            end
        end
    end
    return prod(sort(ts, rev=true)[1:2])
end

items = readData()
using BenchmarkTools
@btime begin
    part1(items), part2(items)
end