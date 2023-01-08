function getExpr(i::Int, a::Int, b::Int, c::Int)
    if a == 1
        return :(segment(::Val{$i}, z::Int, inp::Int) = z * 26 + inp + $c)
    else
        return :(segment(::Val{$i}, z::Int, inp::Int) = z % 26 + $b == inp ? z ÷ 26 : -1)
    end
end

function readData(path="data/2021/day24.txt")
    data = readlines(path)
    numIndex = (4, 5, 15)
    numRegex = (r"div z (-?\d+)", r"add x (-?\d+)", r"add y (-?\d+)")
    for i in 1:18:length(data)
        nums = map(Base.OneTo(3)) do index
            parse(Int, match(numRegex[index], data[i+numIndex[index]]).captures[1])
        end
        # println(getExpr(i ÷ 18 + 1, nums...))
        eval(getExpr(i ÷ 18 + 1, nums...))
    end
end

function segment(::Val{0}, z::Int, inp::Int) end


function findLagestNum!(lagestNum::Vector{Int}, z::Int, segmentNum::Int)
    z == -1 && return false
    if segmentNum == 15
        z == 0 && return true
        return false
    end
    for inp in 9:-1:1
        push!(lagestNum, inp)
        findLagestNum!(lagestNum, segment(Val(segmentNum), z, inp), segmentNum + 1) && return true
        pop!(lagestNum)
    end
    return false
end

readData()
# findLagestNum(0, 0, 1)
using BenchmarkTools
@btime begin
    lagestNum = Int[]
    findLagestNum!(lagestNum, 0, 1)
    join(lagestNum)
end



