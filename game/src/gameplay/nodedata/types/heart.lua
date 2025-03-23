local node_data = require("src.gameplay.nodedata.base")
local components = require("src.gameplay.nodedata.components")
local icons      = require("assets.icons")
local audiomanager = require("src.audio.audiomanager")
local debuffer    = require("src.gameplay.nodedata.components.debuffer")
local distancecalculator = require("src.data.distance")
local voter = require("src.gameplay.nodedata.components.voter")
local controllable = require("src.gameplay.nodedata.components.controllable")
local display = require("src.gameplay.nodedata.components.display")

local type_name = "heart"

local function retrieveTargetNode(levelmanager, target)
  local target_node = levelmanager.get_nodes_filtered(function (node)
    return node.data:getComponent(display).label == target
  end)[1]
  return target_node
end

return function (owner, params)
  local heart = node_data(type_name, owner, params.x, params.y)
  heart:addComponent(components.voter, {
    max_length = 1,
    vote_side = "debuff",
    on_vote = function (self)
    end
  })
  heart:addComponent(
    components.debuffer,
    {
      grid = params.grid,
      target = params.target,
      on_aim = function (self, levelmanager, target)
        local target_node = retrieveTargetNode(levelmanager, target)

        -- connect to target
        local length = distancecalculator.worldToGridDistance(
          levelmanager.grid,
          self.data.x, self.data.y,
          target_node.data.x, target_node.data.y
        )
        print("connection distance ", length)
        local voter = self.data:getComponent(voter)
        voter:on_connect(length, target_node)

        -- set target
        local node_data = self.owner
        local node = node_data.owner
        local _debuffer = node_data:getComponent(debuffer)
        _debuffer.target = target_node.data:getComponent(display).label
      end,
      on_debuff_disable = function (self, levelmanager, target)
        local target_node = retrieveTargetNode(levelmanager, target)

        local node_target_data = target_node.data
        local _voter = node_target_data:getComponent(voter)
        for _, neighbor in ipairs(target_node.neighbors) do
          _voter:on_disconnect(neighbor)
        end
        -- disable node target control
        node_target_data:getComponent(components.controllable).enabled = false
      end,
    }
  )
  heart:addComponent(
    components.progressable,
    {
      quota = params.quota,
      required = params.required,
      on_connect = function (self)
        audiomanager.play_sfx("connect")
      end,
      on_progress = function (self)
        audiomanager.play_sfx("hurt")
      end,
      on_complete = function (self, levelmanager)
        audiomanager.play_sfx("death")

        local node_data = self.owner
        local node = node_data.owner
        local _debuffer = node_data:getComponent(debuffer)
        _debuffer:on_debuff_disable(levelmanager, _debuffer.target)
      end
    }
  )
  heart:addComponent(
    components.display,
    {
      icon = icons.heart,
      label = params.label or type_name
    }
  )
  return heart
end
