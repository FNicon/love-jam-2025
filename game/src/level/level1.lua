local ui = require("src.ui")
local icons = require("assets.icons")
local goalnode = require("src.gameplay.goal.goalnode")
local characternode = require("src.gameplay.character.characternode")

local level = {}
level.name = "The First Door"
-- level1.icon = icons.level[1]

level.info = {
  nodes = {
    player = characternode.new{
      x = ui.buffer:getWidth() / 2 - 60,
      y = ui.buffer:getHeight() / 2,
      icon = icons.character[1],
      label = 'player',
      active = true
    },
    door = goalnode.new{
      x = ui.buffer:getWidth() / 2 + 60,
      y = ui.buffer:getHeight() / 2,
      icon = icons.object.door,
      label = 'Find exit',
      progress = {max = 4, current = 0}
    }
  },
  connections = {}
}

return level
