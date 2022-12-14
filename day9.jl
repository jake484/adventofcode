data = readlines("data/day9.txt")
data = split.(data, ' ')
isVisted = falses(1000, 1000)
function updateTailPos(HxNew::Int, HyNew::Int, Tx::Int, Ty::Int)
    if abs(HxNew - Tx) <= 1 && abs(HyNew - Ty) <= 1
        return Tx, Ty
    elseif abs(HxNew - Tx) > 1 && abs(HyNew - Ty) <= 1
        if HxNew > Tx
            return HxNew - 1, HyNew
        else
            return HxNew + 1, HyNew
        end
    elseif abs(HyNew - Ty) > 1 && abs(HxNew - Tx) <= 1
        if HyNew > Ty
            return HxNew, HyNew - 1
        else
            return HxNew, HyNew + 1
        end
    else
        if HxNew > Tx && HyNew > Ty
            return HxNew - 1, HyNew - 1
        elseif HxNew > Tx && HyNew < Ty
            return HxNew - 1, HyNew + 1
        elseif HxNew < Tx && HyNew > Ty
            return HxNew + 1, HyNew - 1
        else
            return HxNew + 1, HyNew + 1
        end
    end
end

function moveOneStep(direction::AbstractString, Hx::Int, Hy::Int, Tx::Int, Ty::Int)
    HxNew, HyNew, TxNew, TyNew = zeros(Int, 4)
    if direction == "U"
        HxNew = Hx
        HyNew = Hy + 1
    elseif direction == "D"
        HxNew = Hx
        HyNew = Hy - 1
    elseif direction == "L"
        HxNew = Hx - 1
        HyNew = Hy
    elseif direction == "R"
        HxNew = Hx + 1
        HyNew = Hy
    end
    TxNew, TyNew = updateTailPos(HxNew, HyNew, Tx, Ty)
    return HxNew, HyNew, TxNew, TyNew
end

# part one 
Hx, Hy, Tx, Ty = [500, 500, 500, 500]
isVisted[Tx, Ty] = true

for move in data
    for i in 1:parse(Int, move[2])
        global Hx, Hy, Tx, Ty = moveOneStep(move[1], Hx, Hy, Tx, Ty)
        isVisted[Tx, Ty] = true
    end
end

count(isVisted)


# part two
isVisted = falses(1000, 1000)
Hx, Hy = 500 * ones(Int, 2)
Tx, Ty = 500 * ones(Int, 9), 500 * ones(Int, 9)
isVisted[Hx, Hy] = true
for move in data
    for i in 1:parse(Int, move[2])
        global Hx, Hy, Tx[1], Ty[1] = moveOneStep(move[1], Hx, Hy, Tx[1], Ty[1])
        for k in 1:8
            global Tx[k+1], Ty[k+1] = updateTailPos(Tx[k], Ty[k], Tx[k+1], Ty[k+1])
        end
        global isVisted[Tx[9], Ty[9]] = true
    end
end
count(isVisted)

# res = findall(isVisted)

# map(x -> (x - CartesianIndex(500, 500)), res)