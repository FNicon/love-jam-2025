local ui = require("src.ui.ui")
local icons = require("assets.icons")
local goalnode = require("src.gameplay.goal.goalnode")
local characternode = require("src.gameplay.character.characternode")
local votetype = require("src.gameplay.vote.votetype")

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
          active = true,
          maxlength = 200,
        },
        enemy = {
          x = 4,
          y = 1,
          icon = icons.enemy[1],
          label = 'ooze',
          active = true,
          maxlength = 200,
        }
      },
      goals = {
        door = {
          x = 4,
          y = 2,
          icon = icons.object.door,
          label = 'Open door',
          progressmax = 4,
          maxlength = 200,
        },
      },
    },
    connections = {
      enemy = { side = votetype.oppose.label, nodes = {"door"} }
    }
  }
end

return level
