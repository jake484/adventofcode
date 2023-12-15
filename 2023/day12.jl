function readData(path, ::Val{12})
    chars, nums = String[], Vector{Int}[]
    for line in readlines(path)
        c, n = split(line, " ")
        push!(chars, String(c))
        push!(nums, map(x -> parse(Int, x), split(n, ',')))
    end
    return chars, nums
end

function search(tokens, ns, tindex=1, nindex=1,
    toAddt=String[], toAddn=Int[], ps=Tuple{String,Vector{Int}}[]
)
    println(ps)
    oldAddn = copy(toAddn)
    while tindex <= length(tokens)
        push!(toAddt, tokens[tindex])
        tLeftLen = length(tokens[tindex])
        while nindex <= length(ns)
            if tLeftLen < ns[nindex]
                search(tokens, ns, tindex + 1, nindex, toAddt, toAddn, ps)
                break
            else
                push!(toAddn, ns[nindex])
                tLeftLen -= ns[nindex]
                search(tokens, ns, tindex + 1, nindex + 1, toAddt, toAddn, ps)
            end
            nindex += 1
        end
        if nindex >= length(ns)
            toCheck = toAddn[tindex+1:length(tokens)]
            if isempty(toCheck) || all(x -> '#' ∉ x, toCheck)
                push!(ps, (join(toAddt), toAddn))
            end
            toAddn, nindex = copy(oldAddn), 1
        end
        tindex += 1
        pop!(toAddt)
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
search(["????#?##???", "??"], [2, 5, 1])