local node_data = require("src.gameplay.nodedata.base")
local components = require("src.gameplay.nodedata.components")
local icons      = require("assets.icons")

local type_name = "player"

return function (owner, params)
  local player = node_data(type_name, owner, params.x, params.y)
  player:addComponent(components.voter, {
    max_length = 1,
    vote_side = "support",
    on_vote = function (self)
    end
  })
  player:addComponent(components.controllable)
  player:addComponent(
    components.display,
    {
      icon = icons.player,
      label = params.label or type_name
    }
  )
  return player
end
