local ui = require("src.ui.ui")
local icons = require("assets.icons")
local goalnode = require("src.gameplay.goal.goalnode")
local characternode = require("src.gameplay.character.characternode")

local level = {}
level.name = "Two Doors"
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
          maxlength = 200,
        }
      },
      goals = {
        door1 = {
          x = 4,
          y = 1,
          icon = icons.object.door,
          label = 'Check door',
          progressmax = 4,
          maxlength = 200,
        },
        door2 = {
          x = 4,
          y = 3,
          icon = icons.object.door,
          label = 'Check door',
          progressmax = 4,
          maxlength = 200,
        }
      }
    },
    connections = {}
  }
end

return level
