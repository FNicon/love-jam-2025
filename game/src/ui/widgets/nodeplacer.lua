local nodedata = require("src.gameplay.nodedata")

return function(grid)
  return {
    nodes = {},
    connections = {},
    connect = {},
    grid = grid,
    type_counts = {},
    add_node = function (self, node)
      if self.type_counts[node.type] == nil then
        self.type_counts[node.type] = 1
      else
        self.type_counts[node.type] = self.type_counts[node.type] + 1
      end
      if node.id == nil then
        node.id = string.format('%s_%s', node.type, self.type_counts[node.type])
      end
      table.insert(self.nodes, node)
    end,
    add_connection = function(self, node, target)
      if self.connections[node] == nil then
        self.connections[node] = {}
        self.connections[node].nodes = {}
        table.insert(self.connections[node].nodes, target)
        print(target)
        print(#self.connections[node].nodes)
      else
        table.insert(self.connections[node].nodes, target)
        print(target)
        print(#self.connections[node].nodes)
      end
    end,
    draw = function (self, ui)
      love.graphics.setColor({1, 1, 1, 1})
      for node, node_info in pairs(self.connections) do
        -- print(node.id)
        for _, target in ipairs(node_info.nodes) do
          -- print(target.id)
          love.graphics.line(node.x, node.y, target.x, target.y)
        end
      end
      if self.connect.start ~= nil then
          love.graphics.line(self.connect.start.x, self.connect.start.y, self.connect.target.x, self.connect.target.y)
      end
      for _, node in ipairs(self.nodes) do
        local display_component = node:getComponent(nodedata.components.display)
        love.graphics.setColor({1, 1, 1, 1})
        love.graphics.setFont(ui.font.default)
        love.graphics.draw(display_component.icon, node.x - display_component.icon:getWidth()/2, node.y - display_component.icon:getHeight()/2)
        love.graphics.print(display_component.label, node.x - ui.font.default:getWidth(display_component.label), node.y + 20)
      end
    end,
    mousepressed = function(self, x, y, button)
      for i, node in ipairs(self.nodes) do
        local mouse_grid_x, mouse_grid_y = grid:worldToGridCoords(x, y)
        local node_grid_x, node_grid_y = grid:worldToGridCoords(node.x, node.y)
        if mouse_grid_x == node_grid_x and mouse_grid_y == node_grid_y then
          if self.connect.start == nil and self.mouse_attached_node == nil then
            if button == 1 then
              self.mouse_attached_node = node
            elseif button == 2 then
              -- todo: remove connections
              table.remove(self.nodes, i)
            elseif button == 3 then
              self.connect.start = node
              self.connect.target = {x = x, y = y}
            end
          end
          break
        end
      end
    end,
    mousemoved = function (self, x, y)
      if self.mouse_attached_node ~= nil then
        self.mouse_attached_node.x = x
        self.mouse_attached_node.y = y
      end
      if self.connect.start ~= nil then
        self.connect.target = {x = x, y = y}
        for _, node in ipairs(self.nodes) do
          local mouse_grid_x, mouse_grid_y = grid:worldToGridCoords(x, y)
          local node_grid_x, node_grid_y = grid:worldToGridCoords(node.x, node.y)
          if mouse_grid_x == node_grid_x and mouse_grid_y == node_grid_y then
            self.connect.target = node
            break
          end
        end
      end
    end,
    mousereleased = function (self, x, y)
      if self.mouse_attached_node ~= nil then
        local place_x, place_y = grid:gridToWorldCoords(grid:worldToGridCoords(x, y))
        self.mouse_attached_node.x = place_x
        self.mouse_attached_node.y = place_y
        self.mouse_attached_node = nil
      elseif self.connect.start ~= nil then
        if self.connect.target.type ~= nil then
          self:add_connection(self.connect.start, self.connect.target)
        end
        self.connect.start = nil
      end
    end
  }
end
