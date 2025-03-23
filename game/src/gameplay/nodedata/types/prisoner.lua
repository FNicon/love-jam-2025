local node_data = require("src.gameplay.nodedata.base")
local components = require("src.gameplay.nodedata.components")
local icons      = require("assets.icons")

local type_name = "prisoner"

return function (owner, params)
  local prisoner = node_data(type_name, owner, params.x, params.y)
  prisoner:addComponent(components.controllable)
  prisoner:addComponent(components.display, {
    icon = icons.prisoner_2,
    label = "prisoner"
  })
  prisoner:addComponent(components.voter, {
    max_length = 1,
    vote_side = params.vote_side,
    on_vote = function (self)
    end
  })
  return prisoner
end
