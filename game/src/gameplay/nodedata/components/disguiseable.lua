local component = require("src.gameplay.nodedata.components.base")

local name = "disguiseable"

local disguiseable = {
  name = name,
  new = function (owner, params)
    local c = component.create(name, owner)
    c.disguise_icon = params.disguise_icon
    c.real_icon = params.real_icon
    c.on_disguise = params.on_disguise
    c.on_detected = params.on_detected
    return c
  end
}

return disguiseable
