local nodedata = require("src.gameplay.nodedata")

return function(nodeplacer, x, y)
  local dummy_nodes = {}
  local i = 0
  for _, data_type in pairs(nodedata.types) do
    local dummy = data_type({}, {x = x + i * 60, y = y})
    if dummy:hasComponent(nodedata.components.display) then
      table.insert(dummy_nodes, dummy)
      i = i + 1
    end
  end
  return {
    dummy_nodes = dummy_nodes,
    nodeplacer = nodeplacer,
    draw = function (self, ui)
      for _, node in ipairs(dummy_nodes) do
        local display_component = node:getComponent(nodedata.components.display)
        love.graphics.setColor({1, 1, 1, 1})
        love.graphics.setFont(ui.font.default)
        love.graphics.draw(display_component.icon, node.x, node.y)
        love.graphics.print(display_component.label, node.x, node.y + 20)
      end
    end,
    mousepressed = function(self, x, y, button)
      if self.nodeplacer.mouse_attached_node == nil and button == 1 then
        for _, node in ipairs(dummy_nodes) do
          if x > node.x and x < node.x + 30 and y > node.y and y < node.y + 45 then
            local data_type = nodedata.types[node.type]
            local node_to_place = data_type({}, {x = x, y = y})
            self.nodeplacer:add_node(node_to_place)
            self.nodeplacer.mouse_attached_node = node_to_place
          end
        end
      end
    end
  }
end
