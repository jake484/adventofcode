using BenchmarkTools

year = 2020

str = read("README.md", String)

str *= "\n\n## $year

|  Day |      Part One      |      Part Two      |      Time | Allocated memory |                                   Source                                   |
| ---: | :----------------: | :----------------: | --------: | ---------------: | :------------------------------------------------------------------------: |\n"

for file in readdir("$year")
    eval(:(include(joinpath("$year", $file))))
    name = split(file, ".")[1]
    evalRes = @benchmark eval(Symbol($name, "_main"))()
    global str *= "|    $name | :white_check_mark: | :white_check_mark: |  $(BenchmarkTools.prettytime(time(evalRes))) |      $(BenchmarkTools.prettymemory(memory(evalRes))) |  [link](https://github.com/jake484/adventofcode/blob/master/$year/$file)  |\n"
end

open("temp.md", "w") do io
    write(io, str)
end

@info "性能测试完成！"

