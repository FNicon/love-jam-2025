local component = require("src.gameplay.nodedata.components.base")

local name = "display"

local display = {
  name = name,
  new = function (owner, params)
    local c = component.create(name, owner)
    c.icon = params.icon
    c.label = params.label
    return c
  end
}

return display
