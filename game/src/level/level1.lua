local ui = require("src.ui.ui")
local icons = require("assets.icons")
local goalnode = require("src.gameplay.goal.goalnode")
local characternode = require("src.gameplay.character.characternode")

local level = {}
level.name = "The First Door"
-- level1.icon = icons.level[1]

level.load = function ()
  return {
    nodes = {
      player = characternode.new{
        x = ui.getWorldWidth() / 2 - 60,
        y = ui.getWorldHeight() / 2,
        icon = icons.character[1],
        label = 'player',
        active = true,
        maxlength = 200,
      },
      door = goalnode.new{
        x = ui.getWorldWidth() / 2 + 60,
        y = ui.getWorldHeight() / 2,
        icon = icons.object.door,
        label = 'Find exit',
        progress = {max = 4, current = 0},
        maxlength = 200,
      }
    },
    connections = {}
  }
end

return level
