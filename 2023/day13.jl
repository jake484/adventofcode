function readData(path, ::Val{13})
    data = readlines(path)
    maps = Matrix[]
    start = 1
    m = Matrix[]
    l = 0
    for line in data
        if start == 1
            l = length(line)
            m = reshape(collect(line), 1, l)
            start = 0
            continue
        end
        if line == ""
            push!(maps, m)
            start = 1
        else
            m = vcat(m, reshape(collect(line), 1, l))
        end
    end
    push!(maps, m)
    return maps
end

function find(m, old=0)
    row, col = size(m)
    mirror = 1
    while mirror < row
        mindistance = min(mirror, row - mirror)
        view(m, (mirror-mindistance+1):mirror, :) == view(m, (mirror+mindistance):-1:(mirror+1), :) && 100 * mirror != old && return 100 * mirror
        mirror += 1
    end
    mirror = 1
    while mirror < col
        mindistance = min(mirror, col - mirror)
        view(m, :, (mirror-mindistance+1):mirror) == view(m, :, (mirror+mindistance):-1:(mirror+1)) && mirror != old && return mirror
        mirror += 1
    end
    return 0
end

function partOne(data)
    s = Int[]
    for m in data
        push!(s, find(m))
    end
    return s
end

function partTwo(data, olds)
    s = 0
    for index in eachindex(data)
        m = data[index]
        for i in CartesianIndices(m)
            old = m[i]
            if m[i] == '.'
                m[i] = '#'
            else
                m[i] = '.'
            end
            f = find(m, olds[index])
            m[i] = old
            if f > 0
                s += f
                break
            end
        end
    end
    return s
end

function day13_main()
    data = readData("data/2023/day13.txt", Val(13))
    s = partOne(data)
    return sum(s), partTwo(data, s)
end

# test
# data = readData("data/2023/day13.txt", Val(13))
# day13_main()

using BenchmarkTools
@info "day13 性能："
@btime day13_main()

