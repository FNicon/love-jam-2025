local goal = require("src.gameplay.goal.goal")
local goalnode = {}

function goalnode.new(graph, goaldata)
  local newgoal = goal.new(goaldata.name)
  local node = graph.node({
      type = "goal",
      data = newgoal,
  })
  local nodeobj = {
    node = node,
    goal = newgoal,
  }
  return nodeobj
end

return goalnode
