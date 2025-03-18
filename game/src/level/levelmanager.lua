local ui = require("src.ui")
local votemanager = require("src.gameplay.vote.votemanager")

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
end

function levelmanager.load(index)
  levelmanager.nodes = {}
  if index <= #levels then
    currentlevel = index
    levels[index].load(levelmanager.nodes)
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

return levelmanager
