function readData(path="data/2021/day21.txt")
    firstPlayer, secondPlayer = readlines(path)
    firstPos = parse(Int, match(r"Player 1 starting position: (\d+)", firstPlayer).captures[1])
    secondPos = parse(Int, match(r"Player 2 starting position: (\d+)", secondPlayer).captures[1])
    return firstPos, secondPos
end

function playOneTime(current::Int, pos::Int, score::Int, playtime::Int)
    pos = mod1(pos + sum(mod1(current + i, 100) for i in 0:2), 10)
    return mod1(current + 3, 100), pos, score + pos, playtime + 3
end

function play(firstPos::Int, secondPos::Int)
    firstScore, secondScore = 0, 0
    diceNum, rolledTime = 1, 0
    while true
        diceNum, firstPos, firstScore, rolledTime = playOneTime(diceNum, firstPos, firstScore, rolledTime)
        firstScore >= 1000 && return secondScore * rolledTime
        diceNum, secondPos, secondScore, rolledTime = playOneTime(diceNum, secondPos, secondScore, rolledTime)
        secondScore >= 1000 && return firstScore * rolledTime
    end
end

const WINNUM = 21
const POSSIBILITYMAP = Dict{Int,Int}(
    5 => 6,
    4 => 3,
    6 => 7,
    7 => 6,
    9 => 1,
    8 => 3,
    3 => 1
)

getKeyNum(::Val{1}, firstScore::Int, secondScore::Int, firstPos::Int, secondPos::Int) = 1 << 20 + firstScore << 15 + secondScore << 10 + firstPos << 5 + secondPos

getKeyNum(::Val{0}, firstScore::Int, secondScore::Int, firstPos::Int, secondPos::Int) = firstScore << 15 + secondScore << 10 + firstPos << 5 + secondPos

function firstPlay!(firstUniverses::Int, secondUniverses::Int,
    firstScore::Int, secondScore::Int,
    firstPos::Int, secondPos::Int, possibility::Int,
    fWinBox::Dict{Int,Int}, sWinBox::Dict{Int,Int})
    if firstScore >= WINNUM
        firstUniverses += possibility
        return firstUniverses, secondUniverses
    end
    k = getKeyNum(Val(1), firstScore, secondScore, firstPos, secondPos)
    if haskey(sWinBox, k)
        firstUniverses += possibility * fWinBox[k]
        secondUniverses += possibility * sWinBox[k]
    else
        f, s = firstUniverses, secondUniverses
        for step in 3:9
            newSecondPos = mod1(secondPos + step, 10)
            f, s = secondPlay!(f, s,
                firstScore, secondScore + newSecondPos,
                firstPos, newSecondPos,
                possibility * POSSIBILITYMAP[step],
                fWinBox, sWinBox)
        end
        fWinBox[k] = (f - firstUniverses) ÷ possibility
        sWinBox[k] = (s - secondUniverses) ÷ possibility
        firstUniverses, secondUniverses = f, s
    end
    return firstUniverses, secondUniverses
end

function secondPlay!(firstUniverses::Int, secondUniverses::Int,
    firstScore::Int, secondScore::Int,
    firstPos::Int, secondPos::Int, possibility::Int,
    fWinBox::Dict{Int,Int}, sWinBox::Dict{Int,Int})
    if secondScore >= WINNUM
        secondUniverses += possibility
        return firstUniverses, secondUniverses
    end
    k = getKeyNum(Val(0), firstScore, secondScore, firstPos, secondPos)
    if haskey(fWinBox, k)
        firstUniverses += possibility * fWinBox[k]
        secondUniverses += possibility * sWinBox[k]
    else
        f, s = firstUniverses, secondUniverses
        for step in 3:9
            newFirstPos = mod1(firstPos + step, 10)
            f, s = firstPlay!(f, s,
                firstScore + newFirstPos, secondScore,
                newFirstPos, secondPos,
                possibility * POSSIBILITYMAP[step],
                fWinBox, sWinBox)
        end
        fWinBox[k] = (f - firstUniverses) ÷ possibility
        sWinBox[k] = (s - secondUniverses) ÷ possibility
        firstUniverses, secondUniverses = f, s
    end
    return firstUniverses, secondUniverses
end

function play!(firstPos::Int, secondPos::Int)
    firstUniverses, secondUniverses = 0, 0
    f, s = Dict{Int,Int}(), Dict{Int,Int}()
    firstUniverses, secondUniverses = secondPlay!(
        firstUniverses, secondUniverses,
        0, 0,
        firstPos, secondPos,
        1,
        f, s)
    return max(firstUniverses, secondUniverses)
end

using BenchmarkTools
@btime begin
    firstPos, secondPos = readData()
    play(firstPos, secondPos)
    play!(firstPos, secondPos)
end