local node_data = require("src.gameplay.nodedata.base")
local components = require("src.gameplay.nodedata.components")
local icons      = require("assets.icons")

local type_name = "path"

return function (owner, params)
  local path = node_data(type_name, owner, params.x, params.y)
  path:addComponent(components.controllable)
  path:addComponent(components.display, {
    icon = icons.path,
    label = "path"
  })
  path:addComponent(components.voter, {
    max_length = 1,
    vote_side = params.vote_side,
    on_vote = function (self)
    end
  })
  return path
end
