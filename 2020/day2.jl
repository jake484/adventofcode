# 读取数据
"""
return

(15, 16, "f", "ffffffffffffffhf")
(6, 8, "b", "bbbnvbbb")
(6, 10, "z", "zhzzzzfzzzzzzzzzpzz")
⋮
(6, 7, "s", "xsvmsds")
(6, 7, "n", "jbncncnn")


"""
#=
function readData(path, ::Val{2})
    return map(readlines(path)) do line
        caps = match(r"(\d+)-(\d+) (\w+): (\w+)", line).captures
        return (parse(Int, caps[1]), parse(Int, caps[2]),
            Char(caps[3][1]), string(caps[4]))
    end
end
=#
function readData(path, ::Val{2})
    return map(readlines(path)) do line
        caps = split(line, c -> c ∈ (' ', '-', ':'))
        return (parse(Int, caps[1]), parse(Int, caps[2]),
            Char(caps[3][1]), string(caps[end]))
    end
end

function countRight(data::Vector, ::Val{1})
    return count(data) do tuple
        lb, hb, chr, str = tuple
        return lb <= count(==(chr), (chr for chr in str)) <= hb
    end
end

function countRight(data::Vector, ::Val{2})
    return count(data) do tuple
        lb, hb, chr, str = tuple
        return length(str) >= hb && count(==(chr), (str[lb], str[hb])) == 1
    end
end

function day2_main()
    data = readData("data/2020/day2.txt", Val(2))
    countRight(data, Val(1))
    countRight(data, Val(2))
    return nothing
end

# using BenchmarkTools
# @info "day2 性能："
# @btime day2_main()