local component = require("src.gameplay.nodedata.components.base")

local name = "ai"

local ai = {
  name = name,
  new = function (owner, params)
    local c = component.create(name, owner)
    c.on_advance = params.on_advance
    return c
  end
}

return ai
