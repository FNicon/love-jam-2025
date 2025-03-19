local votemanager = require("src.gameplay.vote.votemanager")
local graph       = require("lib.graph")

local levels = {
  require("src.level.level1"),
  require("src.level.level2"),
  require("src.level.level3")
}

local levelmanager = {}
local currentlevel = 0
local currentgoals = {}
local currentparticipants = {}
local currentvotemanager = {}

function levelmanager.init(nodes)
  levelmanager.nodes = nodes
  levelmanager.currentlevelname = "No Level Loaded"
end

function levelmanager.load(index)
  levelmanager.nodes = {}
  if index <= #levels then
    currentlevel = index
    local level = levels[index]
    levelmanager.currentlevelname = level.name
    for name, node in pairs(level.info.nodes) do
      if level.info.connections[name] ~= nil then
        if level.info.connections[name]["oppose"] ~= nil then
          for _, nodename in ipairs(level.info.connections[name]["oppose"]) do
            node.lambda.oppose(level.info.nodes[nodename])
          end
        end
        if level.info.connections[name]["support"] ~= nil then
          for _, nodename in ipairs(level.info.connections[name]["support"]) do
            node.lambda.support(level.info.nodes[nodename])
          end
        end
      end
      table.insert(levelmanager.nodes, node)
    end
    currentgoals = votemanager.retrieveallgoals(levelmanager.nodes)
    currentparticipants = votemanager.retrieveallparticipants(levelmanager.nodes)
    currentvotemanager = votemanager.new()
    currentvotemanager:addvoteboxlist(currentgoals)
  else
    error("Level not found: " .. index)
  end
end

function levelmanager.progressvote()
  if not levelmanager.islevelcompleted() then
    currentvotemanager:startvote(currentparticipants)
    currentvotemanager:endvote()
  end
end

function levelmanager.islevelcompleted()
  if currentgoals == nil or #currentgoals == 0 then
    return true
  else
    local foundunfinishedgoal = false
    for _, goal in ipairs(currentgoals) do
      print(goal.data.goal.state)
      if goal.data.goal.state ~= "decided" then
        foundunfinishedgoal = true
        break
      end
    end
    return not foundunfinishedgoal
  end
end

function levelmanager.islevelwin()
  local foundfailuregoal = false
  for _, goal in ipairs(currentgoals) do
    if goal.data.goal.state ~= "decided" then
      if goal.data.goal.winner == "oppose" then
        foundfailuregoal = true
        break
      end
    end
  end
  return not foundfailuregoal
end

function levelmanager.checklevelprogress()
  if levelmanager.islevelcompleted() then
    print("Level completed!")
    print(levelmanager.islevelwin())
    if levelmanager.islevelwin() then
      levelmanager.loadnextlevel()
    else
      levelmanager.restartlevel()
    end
  else
    print("Level in progress...")
  end
end

function levelmanager.restartlevel()
  if currentlevel == nil then
    error("No level loaded")
  else
    levelmanager.load(currentlevel)
  end
end

function levelmanager.loadnextlevel()
  if levelmanager.islevelcompleted() and currentlevel < #levels then
    levelmanager.load(currentlevel + 1)
  else
    print("All levels completed!")
  end
end

function levelmanager.printlevel()
  -- local x = ui.buffer:getWidth() + 60
  -- local y = ui.buffer:getHeight() + 60
  local label = levels[currentlevel].name
  print("Current Level: " .. currentlevel)
  print("Level Name: " .. label)
  -- ui.print(label, x, y)
end

function levelmanager.collectEdges()
  local edges = {}
  local visited = graph.visitedSet()
  for _, node in ipairs(levelmanager.nodes) do
    if not visited:contains(node) then
      graph.traverse{node, onVisit = function (node)
        for _, neighbor in ipairs(node.neighbors) do
          if not visited:contains(neighbor) then
            table.insert(edges, graph.edge(node, neighbor))
          end
        end
      end}
    end
  end
  return edges
end

return levelmanager
