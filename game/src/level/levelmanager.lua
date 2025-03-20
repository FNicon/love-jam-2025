local votemanager = require("src.gameplay.vote.votemanager")
local graph       = require("src.data.graph")
local distancecalculator = require("src.data.distance")
local grid        = require("src.data.grid")
local characternode = require("src.gameplay.character.characternode")
local goalnode      = require("src.gameplay.goal.goalnode")

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
  levelmanager.grid = grid.new(60)
end

local function createCharacterNode(info)
  local worldx, worldy = levelmanager.grid:gridToWorldCoords(info.x, info.y)
  return characternode.new{
    x = worldx,
    y = worldy,
    icon = info.icon,
    label = info.label,
    active = info.active,
    maxlength = info.maxlength,
  }
end

local function createGoalNode(info)
  local worldx, worldy = levelmanager.grid:gridToWorldCoords(info.x, info.y)
  return goalnode.new{
    x = worldx,
    y = worldy,
    icon = info.icon,
    label = info.label,
    progress = {max = info.progressmax, current = 0},
    maxlength = info.maxlength,
  }
end

function levelmanager.load(index)
  print("Loading Level " .. index)
  levelmanager.nodes = {}
  if index <= #levels then
    currentlevel = index
    local level = levels[index]
    levelmanager.currentlevelname = level.name
    local levelinfo = level.load()
    local nodemap = {}
    for name, info in pairs(levelinfo.nodes.characters) do
      local node = createCharacterNode(info)
      table.insert(levelmanager.nodes, node)
      nodemap[name] = node
    end
    for name, info in pairs(levelinfo.nodes.goals) do
      local node = createGoalNode(info)
      table.insert(levelmanager.nodes, node)
      nodemap[name] = node
    end
    for name, node in pairs(nodemap) do
      if levelinfo.connections[name] ~= nil then
        local side = levelinfo.connections[name].side
        local targetname = levelinfo.connections[name].nodes
        for _, target in ipairs(targetname) do
          for checktarget, targetnode in pairs(levelinfo.nodes) do
            if checktarget == target then
              local length = distancecalculator.manhattan(node.data.x, node.data.y, targetnode.data.x, targetnode.data.y)
              node.lambda.pickside(targetnode, side, length)
            end
          end
        end
      end
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
    currentvotemanager:startvote(currentparticipants, currentgoals)
    currentvotemanager:endvote()
  end
end

function levelmanager.islevelcompleted()
  if currentgoals == nil or #currentgoals == 0 then
    return true
  else
    local foundunfinishedgoal = false
    for _, goal in ipairs(currentgoals) do
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
    print("restarting")
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
