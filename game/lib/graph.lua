local palette = require("lib.palette")

local graph = {}

local nodes = {}

local id_counter = 0

local function visitedSet ()
  return {
    list = {},
    add = function(self, node)
      self.list[node.id] = true
    end,
    contains = function(self, node)
      return self.list[node.id] == true
    end
  }
end

function graph.getallconnections(from)
  local neighbors = {}
  graph.traverse{from, onVisit = function (node)
    table.insert(neighbors, node)
  end}
  return neighbors
end

function graph.isconnected(from, to)
  local found = false
  graph.traverse{from, onVisit = function (node)
    if node.id == to.id then
      found = true
    end
  end}
  return found
end

function graph.deletenode(nodeid)
  for i, node in ipairs(nodes) do
    if node.id == nodeid then
      table.remove(nodes, i)
      break
    end
  end
end

function graph.node(data)
  id_counter = id_counter + 1
  local n = {
    id = id_counter,
    data = data,
    neighbors = {},
    edges = {},
    printneighbor = function(self)
      for i, node in ipairs(self.neighbors) do
        print("printing member ", i, node.id)
      end
    end,
    connect = function(self, neighbor, weight)
      local used_weight = 1
      if weight ~= nil then
        used_weight = weight
      end
      table.insert(self.edges, {
        from = self.id,
        to = neighbor.id,
        weight = used_weight
      })
      table.insert(self.neighbors, neighbor)
    end,
    disconnect = function(self, neighbor)
      for i, edge in ipairs(self.edges) do
        if (edge.from == self.id and edge.to == neighbor.id) then
          table.remove(self.edges, i)
          break
        end
      end
      for i, node in ipairs(self.neighbors) do
        if node.id == neighbor.id then
          table.remove(self.neighbors, i)
          break
        end
      end
    end,
    isneighbor = function(self, nodetocheck)
      if self.neighbors == {} then
        return false
      end
      local found = false
      for i, neighbor in ipairs(self.neighbors) do
        if neighbor.id == nodetocheck.id then
          found = true
        end
      end
      return found
    end,
    getedge = function(self, nodetocheck)
      if self:isneighbor(nodetocheck) then
        for _, edge in ipairs(self.edges) do
          if edge.to == nodetocheck.id then
            return edge
          end
        end
      end
    end,
    isconnected = function(self, nodetocheck)
      if self:isneighbor(nodetocheck) then
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
  table.insert(nodes, n)
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
  local visited = visitedSet()
  local radius = 15
  local edges = {}
  graph.traverse{root, onVisit = function (node)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(node.data.portrait, node.data.x - radius, node.data.y - radius)
    love.graphics.setColor(unpack(palette['orange'][3]))
    love.graphics.circle("line", node.data.x, node.data.y, radius)
    for _, neighbor in ipairs(node.neighbors) do
      if not visited:contains(neighbor) then
        table.insert(edges, graph.edge(node, neighbor))
      end
    end
  end}
  love.graphics.setColor(unpack(palette['orange'][3]))
  for _, edge in ipairs(edges) do
    local angle = math.atan2(
      edge.n2.data.y - edge.n1.data.y,
      edge.n2.data.x - edge.n1.data.x
    )
    local start_x, start_y =  edge.n1.data.x + math.cos(angle) * radius,
                              edge.n1.data.y + math.sin(angle) * radius
    local end_x, end_y =  edge.n2.data.x - math.cos(angle) * radius,
                          edge.n2.data.y - math.sin(angle) * radius
    love.graphics.line(start_x, start_y, end_x, end_y)
  end
end

return graph
