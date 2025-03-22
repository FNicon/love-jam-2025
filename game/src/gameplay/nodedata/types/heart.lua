local node_data = require("src.gameplay.nodedata.base")
local components = require("src.gameplay.nodedata.components")
local icons      = require("assets.icons")
local audiomanager = require("src.audio.audiomanager")

local type_name = "heart"

return function (owner, params)
  local heart = node_data(type_name, owner, params.x, params.y)
  heart:addComponent(
    components.progressable,
    {
      quota = params.quota,
      required = params.required,
      on_connect = function (self)
        audiomanager.play_sfx("connect")
      end,
      on_progress = function (self)
        audiomanager.play_sfx("progress")
      end,
      on_complete = function (self, levelmanager)
        audiomanager.play_sfx("door")
        local player = levelmanager.get_nodes_filtered(function (node)
          return node.data.type == "player"
        end)[1]
        player.data:getComponent(components.controllable).enabled = false
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
