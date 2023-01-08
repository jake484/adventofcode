function readData(path="data/2021/day24.txt")
    data = readlines(path)
    numIndex = (4, 5, 15)
    numRegex = (r"div z (-?\d+)", r"add x (-?\d+)", r"add y (-?\d+)")
    programTpye, typeM, typeD = Dict{Int,Bool}(), Dict{Int,Int}(), Dict{Int,Int}()
    for i in 1:18:length(data)
        nums = map(Base.OneTo(3)) do index
            parse(Int, match(numRegex[index], data[i+numIndex[index]]).captures[1])
        end
        if nums[1] == 1
            programTpye[i÷18+1] = true
            typeM[i÷18+1] = nums[3]
        else
            programTpye[i÷18+1] = false
            typeD[i÷18+1] = nums[2]
        end
    end
    return programTpye, typeM, typeD
end

function findLagestNum!(lagestNum::Vector{Int}, z::Int, segmentNum::Int)
    if segmentNum == 15
        z == 0 && return true
        return false
    end
    if PROGRAM_TYPE[segmentNum]
        for inp in 9:-1:1
            push!(lagestNum, inp)
            findLagestNum!(lagestNum, z * 26 + inp + MUTI_INDEX[segmentNum], segmentNum + 1) && return true
            pop!(lagestNum)
        end
    else
        value = z % 26 + DIV_INDEX[segmentNum]
        if value ∈ Base.OneTo(9)
            push!(lagestNum, value)
            findLagestNum!(lagestNum, z ÷ 26, segmentNum + 1) && return true
            pop!(lagestNum)
        end
    end
    return false
end

function findLowestNum!(lagestNum::Vector{Int}, z::Int, segmentNum::Int)
    if segmentNum == 15
        z == 0 && return true
        return false
    end
    if PROGRAM_TYPE[segmentNum]
        for inp in Base.OneTo(9)
            push!(lagestNum, inp)
            findLagestNum!(lagestNum, z * 26 + inp + MUTI_INDEX[segmentNum], segmentNum + 1) && return true
            pop!(lagestNum)
        end
    else
        value = z % 26 + DIV_INDEX[segmentNum]
        if value ∈ Base.OneTo(9)
            push!(lagestNum, value)
            findLagestNum!(lagestNum, z ÷ 26, segmentNum + 1) && return true
            pop!(lagestNum)
        end
    end
    return false
end


const PROGRAM_TYPE, MUTI_INDEX, DIV_INDEX = readData()

using BenchmarkTools
@btime begin
    lagestNum, lowerstNum = Int[], Int[]
    findLagestNum!(lagestNum, 0, 1)
    findLowestNum!(lowerstNum, 0, 1)
    join(lagestNum), join(lowerstNum)
end


