local component = require("src.gameplay.nodedata.components.base")

local name = "controllable"

local controllable = {
  name = name,
  new = function (owner, enabled)
    local c = component.create(name, owner)
    c.enabled = true
    if enabled ~= nil then
      c.enabled = enabled
    end
    return c
  end
}

return controllable
