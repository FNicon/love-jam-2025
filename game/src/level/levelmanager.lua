local levels = {
  require("src.level.level1"),
  require("src.level.level2")
}

local levelmanager = {}
local currentlevel = 0

function levelmanager.init(nodes, graph, icons, ui)
  levelmanager.nodes = nodes
  levelmanager.graph = graph
  levelmanager.icons = icons
  levelmanager.ui = ui
end

function levelmanager.load(index)
  local nodes = levelmanager.nodes
  local graph = levelmanager.graph
  local icons = levelmanager.icons
  local ui = levelmanager.ui
  if index <= #levels then
    currentlevel = index
    levelmanager.printlevel()
    levels[index].load(nodes, graph, icons, ui)
  else
    error("Level not found: " .. index)
  end
end

function levelmanager.printlevel()
  local x = levelmanager.ui.buffer:getWidth() + 60
  local y = levelmanager.ui.buffer:getHeight() + 60
  local label = levels[currentlevel].name
  print("Current Level: " .. currentlevel)
  print("Level Name: " .. label)
  -- levelmanager.ui.print(label, x, y)
end

return levelmanager
