local node_data = require("src.gameplay.nodedata.base")
local components = require("src.gameplay.nodedata.components")
local icons      = require("assets.icons")
local voter = require("src.gameplay.nodedata.components.voter")
local votetypes = require("src.gameplay.vote.votetype")

-- taken from prisoner but relaying the opposite of what's received
local type_name = "manipulator"

return function (owner, params)
  local manipulator = node_data(type_name, owner, params.x, params.y)
  manipulator:addComponent(components.controllable, false)
  manipulator:addComponent(components.display, {
    icon = icons.prisoner_1,
    label = params.label or type_name,
  })
  manipulator:addComponent(components.connectable, {
    on_connected = function(self, source_edge)
      local node_data = self.owner
      local node = node_data.owner
      local voter = node_data:getComponent(voter)

      local source_side = source_edge.label

      local new_vote_side = source_side
      for _, side in pairs(votetypes) do
        if (source_side ~= side.label and side.progress) then
          new_vote_side = side.label
          break
        end
      end
      voter.vote_side = new_vote_side
      local _node_data = owner
      local _controllable = _node_data.data:getComponent(components.controllable)
      _controllable.enabled = true
    end
  })
  manipulator:addComponent(components.voter, {
    max_length = 1,
    vote_side = params.vote_side,
    on_vote = function (self)
    end
  })
  return manipulator
end
