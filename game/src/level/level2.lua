local ui = require("src.ui.ui")
local icons = require("assets.icons")
local goalnode = require("src.gameplay.goal.goalnode")
local characternode = require("src.gameplay.character.characternode")

local level = {}
level.name = "Two Doors"
-- level1.icon = icons.level[1]

level.info = {
  nodes = {
    player = characternode.new{
      x = ui.getWorldWidth() / 2 - 60,
      y = ui.getWorldHeight() / 2,
      icon = icons.character[1],
      label = 'player',
      active = true
    },
    door1 = goalnode.new{
      x = ui.getWorldWidth() / 2 + 60,
      y = ui.getWorldHeight() / 2,
      icon = icons.object.door,
      label = 'check door',
      progress = {max = 4, current = 0}
    },
    door2 = goalnode.new{
      x = ui.getWorldWidth() / 2,
      y = ui.getWorldHeight() / 2 + 60,
      icon = icons.object.door,
      label = 'check door',
      progress = {max = 4, current = 0}
    }
  },
  connections = {}
}

return level
