local goal = {}

function goal.new(name, icon)
    local newGoal = {
      name = name,
      state = "pending",
      icon = icon,
      winners = {}
    }
    return newGoal
end

return goal
