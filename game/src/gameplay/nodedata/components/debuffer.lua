local component = require("src.gameplay.nodedata.components.base")

local name = "debuffer"

local debuffer = {
  name = name,
  new = function (owner, params)
    local c = component.create(name, owner)
    c.levelmanager = params.levelmanager
    c.target = params.target
    c.on_aim = params.on_aim
    c.on_debuff_disable = params.on_debuff_disable
    return c
  end
}

return debuffer
