# 读取数据
rawData = readlines("data/day16.txt")

# 用':'和','分割数据
rawData = split.(rawData, (c -> c == ',' || c == ';' || c == '='))

# 提取数字字符串数组中的数字
flowRatedata = map(x -> parse(Int, x[2]), rawData)

# 用正则表达式提取两个大写字母
startFlowNameNodes = map(x -> match(r"[A-Z]{2}", x[1]).match, rawData)

# 用正则表达式提取x[3:end]中的两个大写字母
endFlowNameNodes = map(x -> map(y -> match(r"[A-Z]{2}", y).match |> string, x[3:end]), rawData)

# 构建startFlowNameNodes的字典
FlowNameNodesDict = Dict(zip(startFlowNameNodes, eachindex(startFlowNameNodes)))

using Graphs

# 构建图
g = Graph(length(startFlowNameNodes))

# 添加边
for i in eachindex(startFlowNameNodes)
    for j in endFlowNameNodes[i]
        add_edge!(g, FlowNameNodesDict[startFlowNameNodes[i]], FlowNameNodesDict[j])
    end
end

# 计算流量与最短路径的乘积的最小值
function minimunPressure!(flowRatedata::Vector{Int}, node::Int64, timeleft::Int64, isopen::BitVector)
    shortestPath = dijkstra_shortest_paths(g, node).dists
    m = 0
    newtimeleft = timeleft
    for i in eachindex(shortestPath)
        if shortestPath[i] + 1 <= timeleft && !isopen[i]
            tleft = timeleft - shortestPath[i] - 1
            pressure = tleft * flowRatedata[i]
            m, node, newtimeleft = m < pressure / (shortestPath[i] + 1) ? (pressure, i, tleft) : (m, node, newtimeleft)
        end
    end
    isopen[node] = true
    return m, node, newtimeleft
end

# 计算一定时间内的最大压力
function biggestPreesure(timeleft::Int64, node::Int64, flowRatedata::Vector{Int64}, g::Graph)
    pressure = 0
    m = 0
    isopen = falses(lastindex(flowRatedata))
    while timeleft > 0
        m, node, timeleft = minimunPressure!(flowRatedata, node, timeleft, isopen)
        println("node: ", node, " m: ", m, " timeleft: ", timeleft)
        if m == 0
            break
        end
        pressure += m

    end
    println("isopen: ", isopen)
    return pressure
end

biggestPreesure(30, 1, flowRatedata, g)

dijkstra_shortest_paths(g, 4).dists

findall(!=(0), flowRatedata)

notzeroindex = findall(!=(0), flowRatedata)

# 节点直接的最短路径表
shortestPathMap = reduce(hcat, [dijkstra_shortest_paths(g, i).dists for i in notzeroindex])

# 递归计算最大压力


function maxPressure!(flowRatedata::Vector{Int}, node::Int64, timeleft::Int64, isopen::BitVector, indexs::Vector{Int64})
    shortestPath = dijkstra_shortest_paths(g, node).dists
    m = 0
    newtimeleft = timeleft
    for i in eachindex(shortestPath)
        if shortestPath[i] + 1 <= timeleft && !isopen[i]
            tleft = timeleft - shortestPath[i] - 1
            pressure = tleft * flowRatedata[i]
            m, node, newtimeleft = m < pressure / (shortestPath[i] + 1) ? (pressure, i, tleft) : (m, node, newtimeleft)
        end
    end
    isopen[node] = true
    return m, node, newtimeleft
end