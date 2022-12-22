data = readlines("data/2022/day3.txt")

# part one 
s = 0
for i in eachindex(data)
    l = length(data[i]) >> 1
    ch = intersect(data[i][1:l], data[i][l+1:end])[1]
    global s += isuppercase(ch) ? 27 + ch - 'A' : ch - 'a' + 1
end


s = 0
for i in 1:3:lastindex(data)
    ch = intersect(data[i:i+2]...)[1]
    global s += isuppercase(ch) ? 27 + ch - 'A' : ch - 'a' + 1
end
s
