function readData(path, ::Val{12})
    chars, nums = Vector{Char}[], Vector{Int}[]
    for line in readlines(path)
        c, n = split(line, " ")
        push!(chars, collect(c))
        push!(nums, map(x -> parse(Int, x), split(n, ',')))
    end
    return chars, nums
end

function getRegex(nums::Vector{Int})
    rnums = map(n -> join(("[?#]{", n, "}")), nums)
    rstring = join(rnums, "[?.]+")
    return Regex(join(("^[?.]*", rstring, "[?.]*\$")))
end

function search(chars, index, rstring, len, fs::Vector{Char}, es::Vector{Char})
    if index == len
        if !isnothing(match(rstring, join(chars)))
            push!(fs, first(chars))
            push!(es, last(chars))
            return 1
        else
            return 0
        end
    end
    if chars[index] == '?'
        s = 0
        for c in ('.', '#')
            chars[index] = c
            isnothing(match(rstring, join(chars))) && continue
            s += search(chars, index + 1, rstring, len, fs, es)
        end
        chars[index] = '?'
        return s
    else
        return search(chars, index + 1, rstring, len, fs, es)
    end
end

function partOne(data)
    chars, nums = data
    fes = Tuple{Vector{Char},Vector{Char}}[]
    s = Int[]
    for (cs, ns) in zip(chars, nums)
        fs, es = Char[], Char[]
        push!(s, search(cs, 1, getRegex(ns), length(cs), fs, es))
        push!(fes, (fs, es))
    end
    return s, fes
end

function partTwo(data, res, fes)
    chars, nums = data
    s = 0
    for i in eachindex(res)
        fs, es = fes[i]
        fschars, eschars, feschars = copy(chars[i]), copy(chars[i]), copy(chars[i])
        pushfirst!(fschars, '?'), push!(eschars, '?'), pushfirst!(feschars, '?'), push!(feschars, '?')
        fsn = search(newchars, 1, getRegex(nums[i]), length(newchars), Char[], Char[])
        esn = search(eschars, 1, getRegex(nums[i]), length(eschars), Char[], Char[])
        fesn = search(feschars, 1, getRegex(nums[i]), length(feschars), Char[], Char[])
        # cntdiff = count(x -> x[1] != x[2], zip(fs, es))
        # cntsame1 = count(x -> x[1] == x[2] == '#', zip(fs, es))
        # cntsame2 = count(x -> x[1] == x[2] == '.', zip(fs, es))
        if all(==('#'), fs) || all(==('#'), es)
            s += res[i]^5
        elseif all(==('.'), fs) || all(==('.'), es)
            s += fsn^4 * res[i] + esn^4 * res[i] - res[i]^5
        else
            s += res[i]^5
        end
        s += fsn^4 * cntdiff + esn^4 * cntdiff - res[i]^4 * cntdiff + cntsame1^5 + cntsame2^5 + fesn^4 * cntdiff
    end
    return s
end

function day12_main()
    data = readData("data/2023/day12.txt", Val(12))
    one, fes = partOne(data)
    return sum(one), partTwo(data, one, fes)
end

# test
data = readData("data/2023/day12.txt", Val(12))
day12_main()

# using BenchmarkTools
# @info "day12 性能："
# @btime day12_main()

# cs = collect("?????.######..#####.")
# ns = [1, 6, 5]
# search(cs, 1, getRegex(ns), length(cs))

# # combination
# sum(x -> binomial(5, x), 0:4) * 4^5

# factorial