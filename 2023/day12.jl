function readData(path, ::Val{12})
    chars, nums = String[], Vector{Int}[]
    for line in readlines(path)
        c, n = split(line, " ")
        push!(chars, String(c))
        push!(nums, map(x -> parse(Int, x), split(n, ',')))
    end
    return chars, nums
end

function getCheckRegex(nums::Vector{Int})
    rnums = map(n -> join(("[?#]{", n, "}")), nums)
    rstring = join(rnums, "[?.]+")
    return Regex(join(("^[?.]*", rstring, "[?.]*\$")))
end

function getRegex(nums::Vector{Int})
    rnums = map(n -> join(("([#?]{", n, ",})")), nums)
    rstring = join(rnums, "([?.]{1,}?)")
    return Regex(join(("^[?.]*?", rstring, "[?.]*?\$")))
end

function search(chars, index, rstring::Regex, len::Int)
    str = join(chars)
    if index > len
        !isnothing(match(rstring, str)) ? (return 1) : (return 0)
    end
    if chars[index] == '?'
        s = 0
        for c in ('.', '#')
            chars[index] = c
            isnothing(match(rstring, str)) && continue
            s += search(chars, index + 1, rstring, len)
        end
        chars[index] = '?'
        return s
    else
        return search(chars, index + 1, rstring, len)
    end
end

function doSearch(chars::String, nums::Vector{Int}, dic=Dict{String,Int}())
    isempty(nums) && return 1
    k = join((chars, " ", join(nums, ",")))
    haskey(dic, k) && return dic[k]
    chars = collect(chars)
    res = 0
    if all(==('?'), chars)
        ball = length(chars) - sum(nums) - length(nums) + 1
        basket = length(nums) + 1
        res = binomial(basket + ball - 1, ball)
    else
        res = search(chars, 1, getCheckRegex(nums), length(chars))
    end
    dic[k] = res
    return dic[k]
end

function search(::Val{1}, tokens, ns, tindex=1, nindex=1, p=Pair{String,Vector{Int}}[], ps=Vector{Pair{String,Vector{Int}}}[]
)
    if tindex > length(tokens) || nindex > length(ns)
        # toCheck = tokens[tindex+1:length(tokens)]
        # if nindex > length(ns) && (isempty(toCheck) || all(x -> '#' ∉ x, toCheck))
        if nindex > length(ns) && all(x -> !isempty(x[2]) || (isempty(x[2]) && '#' ∉ x[1]), p)
            push!(ps, deepcopy(p))
            return ps
        end
    end
    while tindex <= length(tokens)
        if tindex > 1 && nindex == 1
            toCheck = tokens[1:tindex-1]
            (isempty(toCheck) || all(x -> '#' ∉ x, toCheck)) || break
        end
        all(x -> !isempty(x[2]) || (isempty(x[2]) && '#' ∉ x[1]), p) || break
        search(Val(2), tokens, ns, tindex, nindex, p, ps) || break
        # push!(p, Pair(tokens[tindex], Int[]))
        tindex += 1
    end
    return ps
end

function search(::Val{2}, tokens, ns, tindex=1, nindex=1, p=Pair{String,Vector{Int}}[], ps=Vector{Pair{String,Vector{Int}}}[])
    tLeftLen, toAddn = length(tokens[tindex]), Int[]
    push!(p, Pair(tokens[tindex], toAddn))
    isStartNum = true
    while nindex <= length(ns)
        toCompareLen = isStartNum ? ns[nindex] : ns[nindex] + 1
        if tLeftLen < toCompareLen
            isStartNum ? (return all(x -> '#' ∉ x, tokens[tindex])) : (break) #  to check if all '?' in this string that cannot match any number
        else
            push!(toAddn, ns[nindex])
            tLeftLen -= toCompareLen
            search(Val(1), tokens, ns, tindex + 1, nindex + 1, p, ps)
        end

        isStartNum = false
        nindex += 1
    end
    isempty(p) || pop!(p)
    # f = findfirst(x -> x[1] == (tokens[tindex]), p)
    # isnothing(f) || popat!(p, f)
    return true
end

function getPs(str::String, nums::Vector{Int})
    tokens = map(String, filter(!isempty, split(str, ".")))
    return search(Val(1), tokens, nums)
end

function searchStr(str::String, nums::Vector{Int}, dic::Dict{String,Int}=Dict{String,Int}())
    ps = getPs(str, nums)
    res = sum(ps) do p
        s = 1
        for (k, v) in p
            s *= doSearch(k, v, dic)
        end
        return s
    end
    return res
end

function partOne(data)
    return 0
end

function partTwo(data)
    strs, nums = data
    dic, s = Dict{String,Int}(), 0
    for (str, ns) in zip(strs, nums)
        s1 = searchStr(str, ns, dic)
        s2 = doSearch(str, ns)
        if s1 != s2
            println("str: ", str, " ns: ", ns, " s1: ", s1, " s2: ", s2)
        end
        s += s1
    end
    return s
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
# search(Val(1), ["?", "#", "??##??????#???"], [1, 4, 7])

begin
    time = 5
    # cs = ""
    cs = "??#?.#..????"
    ns = [3, 1, 2]
    # cs = join((cs for _ in 1:time), '?')
    # ns = reduce(vcat, (ns for _ in 1:time))
    getPs(cs, ns) |> display
    doSearch(cs, ns) |> display
    searchStr(cs, ns) |> display
end
