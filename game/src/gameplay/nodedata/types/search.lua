local node_data = require("src.gameplay.nodedata.base")
local components = require("src.gameplay.nodedata.components")
local icons      = require("assets.icons")

local type_name = "search"

return function (owner, params)
  local search = node_data(type_name, owner, params.x, params.y)
  search:addComponent(
    components.progressable,
    {
      quota = params.quota,
      on_progress = function (self)
      end,
      on_complete = function (self, levelmanager)
        local node_data = self.owner
        levelmanager.create_node({
          type = "path",
          x = node_data.x,
          y = node_data.y,
          vote_side = "support"
        })
        levelmanager.remove_node(node_data.owner)
      end
    }
  )
  search:addComponent(
    components.display,
    {
      icon = icons.search,
      label = params.label or type_name
    }
  )
  return search
end
