abstract type Modules end

using DataStructures

mutable struct FlipFlop <: Modules
    state::Bool
    sendTo::Vector{String}
    receiveFrom::Dict{String,Bool}
    recentPulse::Bool
    sendPulse::Union{Bool,Nothing}
    function FlipFlop()
        new(false, String[], Dict{String,Bool}(), false, false)
    end
end

mutable struct Broadcaster <: Modules
    state::Bool
    sendTo::Vector{String}
    receiveFrom::Dict{String,Bool}
    recentPulse::Bool
    sendPulse::Union{Bool,Nothing}
    function Broadcaster()
        new(false, String[], Dict{String,Bool}(), false, false)
    end
end

mutable struct Conjunction <: Modules
    state::Bool
    sendTo::Vector{String}
    receiveFrom::Dict{String,Bool}
    recentPulse::Bool
    sendPulse::Union{Bool,Nothing}
    function Conjunction()
        new(false, String[], Dict{String,Bool}(), false, false)
    end
end

mutable struct Output <: Modules
    state::Bool
    sendTo::Vector{String}
    receiveFrom::Dict{String,Bool}
    recentPulse::Bool
    sendPulse::Union{Bool,Nothing}
    function Output()
        new(false, String[], Dict{String,Bool}(), false, nothing)
    end
end

function process(ff::FlipFlop)
    if !ff.recentPulse
        ff.state = !ff.state
        ff.sendPulse = ff.state
    else
        ff.sendPulse = nothing
    end
end
process(::Output) = nothing
function process(b::Broadcaster)
    b.sendPulse = false
end
function process(c::Conjunction)
    c.state = c.recentPulse
    c.sendPulse = !all(values(c.receiveFrom))
end

function send(m::Modules, name::String)
    m isa Output && return nothing, 0
    isnothing(m.sendPulse) && return nothing, 0
    sendPluse = m.sendPulse
    for receiver in m.sendTo
        eval(Symbol(receiver)).receiveFrom[name] = sendPluse
        eval(Symbol(receiver)).recentPulse = sendPluse
    end
    return sendPluse, length(m.sendTo)
end

getAllStates(names) = map(x -> eval(Symbol(x)).state, names)

function addN(nfalses, ntrues, n, pulse::Union{Bool,Nothing})
    isnothing(pulse) && return nfalses, ntrues
    pulse ? (ntrues += n) : (nfalses += n)
    return nfalses, ntrues
end

process(names::Dict{String,Bool}) = map(name -> process(eval(Symbol(name))), names)

function send(names::Vector{String})
    nfalses = ntrues = 0
    ns = OrderedDict{String,Bool}()
    for name in names
        pulse, n = send(eval(Symbol(name)), name)
        nfalses, ntrues = addN(nfalses, ntrues, n, pulse)
        isnothing(pulse) || map(x -> ns[x] = true, eval(Symbol(name)).sendTo)
    end
    return nfalses, ntrues, ns
end

function readData(path, ::Val{20})
    names = String[]
    receiverBuffer = Pair{String,String}[]
    for line in eachline(path)
        name, distination = split(line, " -> ")
        if name[1] == '%'
            name = name[2:end]
            eval(Meta.parse(join(("const ", name, "=FlipFlop()"))))
        elseif name[1] == '&'
            name = name[2:end]
            eval(Meta.parse(join(("const ", name, "=Conjunction()"))))
        else
            eval(Meta.parse(join(("const ", name, "=Broadcaster()"))))
        end
        push!(names, String(name))
        senders = map(String, split(distination, ", "))
        eval(Symbol(name)).sendTo = senders
        for receiver in senders
            if receiver ∈ names
                eval(Symbol(receiver)).receiveFrom[name] = false
            else
                push!(receiverBuffer, (receiver => name))
            end
        end
    end
    while !isempty(receiverBuffer)
        (receiver, sender) = pop!(receiverBuffer)
        if receiver ∈ names
            eval(Symbol(receiver)).receiveFrom[sender] = false
        else
            eval(Meta.parse(join(("const ", receiver, "=Output()"))))
        end
    end
    return names
end

function pushingButtonOnce()
    nf, nt, nextNames = send(["broadcaster"])
    nfalses, ntrues = 1 + nf, nt
    while !isempty(nextNames)
        nextNames = collect(keys(nextNames))
        process(nextNames)
        # display(nextNames)
        nf, nt, nextNames = send(nextNames)
        nfalses, ntrues = nfalses + nf, ntrues + nt
    end
    return nfalses, ntrues
end

function partOne(names)
    times = nfalses = ntrues = 0
    for _ in 1:100
        nf, nt = pushingButtonOnce()
        nfalses, ntrues = nfalses + nf, ntrues + nt
        times += 1
        if all(==(false), getAllStates(names))
            println("times: ", times, " nfalses: ", nfalses, " ntrues: ", ntrues)
            break
        end
    end
    return nfalses * ntrues
end

function partTwo(data)
    return 0
end

function day20_main()
    data = readData("data/2023/day20.txt", Val(20))
    return partOne(data), partTwo(data)
end

# test
data = readData("data/2023/day20.txt", Val(20))
day20_main()

# using BenchmarkTools
# @info "day20 性能："
# @btime day20_main()
