local goal = {}

function goal.new(name)
    local newGoal = {
      name = name,
      state = "pending"
    }
    return newGoal
end

return goal
