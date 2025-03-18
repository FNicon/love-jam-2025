local ui = require("src.ui")
local icons = require("assets.icons")
local goalnode = require("src.gameplay.goal.goalnode")
local characternode = require("src.gameplay.character.characternode")

local level = {}
level.name = "Opposition"
-- level1.icon = icons.level[1]

function level.load(nodes)
  table.insert(nodes, characternode.new{
    x = ui.buffer:getWidth() / 2 - 60,
    y = ui.buffer:getHeight() / 2,
    icon = icons.character[1],
    label = 'player',
    active = true
  })
  table.insert(nodes, goalnode.new{
    x = ui.buffer:getWidth() / 2 + 60,
    y = ui.buffer:getHeight() / 2,
    icon = icons.object.door,
    label = 'find exit',
    progress = {max = 4, current = 0}
  })
  table.insert(nodes, characternode.new{
    x = ui.buffer:getWidth() / 2,
    y = ui.buffer:getHeight() / 2 - 60,
    icon = icons.character[1],
    label = 'enemy',
    active = true
  })
end

return level
