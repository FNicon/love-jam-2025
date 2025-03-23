local component = require("src.gameplay.nodedata.components.base")

local name = "controllable"

local controllable = {
  name = name,
  new = function (owner)
    local c = component.create(name, owner)
    c.enabled = true
    return c
  end
}

return controllable
