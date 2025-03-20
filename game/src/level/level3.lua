local ui = require("src.ui.ui")
local icons = require("assets.icons")
local goalnode = require("src.gameplay.goal.goalnode")
local characternode = require("src.gameplay.character.characternode")

local level = {}
level.name = "Opposition"
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
          active = true
        },
        enemy = {
          x = 4,
          y = 1,
          icon = icons.enemy[1],
          label = 'ooze',
          active = true
        }
      },
      goals = {
        door = {
          x = 4,
          y = 2,
          icon = icons.object.door,
          label = 'Open door',
          progressmax = 4
        }
      }
    },
    connections = {
      enemy = { oppose = {"door"} }
    }
  }
end

return level
