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

function graph.node()
  id_counter = id_counter + 1
  local n = {
    id = id_counter,
    neighbors = {},
    connect = function(self, neighbor)
      table.insert(self.neighbors, neighbor)
    end,
    disconnect = function(self, neighbor)
      table.remove(self, neighbor)
    end
  }
  return n
end

function graph.traverse(t)
  local next = {}
  setmetatable(t, {__index={visited=visitedSet()}})
  local n, visited = t[1], t[2] or t.visited
  visited:add(n)
  if t.onVisit ~= nil then
    t.onVisit(n)
  end
  for _, neighbor in ipairs(n.neighbors) do
    if visited:contains(neighbor) then
      return
    else
      return graph.traverse{neighbor, visited, onVisit = t.onVisit}
    end
  end
end

return graph
