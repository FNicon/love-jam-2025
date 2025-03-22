local node_data = require("src.gameplay.nodedata.base")
local components = require("src.gameplay.nodedata.components")
local icons      = require("assets.icons")

local type_name = "enemy"

return function (owner, params)
  local enemy = node_data(type_name, owner, params.x, params.y)
  enemy:addComponent(components.voter, {
    vote_side = "oppose",
    max_length = params.max_length,
    on_vote = function ()
    end
  })
  enemy:addComponent(components.ai, {
    on_advance = function (self, levelmanager)
      -- attempt to connect to a neighbor node in the direction of the goal
      -- for each node
      -- connect if distance <= maxlength and distance_to_goal is smallest
    end
  })
  enemy:addComponent(
    components.display,
    {
      icon = icons.enemy_1,
      label = params.label or type_name
    }
  )
  return enemy
end
