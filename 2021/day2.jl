# 读取数据
function readData(path="data/2021/day2.txt")
    data = Vector{String}[]
    for line in eachline(path)
        push!(data, split(line, " ") .|> string)
    end
    return data
end


# move
function move!(pos::Vector{Int64}, data)
    for command in data
        step = parse(Int64, command[2])
        if command[1] == "forward"
            pos[1] += step
        elseif command[1] == "down"
            pos[2] += step
        elseif command[1] == "up"
            pos[2] -= step
        end
    end
end

function move2!(pos::Vector{Int64}, data)
    for command in data
        step = parse(Int64, command[2])
        if command[1] == "forward"
            pos[1] += step
            pos[2] += step * pos[3]
        elseif command[1] == "down"
            pos[3] += step
        elseif command[1] == "up"
            pos[3] -= step
        end
    end
end
data = readData()
pos = [0, 0]
move!(pos, data)
println("Part 1: ", pos |> prod)
pos = [0, 0, 0]
move2!(pos, data)
println("Part 2: ", pos[1:2] |> prod)

