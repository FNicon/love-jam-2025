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
      characters = {
        player = {
          x = 3,
          y = 2,
          icon = icons.character[1],
          label = 'player',
          active = true,
          maxlength = 2,
        }
      },
      goals = {
        door = {
          x = 4,
          y = 2,
          icon = icons.object.door,
          label = 'Find exit',
          progressmax = 4,
          maxlength = 2,
        }
      }
    },
    connections = {}
  }
end

return level
