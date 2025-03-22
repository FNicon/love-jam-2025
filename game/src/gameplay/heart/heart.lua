local heart = {}

function heart.new(name, icon)
    local newHeart = {
      name = name,
      state = "pending",
      icon = icon,
      winners = {}
    }
    return newHeart
end

return heart
