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

function search(chars, index, rstring, len, fs::Vector{String})
    str = join(chars)
    if index > len
        if !isnothing(match(rstring, str))
            push!(fs, str)
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
            s += search(chars, index + 1, rstring, len, fs)
        end
        chars[index] = '?'
        return s
    else
        return search(chars, index + 1, rstring, len, fs)
    end
end

function partOne(data)
    chars, nums = data
    strs = Vector{String}[]
    s = Int[]
    for (cs, ns) in zip(chars, nums)
        fs = String[]
        push!(s, search(cs, 1, getRegex(ns), length(cs), fs))
        push!(strs, fs)
    end
    return s, strs
end

function searchf(v::Vector{String}, vlen, oldv, newv)
    vlen > 5 && return 1
    s = 0
    if vlen == 1
        for i in eachindex(oldv)
            oldv[i][2] == 0 && continue
            push!(v, oldv[i][1])
            s += oldv[i][2] * searchf(v, vlen + 1, oldv, newv)
            pop!(v)
        end
    else
        for i in eachindex(newv)
            (newv[i][2] == 0 || (v[end][end] == newv[i][1][1] == '#')) && continue
            push!(v, newv[i][1])
            s += newv[i][2] * searchf(v, vlen + 1, oldv, newv)
            pop!(v)
        end
    end
    return s
end

function searche(v::Vector{String}, vlen, oldv, newv)
    s = 0
    if vlen < 5
        for i in eachindex(newv)
            (newv[i][2] == 0 || (length(v) > 0 && v[end][end] == newv[i][1][1] == '#')) && continue
            push!(v, newv[i][1])
            s += newv[i][2] * searche(v, vlen + 1, oldv, newv)
            pop!(v)
        end
    else
        for i in eachindex(oldv)
            (oldv[i][2] == 0 || (v[end][end] == oldv[i][1][1] == '#')) && continue
            push!(v, oldv[i][1])
            s += oldv[i][2]
            pop!(v)
        end
    end
    return s
end

function searchfe(v::Vector{String}, vlen, oldv, newv)
    vlen > 5 && return 1
    s = 0
    if vlen in (1, 3, 5)
        for i in eachindex(oldv)
            (oldv[i][2] == 0 || (length(v) > 0 && v[end][end] == oldv[i][1][1] == '#')) && continue
            push!(v, oldv[i][1])
            s += oldv[i][2] * searchfe(v, vlen + 1, oldv, newv)
            pop!(v)
        end
    else
        for i in eachindex(newv)
            (newv[i][2] == 0 || (v[end][end] == newv[i][1][1] == '#')) && continue
            push!(v, newv[i][1])
            s += newv[i][2] * searchfe(v, vlen + 1, oldv, newv)
            pop!(v)
        end
    end
    return s
end

function searchfef(v::Vector{String}, vlen, oldv, fv, fev)
    vlen > 5 && return 1
    s = 0
    if vlen in (1, 4)
        for i in eachindex(oldv)
            (oldv[i][2] == 0 || (length(v) > 0 && v[end][end] == oldv[i][1][1] == '#')) && continue
            push!(v, oldv[i][1])
            s += oldv[i][2] * searchfef(v, vlen + 1, oldv, fv, fev)
            pop!(v)
        end
    elseif vlen in (2, 5)
        for i in eachindex(fv)
            (fv[i][2] == 0 || (length(v) > 0 && v[end][end] == fv[i][1][1] == '#')) && continue
            push!(v, fv[i][1])
            s += fv[i][2] * searchfef(v, vlen + 1, oldv, fv, fev)
            pop!(v)
        end
    else
        for i in eachindex(fev)
            (fev[i][2] == 0 || (length(v) > 0 && v[end][end] == fev[i][1][1] == '#')) && continue
            push!(v, fev[i][1])
            s += fev[i][2] * searchfef(v, vlen + 1, oldv, fv, fev)
            pop!(v)
        end
    end
    return s
end

function searchfee(v::Vector{String}, vlen, oldv, fv, fev)
    vlen > 5 && return 1
    s = 0
    if vlen in (1, 4)
        for i in eachindex(fv)
            (fv[i][2] == 0 || (length(v) > 0 && v[end][end] == fv[i][1][1] == '#')) && continue
            push!(v, fv[i][1])
            s += fv[i][2] * searchfee(v, vlen + 1, oldv, fv, fev)
            pop!(v)
        end
    elseif vlen in (2, 5)
        for i in eachindex(oldv)
            (oldv[i][2] == 0 || (length(v) > 0 && v[end][end] == oldv[i][1][1] == '#')) && continue
            push!(v, oldv[i][1])
            s += oldv[i][2] * searchfee(v, vlen + 1, oldv, fv, fev)
            pop!(v)
        end
    else
        for i in eachindex(fev)
            (fev[i][2] == 0 || (length(v) > 0 && v[end][end] == fev[i][1][1] == '#')) && continue
            push!(v, fev[i][1])
            s += fev[i][2] * searchfee(v, vlen + 1, oldv, fv, fev)
            pop!(v)
        end
    end
    return s
end
# T->1,f; T->2,e
function search(str, fstr, estr, festr, n, fn, en, fen, ::Val{T}) where {T}
    oldv, fv, ev, fev = map(str -> [
            (".#", count(x -> x[1] == '.' && x[end] == '#', str)),
            ("#.", count(x -> x[1] == '#' && x[end] == '.', str)),
            ("##", count(x -> x[1] == '#' && x[end] == '#', str)),
            ("..", count(x -> x[1] == '.' && x[end] == '.', str))
        ], (str, fstr, estr, festr))
    if T == 1
        n == fn && return 0
        return searchf(String[], 1, oldv, fv) - n^5
    elseif T == 2
        n == en && return 0
        return searche(String[], 1, oldv, ev) - n^5
    else
        s1 = n == fen ? 0 : searchfe(String[], 1, oldv, fev) - fn^2 * n^3 - en^2 * n^3 + n^5
        println(s1)
        s2 = n == fn ? 0 : searchfef(String[], 1, oldv, fv, fev) - fn^3 * n^2
        println(s2)
        s3 = n == en ? 0 : searchfee(String[], 1, oldv, ev, fev) - en^3 * n^2
        println(s3)
        println("===")
        return s1 + s2 + s3
    end
    # if length(str) == length(fstr)
    #     return 0
    # else

    #     # if all(==('.'), fsfs) || all(==('.'), fses)
    #     #     return n * (fn^4 - n^4)
    #     # else

    #     # end
    # end
end

function partTwo(data, res, strs)
    chars, nums = data
    s = 0
    for i in eachindex(res)
        str = strs[i]
        fschars, eschars, fseschars = copy(chars[i]), copy(chars[i]), copy(chars[i])
        pushfirst!(fschars, '?'), push!(eschars, '?'), pushfirst!(fseschars, '?'), push!(fseschars, '?')
        fstr, estr, festr = String[], String[], String[]
        fn = search(fschars, 1, getRegex(nums[i]), length(fschars), fstr)
        en = search(eschars, 1, getRegex(nums[i]), length(eschars), estr)
        fen = search(fseschars, 1, getRegex(nums[i]), length(fseschars), festr)
        s += sum(x -> search(str, fstr, estr, festr, res[i], fn, en, fen, Val(x)), 1:3) + res[i]^5
    end
    return s
end

function day12_main()
    data = readData("data/2023/day12.txt", Val(12))
    one, fes = partOne(data)
    return sum(one), partTwo(data, one, fes)
end

# test
# data = readData("data/2023/day12.txt", Val(12))
# day12_main()

# using BenchmarkTools
# @info "day12 性能："
# @btime day12_main()

# cs = collect("?????.######..#####.")
# ns = [1, 6, 5]
# search(cs, 1, getRegex(ns), length(cs))

cs = collect("??#?#?#????.????#?")
nums = [6, 2, 1, 1]
fschars, eschars, feschars = copy(cs), copy(cs), copy(cs)
pushfirst!(fschars, '?'), push!(eschars, '?'), pushfirst!(feschars, '?'), push!(feschars, '?')
str, fstr, estr, festr = String[], String[], String[], String[]
n = search(cs, 1, getRegex(nums), length(cs), str)
fn = search(fschars, 1, getRegex(nums), length(fschars), fstr)
en = search(eschars, 1, getRegex(nums), length(eschars), estr)
fen = search(feschars, 1, getRegex(nums), length(feschars), festr)
s1 = search(str, fstr, estr, festr, n, fn, en, fen, Val(1))
s2 = search(str, fstr, estr, festr, n, fn, en, fen, Val(2))
s3 = search(str, fstr, estr, festr, n, fn, en, fen, Val(3))
s1 + s2 + s3 + n^5

