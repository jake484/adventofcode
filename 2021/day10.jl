const LCS = ['{', '(', '[', '<']
const RCS = ['}', ')', ']', '>']
const ERRORNUM = Dict{Char,Int}(
    '}' => 1197,
    ')' => 3,
    ']' => 57,
    '>' => 25137,
)
const COMPLETENUM = Dict{Char,Int}(
    '{' => 3,
    '(' => 1,
    '[' => 2,
    '<' => 4,
)

function readData(path="data/2021/day10.txt")
    return readlines(path)
end

function getErrorPoints(str::String)
    stack = Char[]
    for i in eachindex(str)
        if str[i] in LCS
            push!(stack, str[i])
        elseif str[i] in RCS
            if isempty(stack)
                return ERRORNUM[str[i]]
            end
            latest = pop!(stack)
            findfirst(==(latest), LCS) == findfirst(==(str[i]), RCS) || return ERRORNUM[str[i]]
        end
    end
    return 0
end

function getCompleteLines(str::String)
    stack = Char[]
    for i in eachindex(str)
        if str[i] in LCS
            push!(stack, str[i])
        elseif str[i] in RCS
            if isempty(stack)
                return -1
            end
            latest = pop!(stack)
            findfirst(==(latest), LCS) == findfirst(==(str[i]), RCS) || return -1
        end
    end
    s = 0
    while !isempty(stack)
        s = s * 5 + COMPLETENUM[pop!(stack)]
    end
    return s
end

function solve_P1(strs::Vector{String})
    s = 0
    for str in strs
        s += getErrorPoints(str)
    end
    return s
end

function solve_P2(strs::Vector{String})
    s = Int[]
    for str in strs
        push!(s, getCompleteLines(str))
    end
    filter!(!=(-1), s)
    sort!(s)
    return s[lastindex(s)>>1+1]
end

using BenchmarkTools
@btime begin
    data = readData()
    solve_P1(data)
    solve_P2(data)
end

