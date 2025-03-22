local component = require("src.gameplay.nodedata.components.base")

local name = "connect_response"

local connect_response = {
  name = name,
  new = function (owner, params)
    local c = component.create(name, owner)
    c.on_connect = params.on_connect
    c.on_disconnect = params.on_disconnect
    return c
  end
}

return connect_response
