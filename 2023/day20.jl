mutable struct FlipFlop
    state::Bool
    sendTo::Vector{String}
    receiveFrom::Dict{String,Bool}
    recentPulse::Bool
    function FlipFlop()
        new(false, String[], Dict{String,Bool}(), false, false)
    end
end

mutable struct Broadcaster
    state::Bool
    sendTo::Vector{String}
    receiveFrom::Dict{String,Bool}
    recentPulse::Bool
    function Broadcaster()
        new(false, String[], Dict{String,Bool}(), false, false)
    end
end

mutable struct Conjunction
    state::Bool
    sendTo::Vector{String}
    receiveFrom::Dict{String,Bool}
    recentPulse::Bool
    function Conjunction()
        new(false, String[], Dict{String,Bool}(), false, false)
    end
end
mutable struct Output end

function process(ff::FlipFlop, name::String)
    sendPluse = false
    if !ff.recentPulse
        ff.state = !ff.state
        sendPluse = ff.state
    end
    sendPluse = nothing
    for receiver in ff.sendTo
        eval(Symbol(receiver)).receiveFrom[name] = sendPluse
        eval(Symbol(receiver)).recentPulse = sendPluse
    end
    return sendPluse, length(ff.sendTo)
end

process(e::Output, name) = nothing

function process(b::Broadcaster, name::String)
    sendPluse = false
    for receiver in ff.sendTo
        eval(Symbol(receiver)).receiveFrom[name] = sendPluse
        eval(Symbol(receiver)).recentPulse = sendPluse
    end
    return sendPluse, length(b.sendTo)
end

function process(c::Conjunction, name::String)
    c.state = c.recentPulse
    sendPluse = !all(values(c.receiveFrom))
    for receiver in c.sendTo
        eval(Symbol(receiver)).receiveFrom[name] = sendPluse
        eval(Symbol(receiver)).recentPulse = sendPluse
    end
    return sendPluse, length(c.sendTo)
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

getAllStates(names) = map(x -> eval(Symbol(x)).state, names)

function pushingButtonOnce(senders, receivers)
    nextNames = broadcaster.sendTo
    nextPulses = map(x -> process(eval(Symbol(x)), "broadcaster")[1], nextNames)
    nfalses, ntrues = 1 + length(nextPulses), 0
    while any(!isnothing, nextPulses)
        ps = Union{Bool,Nothing}[]
        ns = String[]
        for (name, pulse) in zip(nextNames, nextPulses)
            if !isnothing(pulse)
                append!(ns, senders[name])
                p = map(x -> process(pulse, eval(Symbol(x)), receivers, x), senders[name])
                if pulse
                    ntrues += length(p)
                else
                    nfalses += length(p)
                end
                append!(ps, p)
            end
        end
        nextNames, nextPulses = ns, ps
        # nfalses += count(==(false), nextPulses)
        # ntrues += count(==(true), nextPulses)
        # println("nextNames: ", nextNames, " nextPulses: ", nextPulses)
        # println("nfalses: ", nfalses, " ntrues: ", ntrues)
    end
    # println("nfalses: ", nfalses, " ntrues: ", ntrues)
    return nfalses, ntrues
end

function partOne(data)
    senders, receivers, names = data
    times = 0
    nfalses, ntrues = 0, 0
    for _ in 1:1
        nf, nt = pushingButtonOnce(senders, receivers)
        nfalses, ntrues = nfalses + nf, ntrues + nt
        times += 1
        # if all(==(false), getAllStates(names))
        #     println("times: ", times, " nfalses: ", nfalses, " ntrues: ", ntrues)
        #     break
        # end
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
# day20_main()

# using BenchmarkTools
# @info "day20 性能："
# @btime day20_main()
