local component = require("src.gameplay.nodedata.components.base")
local connect_response = require("src.gameplay.nodedata.components.connectresponse")
local progressable     = require("src.gameplay.nodedata.components.progressable")

local name = "voter"

local countweight = function(length, maxlength)
  if (length == nil or length == 0 or length > maxlength) then
    return 0
  else
    -- The longer the line, the lower the weight
    return math.floor(maxlength / length)
  end
end

local voter = {
  name = name,
  new = function (owner, params)
    local c = component.create(name, owner)
    c.vote_side = params.vote_side
    c.max_length = params.max_length
    c.on_vote = params.on_vote

    c.on_connect = function (self, connection_length, end_node)
      local weight = countweight(connection_length, self.max_length)
      local node_data = self.owner
      local node = node_data.owner
      if (node:isneighbor(end_node)) then
        node:update_edge(end_node, weight, self.vote_side)
      else
        node:connect(end_node, weight, self.vote_side)
        local progress = end_node.data:getComponent(progressable)
        if progress ~= nil then
          progress:on_connect()
        end
      end
      local cr = node_data:getComponent(connect_response)
      if cr ~= nil then
        cr:on_connect()
      end
    end

    c.on_disconnect = function (self, end_node)
      local node_data = self.owner
      local node = node_data.owner

      -- disconnect
      if (node:isneighbor(end_node)) then
        node:disconnect(end_node)
      end

      -- invoke on_disconnect
      local cr = node_data:getComponent(connect_response)
      if cr ~= nil  then
        cr:on_disconnect()
      end
    end

    c.vote = function (self, votebox, goal)
      local node_data = self.owner
      local node = node_data.owner
      local current_weight = 1
      local edge = node:getedge(goal)
      current_weight = edge.weight
      -- calculate chance to vote here based on current weight and other factors
      votebox:voteside(self.vote_side, current_weight)
      self:on_vote(votebox)
    end

    return c
  end
}

return voter
