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
      player = characternode.new{
        x = ui.getWorldWidth() / 2 - 60,
        y = ui.getWorldHeight() / 2,
        icon = icons.character[1],
        label = 'player',
        active = true,
        maxlength = 200,
      },
      enemy1 = characternode.new{
        x = ui.getWorldWidth() / 2,
        y = ui.getWorldHeight() / 2 - 60,
        icon = icons.enemy[1],
        label = 'enemy',
        active = true,
        maxlength = 200,
      },
      door = goalnode.new{
        x = ui.getWorldWidth() / 2 + 60,
        y = ui.getWorldHeight() / 2,
        icon = icons.object.door,
        label = 'find exit',
        progress = {max = 4, current = 0},
        maxlength = 200,
      },
    },
    connections = {
      enemy1 = { side = votetype.oppose.label, nodes = {"door"} }
    }
  }
end

return level
