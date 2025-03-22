local node_data = require("src.gameplay.nodedata.base")
local components = require("src.gameplay.nodedata.components")

local type_name = "relay"

return function (owner, params)
  local relay = node_data(type_name, owner, params.x, params.y)
  relay:addComponent(components.voter, {
    on_vote = function ()
    end
  })
  relay:addComponent(components.controllable)
  return relay
end
