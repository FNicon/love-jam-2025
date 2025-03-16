local graph = require('lib.graph')

local n1 = graph.node()
local n2 = graph.node()

n1:connect(n2)

graph.traverse{n1, onVisit = function(node)
    print(node.id)
  end
}
