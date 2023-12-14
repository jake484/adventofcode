function readData(path, ::Val{12})
    chars, nums = Vector{Char}[], Vector{Int}[]
    for line in readlines(path)
        c, n = split(line, " ")
        push!(chars, collect(c))
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

function search(chars, index, rstring, len)
    str = join(chars)
    if index > len
        if !isnothing(match(rstring, str))
            return 1
        else
            return 0
        end
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

function doSearch(chars, nums, dic=Dict{String,Int}())
    isempty(nums) && return 1
    k = join(join(chars), " ", join(nums, ","))
    if haskey(dic, k)
        return dic[k]
    else
        if all(==('?'), chars)
            ball = length(chars) - sum(nums) - length(nums) + 1
            basket = length(nums) + 1
            res = binomial(basket + ball - 1, ball)
        else
            res = search(chars, 1, getCheckRegex(nums), length(chars))
        end
        dic[k] = res == 0 ? 1 : res
        return dic[k]
    end
end

function search(chars, nums, dic=Dict{String,Int}())
    caps = match(getRegex(nums), join(chars))
    tokens = isnothing(caps) ? String[] : map(String, caps.captures)
    s, index, len, needStopHead = 1, 1, length(tokens), false
    toSearchChars, toSearchNums = Char[], Int[]
    while index <= len
        if mod1(index, 2) == 1
            if length(tokens[index]) == nums[1] && (index > 1 && '.' ∈ tokens[index-1]) && (index + 1 <= len && '.' ∈ tokens[index+1])
                # index > 1 && tokens[index-1] == "?" && !isempty(toSearchChars) && pop!(toSearchChars)
                s *= doSearch(toSearchChars, toSearchNums, dic)
                toSearchChars, toSearchNums = Char[], Int[]
                popfirst!(nums)
                # (index + 1 <= len) && tokens[index+1] == "?" && (needStopHead = true)
            else
                append!(toSearchChars, collect(tokens[index]))
                push!(toSearchNums, popfirst!(nums))
            end
        else
            if tokens[index] == "?"
                append!(toSearchChars, collect(tokens[index]))
            else
                s *= doSearch(toSearchChars, toSearchNums, dic)
                toSearchChars, toSearchNums = Char[], Int[]
            end
        end
        # if needStopHead && !isempty(toSearchChars)
        #     popfirst!(toSearchChars)
        #     needStopHead = false
        # end
        index += 1
        # println("toSearchChars: ", toSearchChars, " toSearchNums: ", toSearchNums)
    end
    s *= doSearch(toSearchChars, toSearchNums, dic)
    return s
end
# function search(chars, nums, dic=Dict{String,Int}())
#     caps = match(getRegex(nums), join(chars))
#     tokens = isnothing(caps) ? String[] : map(String, caps.captures)
#     s, index, len, needStopHead = 1, 1, length(tokens), false
#     toSearchChars, toSearchNums = Char[], Int[]
#     while index <= len
#         if mod1(index, 4) ∈ (1, 3)
#             append!(toSearchChars, collect(tokens[index]))
#         elseif mod1(index, 4) == 2
#             if length(tokens[index]) == nums[1]
#                 index > 4 && '.' ∉ tokens[index-2] && (!isempty(toSearchChars)) && pop!(toSearchChars)
#                 s *= doSearch(toSearchChars, toSearchNums, dic)
#                 toSearchChars, toSearchNums = Char[], Int[]
#                 popfirst!(nums)
#                 (index + 2 <= len) && '.' ∉ tokens[index+2] && (needStopHead = true)
#             else
#                 append!(toSearchChars, collect(tokens[index]))
#                 push!(toSearchNums, popfirst!(nums))
#             end
#         else
#             if tokens[index] == "?"
#                 append!(toSearchChars, collect(tokens[index]))
#             else
#                 s *= doSearch(toSearchChars, toSearchNums, dic)
#                 toSearchChars, toSearchNums = Char[], Int[]
#             end
#         end
#         if needStopHead && !isempty(toSearchChars)
#             popfirst!(toSearchChars)
#             needStopHead = false
#         end
#         index += 1
#         # println("toSearchChars: ", toSearchChars, " toSearchNums: ", toSearchNums)
#     end
#     s *= doSearch(toSearchChars, toSearchNums, dic)
#     return s
# end

function partOne(data, dic=Dict{String,Int}())
    chars, nums = data
    s = 0
    for (cs, ns) in zip(chars, nums)
        # s += search(cs, 1, getCheckRegex(ns), length(cs))
        a = search(copy(cs), copy(ns), dic)
        b = doSearch(copy(cs), copy(ns), dic)
        if a != b
            println("cs: ", join(cs), " ns: ", ns, " a: ", a, " b: ", b)
        end
    end
    return s
end

function partTwo(data, dic=Dict{String,Int}())
    chars, nums = data
    s = 0
    for (cs, ns) in zip(chars, nums)
        # s += search(cs, 1, getCheckRegex(ns), length(cs))
        s += search(collect(join((cs for _ in 1:5), '?')), reduce(vcat, (ns for _ in 1:5)), dic)
    end
    return s
end

function day12_main()
    data = readData("data/2023/day12.txt", Val(12))
    dic = Dict{String,Int}()
    one = partOne(data, dic)
    return one, 0# partTwo(data, dic)
end

# test
# data = readData("data/2023/day12.txt", Val(12))
# day12_main()

# using BenchmarkTools
# @info "day12 性能："
# @btime day12_main()
begin
    time = 5
    # cs = ""
    cs = "????#?##???.??"
    ns = [2, 5, 1]
    # cs = collect(join((cs for _ in 1:time), '?'))
    # ns = reduce(vcat, (ns for _ in 1:time))
    match(getRegex(ns), join(cs)).captures |> display
    search(collect(cs), copy(ns)) |> println
    search(collect(cs), 1, getCheckRegex(ns), length(cs)) |> println
    doSearch(collect(cs), ns) |> println
end
