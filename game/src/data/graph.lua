local connectable = require("src.gameplay.nodedata.components.connectable")
local palette = require("assets.palette")

local graph = {}

local nodes = {}

local id_counter = 0

function graph.visitedSet ()
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
    connect = function(self, neighbor, weight, connectionlabel)
      local used_weight = 1
      if weight ~= nil then
        used_weight = weight
      end
      table.insert(self.edges, {
        from = self.id,
        to = neighbor.id,
        weight = used_weight,
        label = connectionlabel
      })
      print("connecting... ", self.id, " to ", neighbor.id, " with weight ", used_weight, " and label ", connectionlabel)
      table.insert(self.neighbors, neighbor)
      local _connectable = neighbor.data:getComponent(connectable)
      -- trigger on connected
      if _connectable ~= nil then
        local edge = self:getedge(neighbor)
        _connectable:on_connected(edge)
      end
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
    update_edge_label = function(self, nodetocheck, label)
      if self:isneighbor(nodetocheck) then
        for index, edge in ipairs(self.edges) do
          if edge.to == nodetocheck.id then
            edge.label = label
            edge.weight = edge.weight
            self.edges[index] = edge
            break
          end
        end
      end
    end,
    update_edge = function(self, nodetocheck, weight, label)
      if self:isneighbor(nodetocheck) then
        for index, edge in ipairs(self.edges) do
          if edge.to == nodetocheck.id then
            edge.weight = weight
            edge.label = label
            self.edges[index] = edge
            break
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
  setmetatable(t, {__index={visited=graph.visitedSet(), edges={}}})
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

return graph
