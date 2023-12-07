using BenchmarkTools

year = 2023
file = "day7.jl"

eval(:(include(joinpath("$year", $file))))
name = split(file, ".")[1]
evalRes = @benchmark eval(Symbol($name, "_main"))()
str = "|    $name | :white_check_mark: | :white_check_mark: |  $(BenchmarkTools.prettytime(time(evalRes))) |      $(BenchmarkTools.prettymemory(memory(evalRes))) |  [link](https://github.com/jake484/adventofcode/blob/master/$year/$file)  |\n"

open("temp.md", "w") do io
    write(io, str)
end

@info "性能测试完成！"

