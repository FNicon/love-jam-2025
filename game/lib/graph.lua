local graph = {}

local id_counter = 0

local function visitedSet ()
  return {
    list = {},
    add = function(self, id)
      self.list[id] = true
    end,
    contains = function(self, id)
      return self.list[id] == true
    end
  }
end

function graph.node(data)
  id_counter = id_counter + 1
  local n = {
    id = id_counter,
    data = data,
    neighbors = {},
    connect = function(self, neighbor)
      table.insert(self.neighbors, neighbor)
    end,
    disconnect = function(self, neighbor)
      table.remove(self.neighbors, neighbor)
    end,
    isneighbor = function(self, node)
      if self.neighbors == {} then
        return false
      end
      for _, neighbor in ipairs(self.neighbors) do
        if neighbor.id == node.id then
          return true
        end
      end
      return false
    end,
    isconnected = function(self, nodetocheck)
      if self.isneighbor(self, nodetocheck) then
        return true
      end
      local found = false
      graph.traverse{self, onVisit = function(node)
        if node.id == nodetocheck.id then
          found = true
        end
      end}
      return found
    end
  }
  return n
end

function graph.edge(n1, n2)
  return {n1 = n1, n2 = n2}
end

function graph.traverse(t)
  local next = {}
  setmetatable(t, {__index={visited=visitedSet(), edges={}}})
  local n, visited = t[1], t[2] or t.visited
  visited:add(n)
  if t.onVisit ~= nil then
    t.onVisit(n)
  end
  for _, neighbor in ipairs(n.neighbors) do
    if not visited:contains(neighbor) then
      graph.traverse{neighbor, visited, onVisit = t.onVisit}
    end
  end
end

function graph.draw(root)
  graph.traverse{root, onVisit = function (node)
    love.graphics.circle("line", node.data.x, node.data.y, 25)
  end}
end

return graph
