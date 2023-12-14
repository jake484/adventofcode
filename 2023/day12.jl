function readData(path, ::Val{12})
    chars, nums = String[], Vector{Int}[]
    for line in readlines(path)
        c, n = split(line, " ")
        push!(chars, String(c))
        push!(nums, map(x -> parse(Int, x), split(n, ',')))
    end
    return chars, nums
end

canMatch(data, tocheck) = all(x -> x == '?' || x == tocheck[1], data)

canLeft(data) = all(x -> x == '?' || x == '.', data)


function search(str, strIndex, toMarthes, matchIndex, endLen)
    if matchIndex > length(toMarthes)
        if (strIndex > length(str) || canLeft(str[strIndex:end]))
            return 1
        else
            return 0
        end
    end
    s = 0
    while strIndex <= endLen
        l = length(toMarthes[matchIndex])
        matchRange = strIndex:(l-1)
        if canMatch(str[matchRange], toMarthes[matchIndex])
            s += search(str, strIndex + l, toMarthes, matchIndex + 1, endLen + l - 1)
        else
            return 0
        end
        strIndex += 1
    end
    return s
end


function partOne(data)
    chars, nums = data
    s = 0
    for (cs, ns) in zip(chars, nums)
        toMatches = String[]
        for n in ns
            push!(toMatches, repeat('#', n))
            push!(toMatches, ".")
        end
        pop!(toMatches)
        matchLen = sum(ns) + length(ns) - 1
        s += search(cs, 1, toMatches, 1, length(cs) - matchLen + 1)
    end
    return s
end

function partTwo(data)
    return 0
end

function day12_main()
    data = readData("data/2023/day12.txt", Val(12))
    return partOne(data), partTwo(data)
end

# test
# data = readData("data/2023/day12.txt", Val(12))
day12_main()

# using BenchmarkTools
# @info "day12 性能："
# @btime day12_main()
# begin
#     time = 5
#     # cs = ""
#     chars = "????#?##???.??"
#     nums = [2, 5, 1]
#     toMatches = map(x -> repeat('#', x), nums)
#     matchLen = sum(nums) + length(nums) - 1
# end
