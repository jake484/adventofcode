function readData(path="data/2021/day17.txt")
    reg = r"target area: x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)"
    caps = match(reg, readline(path)).captures
    return parse.(Int, caps)
end

y_t(y0::Int, t::Int) = (2y0 + 1 - t) * t ÷ 2

function x_t(x0::Int, t::Int)
    if t < x0 + 1
        return (2x0 + 1 - t) * t ÷ 2
    else
        return (abs2(x0) + x0) ÷ 2
    end
end

tGenerator(r::UnitRange{Int}, v0::Int; start::Int=2v0 + 2, stop::Int=2v0 + 1 + abs(r.start), f::Function=y_t) = (t for t in start:stop if f(v0, t) ∈ r)


function findY(ymin::Int, ymax::Int)
    yrange = ymin:ymax
    yMax = abs(ymin) - 1
    while !any(x -> !isnothing(x), tGenerator(yrange, yMax))
        yMax -= 1
    end
    return (abs2(yMax) + yMax) ÷ 2
end

function findAll(xmin, xmax, ymin, ymax)
    yrange = ymin:ymax
    xrange = xmin:xmax
    s = 0
    for yv0 in ymin:abs(ymin)
        tGen = tGenerator(yrange, yv0; start=1, stop=Int(fld1(2yv0 + 1 + sqrt(abs2(2yv0 + 1) - 8ymin), 2)))
        xyadded = Tuple{Int,Int}[]
        for t in tGen
            xGen = (xs for xs in 1:xmax if x_t(xs, t) ∈ xrange)
            for x in xGen
                xy = (x, yv0)
                xy ∉ xyadded && push!(xyadded, xy)
            end
        end
        s += length(xyadded)
    end
    return s
end


using BenchmarkTools
@btime begin
    xmin, xmax, ymin, ymax = readData()
    findY(ymin, ymax)
    findAll(xmin, xmax, ymin, ymax)
end