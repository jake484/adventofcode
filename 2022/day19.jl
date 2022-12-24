using JuMP
import DataFrames
import HiGHS

function readData(path="data/2022/day19.txt")
    rawData = readlines(path)
    rawData = split.(rawData, c -> c == '.' || c == ':')
    regs = [
        r"Blueprint (\d+)",
        r"costs (\d+) ore",
        r"costs (\d+) ore",
        r"costs (\d+) ore and (\d+) clay",
        r"costs (\d+) ore and (\d+) obsidian",
    ]
    d = Dict{Int,Vector{Vector{Int64}}}()
    for line in rawData |> eachindex
        c = map(x -> zeros(Int64, 4), 1:4)
        r = Vector{Int64}[]
        for i in 1:5
            m = match(regs[i], rawData[line][i]).captures
            m = map(x -> parse(Int64, x), m)
            push!(r, m)
        end
        c[1][1] = r[2][1]
        c[1][2] = r[3][1]
        c[1][3] = r[4][1]
        c[1][4] = r[5][1]
        c[2][3] = r[4][2]
        c[3][4] = r[5][2]
        d[r[1][1]] = c
    end
    return d
end


function solve_1(costs, periods)
    model = Model(HiGHS.Optimizer)
    set_silent(model)
    names = ["ore", "clay", "obsidian", "geode"]
    # robots为每个机器人的数量，obtains为每个机器人每个周期的产出，isBuild为每个机器人每个周期是否建造
    @variable(model, robots[names, periods], Int)
    @variable(model, obtains[names, periods], Int)
    @variable(model, isBuild[names, periods], Bin)
    # 矿石量等于上一周期的矿石量加上本周期的产出减去本周期的消耗
    for (p1, p2) ∈ zip(periods[1:end-1], periods[2:end])
        @constraint(model, [ind = 1:4], obtains[names[ind], p2] == obtains[names[ind], p1] + robots[names[ind], p2] - sum(costs[ind] .* isBuild[:, p2]))
    end
    # 矿石足够才能建造机器人
    for (p1, p2) ∈ zip(periods[1:end-1], periods[2:end])
        @constraint(model, [ind = 1:4], obtains[names[ind], p1] >= sum(costs[ind] .* isBuild[:, p2]))
    end
    # 建造机器人
    for (p1, p2) ∈ zip(periods[1:end-1], periods[2:end])
        @constraint(model, [ind = 1:4], robots[names[ind], p2] == robots[names[ind], p1] + isBuild[names[ind], p1])
    end
    # 一次只能建造一个机器人
    @constraint(model, [i = periods], sum(isBuild[:, i]) <= 1)
    # 初始条件
    @constraint(model, [ind = 2:4], robots[names[ind], 1] == 0)
    @constraint(model, [ind = 1:1], robots[names[ind], 1] == 1)
    @constraint(model, [ind = 2:4], obtains[names[ind], 1] == 0)
    @constraint(model, [ind = 1:1], obtains[names[ind], 1] == 1)
    @constraint(model, [ind = 1:4], isBuild[names[ind], 1] == 0)
    # 目标函数
    @objective(model, Max, obtains["geode", lastindex(periods)])
    optimize!(model)
    return objective_value(model) |> Int
end

function solve_P1()
    d = readData()
    println("=====Part 1=======")
    s = 0
    for (i, c) in d
        println("  第$(i)个结果:\t", solve_1(c, 1:24))
        s += solve_1(c, 1:24) * i
    end
    println("  s = $s")
end

function solve_P2()
    d = readData()
    println("=====Part 2=======")
    begin
        s = 1
        for i in 1:3
            res = solve_1(d[i], 1:32)
            println("  第$(i)个结果:\t", res)
            s *= res
        end
    end
    println("  s = $s")
end


using BenchmarkTools
function benchmark()
    solve_P1()
    solve_P2()
end
@btime benchmark()