local node_data = require("src.gameplay.nodedata.base")
local components = require("src.gameplay.nodedata.components")

-- taken from relay
local type_name = "sly"

return function (owner, params)
  local sly = node_data(type_name, owner, params.x, params.y)
  sly:addComponent(components.voter, {
    on_vote = function ()
    end
  })
  sly:addComponent(components.controllable)
  return sly
end
