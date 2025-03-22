local components = require("src.gameplay.nodedata.components")

return function (type, owner, x, y)
  local d = {
    type = type,
    owner = owner,
    x = x,
    y = y,
    components = {}
  }

  owner.data = d

  function d:addComponent(component, params)
    self.components[component.name] = component.new(self, params)
  end

  function d:hasComponent(component)
    return self.components[component.name] ~= nil
  end

  function d:getComponent(component)
    return self.components[component.name]
  end

  return d
end
