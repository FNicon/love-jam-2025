local node_data = require("src.gameplay.nodedata.base")
local components = require("src.gameplay.nodedata.components")
local icons      = require("assets.icons")
local disguiseable = require("src.gameplay.nodedata.components.disguiseable")
local display = require("src.gameplay.nodedata.components.display")
local voter = require("src.gameplay.nodedata.components.voter")
local votetypes = require("src.gameplay.vote.votetype")

-- taken from path
local type_name = "fake"

return function (owner, params)
  local fake = node_data(type_name, owner, params.x, params.y)
  fake:addComponent(components.controllable)
  fake:addComponent(components.display, {
    icon = icons[params.disguise],
    label = params.label or type_name
  })
  fake:addComponent(components.voter, {
    max_length = 1,
    vote_side = params.vote_side,
    on_vote = function (self)
    end
  })
  fake:addComponent(components.disguiseable, {
    disguise_icon = params.disguise,
    on_disguise = function (self)
      local node_data = self.owner
      local node = node_data.owner
      local _display = node_data:getComponent(display)
      local _disguiseable = node_data:getComponent(display)
      _display.icon = _disguiseable.disguise_icon
    end,
    on_detected = function (self)
      local node_data = self.owner
      local node = node_data.owner
      local _display = node_data:getComponent(display)
      local _disguiseable = node_data:getComponent(display)
      _display.icon = icons.disguise
    end,
  })
  fake:addComponent(components.connectable, {
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

      local _disguiseable = node_data:getComponent(disguiseable)
      _disguiseable:on_detected()
    end
  })
  return fake
end
