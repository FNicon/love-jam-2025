local ui = require("src.ui")

local levels = {
  require("src.level.level1"),
  require("src.level.level2")
}

local levelmanager = {}
local currentlevel = 0

function levelmanager.init(nodes)
  levelmanager.nodes = nodes
end

function levelmanager.load(index)
  local nodes = levelmanager.nodes
  if index <= #levels then
    currentlevel = index
    levelmanager.printlevel()
    levels[index].load(nodes)
  else
    error("Level not found: " .. index)
  end
end

function levelmanager.printlevel()
  local x = ui.buffer:getWidth() + 60
  local y = ui.buffer:getHeight() + 60
  local label = levels[currentlevel].name
  print("Current Level: " .. currentlevel)
  print("Level Name: " .. label)
  -- levelmanager.ui.print(label, x, y)
end

return levelmanager
