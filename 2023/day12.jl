function readData(path, ::Val{12})
    chars, nums = String[], Vector{Int}[]
    for line in readlines(path)
        c, n = split(line, " ")
        push!(chars, String(c))
        push!(nums, map(x -> parse(Int, x), split(n, ',')))
    end
    return chars, nums
end

# function search(tokens, ns, tindex=1, nindex=1,
#     toAddt=String[], toAddn=Int[], ps=Tuple{String,Vector{Int}}[]
# )
#     println(ps)
#     oldAddn = copy(toAddn)
#     while tindex <= length(tokens)
#         push!(toAddt, tokens[tindex])
#         tLeftLen = length(tokens[tindex])
#         while nindex <= length(ns)
#             if tLeftLen < ns[nindex]
#                 search(tokens, ns, tindex + 1, nindex, toAddt, toAddn, ps)
#                 break
#             else
#                 push!(toAddn, ns[nindex])
#                 tLeftLen -= ns[nindex]
#                 search(tokens, ns, tindex + 1, nindex + 1, toAddt, toAddn, ps)
#             end
#             nindex += 1
#         end
#         if nindex >= length(ns)
#             toCheck = toAddn[tindex+1:length(tokens)]
#             if isempty(toCheck) || all(x -> '#' ∉ x, toCheck)
#                 push!(ps, (join(toAddt), toAddn))
#             end
#             toAddn, nindex = copy(oldAddn), 1
#         end
#         tindex += 1
#         pop!(toAddt)
#     end
#     return ps
# end

function search(::Val{1}, tokens, ns, tindex=1, nindex=1, p=Dict{String,Vector{Int}}(), ps=Dict{String,Vector{Int}}[]
)
    if tindex > length(tokens) || nindex > length(ns)
        toCheck = tokens[tindex+1:length(tokens)]
        if nindex > length(ns) && (isempty(toCheck) || all(x -> '#' ∉ x, toCheck))
            push!(ps, deepcopy(p))
        end
    end
    while tindex <= length(tokens)
        !search(Val(2), tokens, ns, tindex, nindex, p, ps) && break
        tindex += 1
    end
    return ps
end

function search(::Val{2}, tokens, ns, tindex=1, nindex=1, p=Dict{String,Vector{Int}}(), ps=Dict{String,Vector{Int}}[])
    tLeftLen, toAddn, isStartNum = length(tokens[tindex]), Int[], true
    while nindex <= length(ns)
        toCompareLen = isStartNum ? ns[nindex] : ns[nindex] + 1
        if tLeftLen < toCompareLen
            isStartNum ? (return all(x -> '#' ∉ x, tokens[tindex])) : (break) #  to check if all '?' in this string that cannot match any number
        else
            push!(toAddn, ns[nindex])
            tLeftLen -= toCompareLen
            p[tokens[tindex]] = copy(toAddn)
            search(Val(1), tokens, ns, tindex + 1, nindex + 1, p, ps)
        end
        isStartNum = false
        nindex += 1
    end
    haskey(p, tokens[tindex]) && pop!(p, tokens[tindex])
    return true
end

function partOne(data)
    return 0
end

function partTwo(data)
    strs, nums = data
    for (s, ns) in zip(strs, nums)
        tokens = map(String, filter(!isempty, split(s, ".")))
        length(s) > sum(ns) + length(ns) - 1 && (search(Val(1), tokens, ns) |> println)
    end
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
# search(Val(1), ["?", "#", "??##??????#???"], [1, 4, 7])