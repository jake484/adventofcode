function readData(path, ::Val{18})
    return tuple(readlines(path)...)
end

import DataStructures: Stack, top

function handleNum!(toEval::Int, stack::Stack)
    if isempty(stack)
        push!(stack, toEval)
        return nothing
    end
    poped = pop!(stack)
    if poped == '+'
        push!(stack, pop!(stack) + toEval)
    else
        push!(stack, pop!(stack) * toEval)
    end
    return nothing
end

function handleNum!(toEval::Int, stack::Stack, ::Val{:+})
    if isempty(stack)
        push!(stack, toEval)
        return nothing
    end
    if top(stack) == '+'
        pop!(stack)
        push!(stack, pop!(stack) + toEval)
    else
        push!(stack, toEval)
    end
    return nothing
end

function evalExpr!(str::String, startInd::Int, stack::Stack,
    END::Int=length(str))
    while startInd <= END
        if str[startInd] == ' '
            startInd += 1
        elseif isdigit(str[startInd])
            handleNum!(parse(Int, str[startInd]), stack)
            startInd += 1
        elseif str[startInd] == '('
            num, startInd = evalExpr!(str, startInd + 1, Stack{Union{Char,Int}}(), END)
            handleNum!(num, stack)
        elseif str[startInd] == ')'
            return pop!(stack), startInd + 1
        else
            push!(stack, str[startInd])
            startInd += 1
        end
    end
    return top(stack), startInd
end

function evalExprPlus!(str::String, startInd::Int, stack::Stack,
    END::Int=length(str))
    while startInd <= END
        if str[startInd] == ' '
            startInd += 1
        elseif isdigit(str[startInd])
            handleNum!(parse(Int, str[startInd]), stack, Val(:+))
            startInd += 1
        elseif str[startInd] == '('
            num, startInd = evalExprPlus!(str, startInd + 1, Stack{Union{Char,Int}}(), END)
            handleNum!(num, stack, Val(:+))
        elseif str[startInd] == ')'
            break
        else
            push!(stack, str[startInd])
            startInd += 1
        end
    end
    while length(stack) > 1
        handleNum!(pop!(stack), stack)
    end
    return top(stack), startInd + 1 
end

evalSum(data::Tuple) = sum(x -> evalExpr!(x, 1, Stack{Union{Char,Int}}())[1], data)

evalSumPlus(data::Tuple) = sum(x -> evalExprPlus!(x, 1, Stack{Union{Char,Int}}())[1], data)

function day18_main()
    data = readData("data/2020/day18.txt", Val(18))
    data |> evalSum
    data |> evalSumPlus
    return nothing
end

# test 
# data = readData("data/2020/day18.txt", Val(18))
# data |> evalSum
# data |> evalSumPlus
using BenchmarkTools
@info "day18 性能："
@btime day18_main()

