local node_data = require("src.gameplay.nodedata.base")
local components = require("src.gameplay.nodedata.components")
local icons      = require("assets.icons")

-- taken from path
local type_name = "fake"

return function (owner, params)
  local fake = node_data(type_name, owner, params.x, params.y)
  fake:addComponent(components.controllable)
  fake:addComponent(components.display, {
    icon = params.icon,
    label = "fake"
  })
  fake:addComponent(components.voter, {
    max_length = 1,
    vote_side = params.vote_side,
    on_vote = function (self)
    end
  })
  return fake
end
