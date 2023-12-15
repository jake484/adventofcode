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
    println(p)
    if tindex > length(tokens) || nindex > length(ns)
        toCheck = tokens[tindex+1:length(tokens)]
        if nindex >= length(ns) && (isempty(toCheck) || all(x -> '#' ∉ x, toCheck))
            push!(ps, p)
        end
    end
    while tindex <= length(tokens)
        toCheck = tokens[1:tindex-1]
        !(isempty(p) && (isempty(toCheck) || all(x -> '#' ∉ x, toCheck))) && break
        search(Val(2), tokens, ns, tindex, nindex, p, ps)
        tindex += 1
    end
    return ps
end

function search(::Val{2}, tokens, ns, tindex=1, nindex=1, p=Dict{String,Vector{Int}}(), ps=Dict{String,Vector{Int}}[])
    tLeftLen, toAddn = length(tokens[tindex]), Int[]
    while nindex <= length(ns)
        if tLeftLen < ns[nindex]
            search(Val(1), tokens, ns, tindex + 1, nindex, p, ps)
            break
        else
            push!(toAddn, ns[nindex])
            tLeftLen -= nindex == length(ns) ? ns[nindex] + 1 : ns[nindex]
            p[tokens[tindex]] = toAddn
            search(Val(1), tokens, ns, tindex + 1, nindex + 1, p, ps)
            pop!(p, tokens[tindex])
        end
        nindex += 1
    end
    return ps
end

function partOne(data)
    return 0
end

function partTwo(data)
    strs, nums = data
    for (s, ns) in zip(strs, nums)
        tokens = filter(!isempty, split(s, "."))
        println(tokens)
    end
    return 0
end

function day12_main()
    data = readData("data/2023/day12.txt", Val(12))
    return partOne(data), partTwo(data)
end

# test
# data = readData("data/2023/day12.txt", Val(12))
# day12_main()

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
search(Val(1), ["????#?##???", "??"], [2, 5, 1])