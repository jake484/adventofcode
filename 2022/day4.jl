data = readlines("data/2022/day4.txt")
data = split.(data, (c -> c == ',' || c == '-'))
# part one 
s = 0
for i in data
    i = parse.(Int, i)
    d = i[1]:i[2] ⊆ i[3]:i[4] || i[1]:i[2] ⊇ i[3]:i[4] ? 1 : 0
    global s += d
end
s


# part two
s = 0
for i in data
    i = parse.(Int, i)
    inter = intersect(collect(i[1]:i[2]), collect(i[3]:i[4]))
    d = isempty(inter) ? 0 : 1
    global s += d
end
s