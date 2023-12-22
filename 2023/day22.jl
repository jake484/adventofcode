using Meshes, DataStructures

struct Brick
    segment::Segment
    levels::Vector{Int}
    inters::Vector{Segment}
    function Brick(seg, levels)
        new(seg, levels, Segment[])
    end
end

Base.intersect(a::Brick, b::Brick) = intersect(a.segment, b.segment)

function readData(path, ::Val{22})
    data = Brick[]
    for line in eachline(path)
        a, b = split(line, '~')
        x1, y1, z1 = map(x -> parse(Int, x), split(a, ','))
        x2, y2, z2 = map(x -> parse(Int, x), split(b, ','))
        z1, z2 = minmax(z1, z2)
        push!(data, Brick(Segment((x1, y1), (x2, y2)), [z1, z2]))
    end
    return sort(data, by=x -> x.levels[1], rev=true)
end

function fall!(data)
    Setted = Brick[]
    while !isempty(data)
        toSetLevel = 1
        brick = pop!(data)
        for b in Setted
            if !isnothing(intersect(brick, b))
                toSetLevel = max(toSetLevel, b.levels[2] + 1)
            end
        end
        len = brick.levels[2] - brick.levels[1]
        brick.levels[1] = toSetLevel
        brick.levels[2] = toSetLevel + len
        pushfirst!(Setted, brick)
    end
    return Setted
end

function getLevelBrick(setted)
    levelBricks = OrderedDict{Int,Vector{Brick}}()
    for b in setted
        haskey(levelBricks, b.levels[1]) || (levelBricks[b.levels[1]] = Brick[])
        push!(levelBricks[b.levels[1]], b)
    end
    return levelBricks
end


function partOne(data)
    setted = fall!(data)
    levelBricks = getLevelBrick(setted)
    _, highLevelBricks = popfirst!(levelBricks)
    num = length(highLevelBricks)
    while !isempty(levelBricks)
        _, lowerLevelBricks = popfirst!(levelBricks)
        canNotTakeBricks = Brick[]
        for highBrick in highLevelBricks
            inters = Brick[]
            for lowBrick in lowerLevelBricks
                if !isnothing(intersect(highBrick, lowBrick)) && highBrick.levels[1] - lowBrick.levels[2] == 1
                    push!(inters, lowBrick)
                    length(inters) > 1 && break
                end
            end
            if length(inters) == 1
                append!(canNotTakeBricks, inters)
            end
        end
        num += length(highLevelBricks) - length(canNotTakeBricks)
        highLevelBricks = lowerLevelBricks
    end
    return num
end

function partTwo(data)
    return 0
end

function day22_main()
    data = readData("data/2023/day22.txt", Val(22))
    return partOne(deepcopy(data)), partTwo(data)
end


# test
data = readData("data/2023/day22.txt", Val(22))
day22_main()

# using BenchmarkTools
# @info "day22 性能："
# @btime day22_main()