
local level1 = require("src.level.level1")

local levels = {
  ["level1"] = level1,
}

local levelmanager = {}

function levelmanager.init(nodes, graph, icons, ui)
  levelmanager.nodes = nodes
  levelmanager.graph = graph
  levelmanager.icons = icons
  levelmanager.ui = ui
end

function levelmanager.load(levelname)
  local nodes = levelmanager.nodes
  local graph = levelmanager.graph
  local icons = levelmanager.icons
  local ui = levelmanager.ui
  if levelname == "level1" then
    levels[levelname].load(nodes, graph, icons, ui)
  else
    error("Level not found: " .. levelname)
  end
end

return levelmanager
