data = readlines("data/day6.txt")[1]
# part one 
for i in 1:length(data)-13
    if (length(unique(data[i:i+13])) == 14)
        println(i + 13)
        break
    end
end

# part two
