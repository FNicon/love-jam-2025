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

print("> n1 is neighbor n2? ")
print(n1:isneighbor(n2)) -- true
print("> n1 is neighbor n3? ")
print(n1:isneighbor(n3)) -- false
print("> n1 is connected n3? ")
print(n1:isconnected(n3)) -- true

print("> n1 is connected n4? ")
print(n1:isconnected(n4)) -- true

print("> disconnecting n1 with n4")
n1:disconnect(n4)
print("> n1 is connected n4? ")
print(n1:isconnected(n4)) -- false
print("> n1 is neighbor n2?")
print(n1:isneighbor(n2)) -- true
print("get edge")
print(n1:getedge(n2).weight)

-- one way traverse graph check
print("> n2 is connected n1?")
print(n2:isconnected(n1)) -- false
