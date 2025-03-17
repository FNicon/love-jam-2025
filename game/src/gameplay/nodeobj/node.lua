local graph = require("lib.graph")

local node = {}

function node.new(x, y, icon, label)
  local newnode = graph.node{
    x = x,
    y = y,
    icon = icon,
    label = label,
  }
  return newnode
end

return node
