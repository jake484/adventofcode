function readData(path="data/2021/day20.txt")
    data = readlines(path)
    enhancementAlgorithm = data[1]
    mapData = data[3:end]
    image = zeros(Int, length(mapData), length(mapData[1]))
    for (i, row) in enumerate(mapData)
        for (j, c) in enumerate(row)
            image[i, j] = Int(c == '#')
        end
    end
    return enhancementAlgorithm, image
end

const ninePixels = (CartesianIndex(-1, -1), CartesianIndex(-1, 0), CartesianIndex(-1, 1), CartesianIndex(0, -1), CartesianIndex(0, 0), CartesianIndex(0, 1), CartesianIndex(1, -1), CartesianIndex(1, 0), CartesianIndex(1, 1))

function expandMap(image::Matrix{Int}, ::Val{0})
    imageSize = size(image)
    image = hcat(zeros(Int, imageSize[1], 1), image, zeros(Int, imageSize[1], 1))
    image = vcat(zeros(Int, 1, imageSize[2] + 2), image, zeros(Int, 1, imageSize[2] + 2))
    return image
end

function expandMap(image::Matrix{Int}, ::Val{1})
    imageSize = size(image)
    image = hcat(ones(Int, imageSize[1], 1), image, ones(Int, imageSize[1], 1))
    image = vcat(ones(Int, 1, imageSize[2] + 2), image, ones(Int, 1, imageSize[2] + 2))
    return image
end

function enhanceOnePoint(current::CartesianIndex{2}, image::Matrix{Int}, algorithm::String, outer::Int)
    num = 0
    for i in ninePixels
        ind = current + i
        num = num << 1 + (checkbounds(Bool, image, ind) ? image[ind] : outer)
    end
    return Int(algorithm[num+1] == '#')
end

function enhanceImageOnce(image::Matrix{Int}, algorithm::String, outer::Int=0)
    image = expandMap(image, Val(outer))
    newImage = copy(image)
    for ind in CartesianIndices(newImage)
        newImage[ind] = enhanceOnePoint(ind, image, algorithm, outer)
    end
    newouter = outer == 0 ? first(algorithm) : last(algorithm)
    return newImage, Int(newouter == '#')
end

function enhanceImage(image::Matrix{Int}, algorithm::String, numTimes::Int, outer::Int=0)
    for _ in Base.OneTo(numTimes)
        image, outer = enhanceImageOnce(image, algorithm, outer)
    end
    return image, outer
end

using BenchmarkTools
@btime begin
    algorithm, image = readData()
    image, outer = enhanceImage(image, algorithm, 2)
    sum(image)
    image, outer = enhanceImage(image, algorithm, 48, outer)
    sum(image)
end
# for i in eachcol(image)
#     print(i |> sum, " ")
# end