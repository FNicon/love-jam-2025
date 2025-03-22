local node_data = require("src.gameplay.nodedata.base")
local components = require("src.gameplay.nodedata.components")
local icons      = require("assets.icons")

local type_name = "door"

return function (owner, params)
  local door = node_data(type_name, owner, params.x, params.y)
  door:addComponent(
    components.progressable,
    {
      quota = params.quota,
      required = params.required,
      on_progress = function ()
      end,
      on_complete = function ()
      end
    }
  )
  door:addComponent(
    components.display,
    {
      icon = icons.door,
      label = params.label or type_name
    }
  )
  return door
end
