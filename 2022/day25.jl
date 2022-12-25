function readData(path="data/2022/day25.txt")
    data = readlines(path)
    return data
end

function minusOne(s::Char)
    s == '=' && return '2', 1
    s == '-' && return '=', 0
    s == '0' && return '-', 0
    return s - 1, 0
end

function addOne(s::Char)
    s == '4' && return '0', 1
    return s + 1, 0
end

function dealCarry!(f::Function, str::Vector{Char}, index::Int, carry::Int)
    ncarry = 2
    while carry == 1
        str[index+ncarry], carry = f(str[index+ncarry])
        ncarry += 1
    end
end

function parse5FromSNAFU(str::String)
    str = reverse(str) |> collect
    nstr = ""
    index = 1
    while index <= length(str)
        if str[index] ∈ ['0', '1', '2']
            nstr *= str[index]
        elseif str[index] == '='
            nstr *= '3'
            str[index+1], carry = minusOne(str[index+1])
            dealCarry!(minusOne, str, index, carry)
        elseif str[index] == '-'
            nstr *= '4'
            str[index+1], carry = minusOne(str[index+1])
            dealCarry!(minusOne, str, index, carry)
        end
        index += 1
    end
    return reverse(nstr)
end

function parseSNAFUFrom5(str::String)
    str = reverse(str) |> collect
    nstr = ""
    index = 1
    while true
        if index > length(str)
            break
        end
        if str[index] ∈ ['0', '1', '2']
            nstr *= str[index]
        elseif str[index] == '3'
            nstr *= '='
            str[index+1], carry = addOne(str[index+1])
            dealCarry!(addOne, str, index, carry)
        elseif str[index] == '4'
            nstr *= '-'
            str[index+1], carry = addOne(str[index+1])
            dealCarry!(addOne, str, index, carry)
        end
        index += 1
    end
    return reverse(nstr)
end

function parse5From10(n::Int)
    nstr = ""
    while n > 0
        nstr *= string(n % 5)
        n ÷= 5
    end
    return reverse(nstr)
end

function solve(data::Vector{String})
    s = 0
    for i in data
        s += parse(Int, parse5FromSNAFU(i), base=5)
    end
    s = parse5From10(s)
    s = parseSNAFUFrom5(s)
    return s
end

using BenchmarkTools
@btime solve(readData())