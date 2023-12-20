mutable struct FlipFlop
    state::Bool
    function FlipFlop()
        new(false)
    end
end

mutable struct Conjunction
    state::Bool
    function Conjunction()
        new(false)
    end
end
mutable struct Output end

function process(pulse::Bool, ff::FlipFlop, outputToInput, name)
    if !pulse
        ff.state = !ff.state
        return ff.state
    end
    return nothing
end

process(pulse::Bool, e::Output, outputToInput, name) = return nothing

function process(pulse::Bool, c::Conjunction, outputToInput, name)
    c.state = pulse
    return !all(x -> eval(Symbol(x)).state == true, outputToInput[name])
end

function readData(path, ::Val{20})
    inputToOutput, names = Dict{String,Vector{String}}(), String[]
    outputToInput = Dict{String,Vector{String}}()
    for line in eachline(path)
        name, distination = split(line, " -> ")
        if name[1] == '%'
            name = String(name[2:end])
            push!(names, name)
            eval(Meta.parse(join(("const ", name, "=FlipFlop()"))))
        elseif name[1] == '&'
            name = String(name[2:end])
            push!(names, name)
            eval(Meta.parse(join(("const ", name, "=Conjunction()"))))
        end
        inputToOutput[name] = map(String, split(distination, ", "))
        for output in inputToOutput[name]
            if haskey(outputToInput, output)
                push!(outputToInput[output], name)
            else
                outputToInput[output] = [name]
            end
        end
    end
    allName = reduce(vcat, values(inputToOutput))
    for name in setdiff(allName, names)
        eval(Meta.parse(join(("const ", name, "=Output()"))))
    end
    return inputToOutput, outputToInput, names
end

getAllStates(names) = map(x -> eval(Symbol(x)).state, names)

function pushingButtonOnce(inputToOutput, outputToInput)
    nextNames = inputToOutput["broadcaster"]
    nextPulses = map(x -> process(false, eval(Symbol(x)), outputToInput, "broadcaster"), nextNames)
    # println("nextNames: ", nextNames, " nextPulses: ", nextPulses)
    nfalses, ntrues = 1 + length(nextPulses), 0
    while any(!isnothing, nextPulses)
        ps = Union{Bool,Nothing}[]
        ns = String[]
        for (name, pulse) in zip(nextNames, nextPulses)
            if !isnothing(pulse)
                append!(ns, inputToOutput[name])
                p = map(x -> process(pulse, eval(Symbol(x)), outputToInput, x), inputToOutput[name])
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
    inputToOutput, outputToInput, names = data
    times = 0
    nfalses, ntrues = 0, 0
    for _ in 1:1000
        nf, nt = pushingButtonOnce(inputToOutput, outputToInput)
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
# data = readData("data/2023/day20.txt", Val(20))
day20_main()

# using BenchmarkTools
# @info "day20 性能："
# @btime day20_main()
