local goal = {}

function goal.new(name, icon)
    local newGoal = {
      name = name,
      state = "pending",
      icon = icon
    }
    return newGoal
end

return goal
