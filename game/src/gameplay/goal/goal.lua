local graph = require('lib.graph')
local goal = {}

function goal.new(name)
    local newGoal = {
      node = graph.node(),
      name = name
    }
    return newGoal
end

function goal.countvote(goal)
  local supportCount = 0
  local opposeCount = 0
  for _, character in ipairs(graph.nodes()) do
    if goal.votesupport(goal, character) then
      supportCount = supportCount + 1
    end
    if goal.voteoppose(goal, character) then
      opposeCount = opposeCount + 1
    end
  end
  return supportCount, opposeCount
end

function goal.score(goal)
  local supportCount, opposeCount = goal.countvote(goal)
  return (supportCount - opposeCount) / #graph.nodes()
end

return goal
