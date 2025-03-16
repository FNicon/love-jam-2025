local graph = require('lib.graph')

local n1 = graph.node()
local n2 = graph.node()
local n3 = graph.node()
local n4 = graph.node()

n1:connect(n2)
n1:connect(n4)
n2:connect(n3)

graph.traverse{n1, onVisit = function(node)
    print(node.id)
  end
}

print(n1:isneighbor(n2)) -- true
print(n1:isneighbor(n3)) -- false
print(n1:isconnected(n3)) -- true
