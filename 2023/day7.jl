using DataStructures

const ENCODER = Dict(
    '2' => 0,
    '3' => 1,
    '4' => 2,
    '5' => 3,
    '6' => 4,
    '7' => 5,
    '8' => 6,
    '9' => 7,
    'T' => 8,
    'J' => 9,
    'Q' => 10,
    'K' => 11,
    'A' => 12,
)

const ENCODER_J = Dict(
    'J' => 0,
    '2' => 1,
    '3' => 2,
    '4' => 3,
    '5' => 4,
    '6' => 5,
    '7' => 6,
    '8' => 7,
    '9' => 8,
    'T' => 9,
    'Q' => 10,
    'K' => 11,
    'A' => 12,
)

function getType(hand::AbstractString)
    cnter = counter(hand)
    encoder = sum(ENCODER[c] * 13^(5 - i) for (i, c) in enumerate(hand))
    vs, l = values(cnter), length(cnter)
    base13 = 13^6
    l == 1 && (return 7 * base13 + encoder)
    l == 2 && 4 in vs && (return 6 * base13 + encoder)
    l == 2 && (return 5 * base13 + encoder)
    l == 3 && 3 in vs && (return 4 * base13 + encoder)
    l == 3 && (return 3 * base13 + encoder)
    l == 4 && (return 2 * base13 + encoder)
    return base13 + encoder
end

function readData(path, ::Val{7})
    data = readlines(path)
    return map(data) do line
        hand, bid = split(line, ' ')
        return (String(hand), parse(Int, bid), [getType(hand)])
    end
end

function getType(hand::AbstractString, ::Val{:J})
    encoder = sum(ENCODER_J[c] * 13^(5 - i) for (i, c) in enumerate(hand))
    base13 = 13^6
    if 'J' in hand
        hand = replace(hand, 'J' => "")
        cnter = counter(hand)
        vs, handl, l = values(cnter), length(hand), length(cnter)
        if handl == 0
            return 7 * base13 + encoder
        elseif handl == 1
            return 7 * base13 + encoder
        elseif handl == 2
            2 in vs && (return 7 * base13 + encoder)
            return 6 * base13 + encoder
        elseif handl == 3
            3 in vs && (return 7 * base13 + encoder)
            2 in vs && (return 6 * base13 + encoder)
            return 4 * base13 + encoder
        else
            4 in vs && (return 7 * base13 + encoder)
            3 in vs && (return 6 * base13 + encoder)
            2 in vs && l == 2 && (return 5 * base13 + encoder)
            2 in vs && (return 4 * base13 + encoder)
            return 2 * base13 + encoder
        end
    else
        cnter = counter(hand)
        vs, l = values(cnter), length(cnter)
        l == 1 && (return 7 * base13 + encoder)
        l == 2 && 4 in vs && (return 6 * base13 + encoder)
        l == 2 && (return 5 * base13 + encoder)
        l == 3 && 3 in vs && (return 4 * base13 + encoder)
        l == 3 && (return 3 * base13 + encoder)
        l == 4 && (return 2 * base13 + encoder)
        return base13 + encoder
    end
end

function partOne(data)
    data = sort(data, by=x -> x[3][1])
    return sum(x -> x[1] * x[2][2], enumerate(data))
end

function partTwo(data)
    for i in eachindex(data)
        data[i][3][1] = getType(data[i][1], Val(:J))
    end
    data = sort(data, by=x -> x[3][1])
    return sum(x -> x[1] * x[2][2], enumerate(data))
end

function day7_main()
    data = readData("data/2023/day7.txt", Val(7))
    return partOne(data), partTwo(data)
end

# test
# data = readData("data/2023/day7.txt", Val(7))
# day7_main()

using BenchmarkTools
@info "day7 性能："
@btime day7_main()

