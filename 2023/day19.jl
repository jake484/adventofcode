using Intervals

function evalFun(name, rules)
    rule = replace(rules, ":" => " ", ">" => "[1]>", "<" => "[1]<")
    rule = split(rule, c -> c == ',')
    rule = join(rule, "() elseif ", "() else ")
    str = name == "in" ? join(("Base.", name, "()=if ", rule, "() end")) :
          join((name, "()=if ", rule, "() end"))
    eval(Meta.parse(str))
    return str
end

function readData(path, ::Val{19})
    data = readlines(path)
    rules, nums = Dict{String,String}(), String[]
    while !isempty(data)
        line = popfirst!(data)
        line == "" && break
        name, rule = split(line, c -> c ∈ ('{'))
        rule = rule[1:end-1]
        rules[name] = rule
        evalFun(name, rule)
    end
    while !isempty(data)
        line = pop!(data)
        push!(nums, line[2:end-1])
    end
    return rules, nums
end

A() = true
R() = false
const x = [0]
const m = [0]
const a = [0]
const s = [0]

function partOne(data)
    lmt = 1:2
    res = 0
    for str in data
        str = replace(str, "=" => "[1]=", "," => ";")
        eval(Meta.parse(str))
        (in()) && (res += x[1] + m[1] + a[1] + s[1])
    end
    return res
end

const RSTR = r"([xmas]+)([<>])(\d+):([a-zAR]+)"
const INTERVAL = 1 .. 4000
getInterval(num::String, ::Val{:<}) = Interval(1, parse(Int, num) - 1)
getInterval(num::String, ::Val{:>}) = Interval(parse(Int, num) + 1, 4000)
getReverseInterval(num::String, ::Val{:<}) = Interval(parse(Int, num), 4000)
getReverseInterval(num::String, ::Val{:>}) = Interval(1, parse(Int, num))
function search(rules, name, ranges=Pair{String,Dict{String,AbstractInterval}}[], range=Dict{String,AbstractInterval}(i => INTERVAL for i in ("x", "m", "a", "s")))
    if name == "A" || name == "R"
        push!(ranges, (name => deepcopy(range)))
        return ranges
    end
    rule = rules[name]
    for part in split(rule, ',')
        if ':' in part
            var, sym, num, nextName = map(String, match(RSTR, part).captures)
            reverseInterval = range[var] ∩ getReverseInterval(num, Val(Symbol(sym)))
            range[var] = range[var] ∩ getInterval(num, Val(Symbol(sym)))
            old = deepcopy(range)
            search(rules, nextName, ranges, range)
            range = old
            range[var] = reverseInterval
        else
            search(rules, String(part), ranges, range)
        end
    end
    return ranges
end

function len(x::AbstractInterval)
    isempty(x) && return 0
    return last(x) - first(x) + 1
end

function partTwo(data)
    rules, _ = data
    ranges = search(rules, "in")
    res = 0
    for (sym, range) in ranges
        sym == "R" && continue
        res += prod(len, values(range) |> collect) |> Int
    end
    return res
end

function day19_main(data)
    return partOne(data[2]), partTwo(data)
end

# test
data = readData("data/2023/day19.txt", Val(19))
day19_main(data)

using BenchmarkTools
@info "day19 性能："
@btime day19_main(data)