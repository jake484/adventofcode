rawData = readlines("data/2022/day11.txt")
rawData = strip.(rawData)
filter!(x -> !isempty(x), rawData)
data = split.(rawData, ':')

# part one

# 解析数据，并生成函数
ex = Expr(:block)
for ind in 1:6:length(data)
    push!(ex.args, :(
        function $(Symbol(replace(data[ind][1], " " => "")))(old::Int)
            $(Meta.parse(strip(data[ind+2][2])))
            new ÷= 3
            if new % $(parse(Int, split(strip(data[ind+3][2]), " ")[end])) == 0
                return $(parse(Int, split(strip(data[ind+4][2]), " ")[end])), new
            else
                return $(parse(Int, split(strip(data[ind+5][2]), " ")[end])), new
            end
        end
    ))
end
eval(ex)

# 生成初始数据
exItems = Expr(:vect)
for ind in 1:6:length(data)
    oneItem = Expr(:vect)
    append!(oneItem.args, parse.(Int, split(strip(data[ind+1][2]), ",")))
    push!(exItems.args, oneItem)
end
monkeyItems = eval(exItems)

# 进行模拟，记录数据
ts = zeros(Int, length(monkeyItems))
for time in 1:20
    for i in 1:length(monkeyItems)
        if length(monkeyItems[i]) != 0
            for j in 1:length(monkeyItems[i])
                poped, newLevel = eval(Symbol("Monkey" * string(i - 1)))(popfirst!(monkeyItems[i]))
                push!(monkeyItems[poped+1], newLevel)
                ts[i] += 1
            end
        end
    end
    # println("====$(time)====")
    # println(monkeyItems)
end

println(prod(sort(ts, rev=true)[1:2]))


# part two

begin

    # 新的数据管理器
    valueManager = 1
    for ind in 1:6:length(data)
        valueManager *= parse(Int, split(strip(data[ind+3][2]), " ")[end])
    end

    ex = Expr(:block)
    for ind in 1:6:length(data)
        push!(ex.args, :(
            function $(Symbol(replace(data[ind][1], " " => "")))(old::Int)
                $(Meta.parse(strip(data[ind+2][2])))
                new %= valueManager
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

    monkeyItems = eval(exItems)

    ts = zeros(Int, length(monkeyItems))

    for time in 1:10000
        for i in 1:length(monkeyItems)
            if length(monkeyItems[i]) != 0
                for j in 1:length(monkeyItems[i])
                    poped, newLevel = eval(Symbol("Monkey" * string(i - 1)))(popfirst!(monkeyItems[i]))
                    push!(monkeyItems[poped+1], newLevel)
                    ts[i] += 1
                end
            end
        end
        # println("====$(time)====")
        # println(monkeyItems)
    end
    println(ts)
    println(prod(sort(ts, rev=true)[1:2]))
end
