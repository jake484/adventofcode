Base.@kwdef struct Package
    version::Int = 0
    typeid::Int = 0
    lengthtype::Int = -1
    sublength::Int = 0
    subpackages::Vector{Package} = Package[]
    literalvalue::Int = 0
end

const VERSION_LENGTH = 3
const TYPE_ID_LENGTH = 3
const LENGTH_TYPE_LENGTH = 1
const TRUETPEY = 11
const FALSETYPE = 15
const GROUP_LENGTH = 4

function Base.parse(str::String)
    bits = ""
    for ch in str
        bits *= string(parse(Int8, ch; base=16), base=2, pad=4)
    end
    return bits
end

function readData(path="data/2021/day16.txt")
    str = readline(path)
    return parse(str)
end


Base.parse(startIndex::Int, len::Int, str::String) = (parse(Int, str[startIndex:startIndex+len-1], base=2), startIndex + len)

function parsePackages(str::String, startIndex::Int=1)
    version, startIndex = parse(startIndex, VERSION_LENGTH, str)
    typeid, startIndex = parse(startIndex, TYPE_ID_LENGTH, str)
    subpackages = Package[]
    if typeid != 4
        lengthtype, startIndex = parse(startIndex, LENGTH_TYPE_LENGTH, str)
        if lengthtype == 0
            sublength, startIndex = parse(startIndex, FALSETYPE, str)
            STOP_INDEX = startIndex + sublength - 1
            while startIndex <= STOP_INDEX
                subpackage, startIndex = parsePackages(str, startIndex)
                push!(subpackages, subpackage)
            end
            return Package(version=version, typeid=typeid, lengthtype=lengthtype, sublength=sublength, subpackages=subpackages), startIndex
        else
            sublength, startIndex = parse(startIndex, TRUETPEY, str)
            for _ in Base.OneTo(sublength)
                subpackage, startIndex = parsePackages(str, startIndex)
                push!(subpackages, subpackage)
            end
            return Package(version=version, typeid=typeid, lengthtype=lengthtype, sublength=sublength, subpackages=subpackages), startIndex
        end
    else
        literalvalue = 0
        while str[startIndex] == '1'
            startIndex += 1
            value, startIndex = parse(startIndex, GROUP_LENGTH, str)
            literalvalue = (literalvalue << 4) + value
        end
        startIndex += 1
        value, startIndex = parse(startIndex, GROUP_LENGTH, str)
        literalvalue = (literalvalue << 4) + value
        return Package(version=version, typeid=typeid, literalvalue=literalvalue), startIndex
    end
end

function sumVersion(package::Package)
    sum = package.version
    for subpackage in package.subpackages
        sum += sumVersion(subpackage)
    end
    return sum
end

function handleSubpackages(package::Package, ::Val{0})
    isempty(package.subpackages) && return package.literalvalue
    s = 0
    for subpackage in package.subpackages
        s += handleSubpackages(subpackage, Val(subpackage.typeid))
    end
    return s
end

function handleSubpackages(package::Package, ::Val{1})
    isempty(package.subpackages) && return package.literalvalue
    s = 1
    for subpackage in package.subpackages
        s *= handleSubpackages(subpackage, Val(subpackage.typeid))
    end
    return s
end

function handleSubpackages(package::Package, ::Val{2})
    isempty(package.subpackages) && return package.literalvalue
    s = typemax(Int)
    for subpackage in package.subpackages
        s = min(handleSubpackages(subpackage, Val(subpackage.typeid)), s)
    end
    return s
end

function handleSubpackages(package::Package, ::Val{3})
    isempty(package.subpackages) && return package.literalvalue
    s = typemin(Int)
    for subpackage in package.subpackages
        s = max(handleSubpackages(subpackage, Val(subpackage.typeid)), s)
    end
    return s
end

handleSubpackages(package::Package, ::Val{4}) = package.literalvalue

function handleSubpackages(package::Package, ::Val{5})
    firstPackage, secondPackage = package.subpackages
    f = handleSubpackages(firstPackage, Val(firstPackage.typeid))
    s = handleSubpackages(secondPackage, Val(secondPackage.typeid))
    return Int(f > s)
end

function handleSubpackages(package::Package, ::Val{6})
    firstPackage, secondPackage = package.subpackages
    f = handleSubpackages(firstPackage, Val(firstPackage.typeid))
    s = handleSubpackages(secondPackage, Val(secondPackage.typeid))
    return Int(f < s)
end

function handleSubpackages(package::Package, ::Val{7})
    firstPackage, secondPackage = package.subpackages
    f = handleSubpackages(firstPackage, Val(firstPackage.typeid))
    s = handleSubpackages(secondPackage, Val(secondPackage.typeid))
    return Int(f == s)
end

using BenchmarkTools
@btime begin
    data = readData()
    parsed, _ = parsePackages(data)
    sumVersion(parsed)
    handleSubpackages(parsed, Val(parsed.typeid))
end
