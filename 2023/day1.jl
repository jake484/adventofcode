function readData(path, ::Val{1})
    return readlines(path)
end

function partOne(data::Vector{String})
    s = 0
    for str in data
        fs, es = 0, 0
        l = length(str)
        for ind in 1:l
            if isdigit(str[ind])
                fs = parse(Int, str[ind])
                break
            end
        end
        for ind in l:-1:1
            if isdigit(str[ind])
                es = parse(Int, str[ind])
                break
            end
        end
        s += fs * 10 + es
    end
    return s
end

function toInt(str::AbstractString)
    maps = Dict("one" => 1, "two" => 2, "three" => 3, "four" => 4, "five" => 5, "six" => 6, "seven" => 7, "eight" => 8, "nine" => 9, "eno" => 1, "owt" => 2, "eerht" => 3, "ruof" => 4, "evif" => 5, "xis" => 6, "neves" => 7, "thgie" => 8, "enin" => 9)
    if length(str) == 1
        return parse(Int, str)
    else
        return maps[str]
    end
end

function partTwo(data::Vector{String})
    s = 0
    regex = r"(\d|one|two|three|four|five|six|seven|eight|nine)"
    reverseregex = r"(\d|eno|owt|eerht|ruof|evif|xis|neves|thgie|enin)"
    for str in data
        fs, es = 0, 0
        fs = match(regex, str).match |> string |> toInt
        es = match(reverseregex, reverse(str)).match |> string |> toInt
        s += fs * 10 + es
    end
    return s
end

function day1_main()
    data = readData("data/2023/day1.txt", Val(1))
    partOne(data), partTwo(data)
end


using BenchmarkTools
@info "day1 性能："
@btime day1_main()

