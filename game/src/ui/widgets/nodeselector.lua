local nodedata = require("src.gameplay.nodedata")

return function(nodeplacer, x, y)
  local dummy_nodes = {}
  for _, data_type in pairs(nodedata.types) do
    local dummy = data_type({}, {})
    if dummy:hasComponent(nodedata.components.display) then
      table.insert(dummy_nodes, dummy)
    end
  end
  return {
    dummy_nodes = dummy_nodes,
    nodeplacer = nodeplacer,
    max_visible = 8,
    x = x,
    y = y,
    index_to_position = function(self, index)
      return self.x + (index - 1) * 60, self.y
    end,
    draw = function (self, ui)
      for i, node in ipairs(self.dummy_nodes) do
        local display_component = node:getComponent(nodedata.components.display)
        love.graphics.setColor({1, 1, 1, 1})
        love.graphics.setFont(ui.font.default)
        local x, y = self:index_to_position(i)
        love.graphics.draw(display_component.icon, x, y)
        love.graphics.print(display_component.label, x, y + 20)
        if i >= self.max_visible then break end
      end
    end,
    wheelmoved = function (self, x, y)
      if y > 0 then
        local node = table.remove(self.dummy_nodes, #self.dummy_nodes)
        table.insert(self.dummy_nodes, 1, node)
      elseif y < 0 then
        local node = table.remove(self.dummy_nodes, 1)
        table.insert(self.dummy_nodes, node)
      end
    end,
    mousepressed = function(self, x, y, button)
      if self.nodeplacer.mouse_attached_node == nil and button == 1 then
        for i, node in ipairs(self.dummy_nodes) do
          local node_x, node_y = self:index_to_position(i)
          if x > node_x and x < node_x + 30 and y > node_y and y < node_y + 45 then
            local data_type = nodedata.types[node.type]
            local node_to_place = data_type({}, {x = x, y = y})
            self.nodeplacer:add_node(node_to_place)
            self.nodeplacer.mouse_attached_node = node_to_place
          end
          if i >= self.max_visible then break end
        end
      end
    end
  }
end
