function readData(path, ::Val{4})
    strs = String[]
    str = ""
    for line in readlines(path)
        if isempty(line)
            push!(strs, str)
            str = ""
        else
            str *= line * " "
        end
    end
    push!(strs, str)
    return strs
end

function countValid(data::Vector)
    items = ("byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid")
    return count(data) do passport
        return all(x -> occursin(x, passport), items)
    end
end

isValid(::Val{:byr}, v) = length(v) == 4 && "1920" <= v <= "2002"
isValid(::Val{:iyr}, v) = length(v) == 4 && "2010" <= v <= "2020"
isValid(::Val{:eyr}, v) = length(v) == 4 && "2020" <= v <= "2030"
isValid(::Val{:hgt}, v) = (length(v) == 5 && "cm" == v[4:5] && "150cm" <= v <= "193cm") || (length(v) == 4 && "in" == v[3:4] && "59in" <= v <= "76in")
isValid(::Val{:hcl}, v) = length(v) == 7 && !isnothing(match(r"#([\da-f]{6})", v))
isValid(::Val{:ecl}, v) = v ∈ ("amb", "blu", "brn", "gry", "grn", "hzl", "oth")
isValid(::Val{:pid}, v) = length(v) == 9 && "000000000" <= v <= "999999999"
isValid(::Val{:cid}, v) = true

function countStrictValid(data::Vector)
    items = ("byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid")
    return count(data) do passport
        return all(x -> occursin(x, passport), items) && all(passport |> strip |> split) do item
            k, v = split(item, ":")
            return isValid(k |> Symbol |> Val, v)
        end
    end
end


function day4_main()
    data = readData("data/2020/day4.txt", Val(4))
    data |> countValid
    data |> countStrictValid
    return nothing
end

# test
# data = readData("data/2020/day4.txt", Val(4))


# using BenchmarkTools
# @info "day4 性能："
# @btime day4_main()

