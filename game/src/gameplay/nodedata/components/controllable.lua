local component = require("src.gameplay.nodedata.components.base")

local name = "controllable"

local controllable = {
  name = name,
  new = function (owner)
    return component.create(name, owner)
  end
}

return controllable
