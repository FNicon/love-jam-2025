local component = require("src.gameplay.nodedata.components.base")

local name = "connectable"

local progressable = {
  name = name,
  new = function (owner, params)
    local c = component.create(name, owner)
    c.on_connected = params.on_connected
    return c
  end
}

return progressable
