return function (label, icon_up, icon_down, x, y, onClick)
  return {
    pressed = false,
    x = x,
    y = y,
    label = label,
    icon_up = icon_up,
    icon_down = icon_down,
    onClick = onClick,
    isUnder = function (self, x, y)
      return math.abs(x - self.x) < math.floor(self.icon_up:getWidth()/2)
        and math.abs(y - self.y) < math.floor(self.icon_up:getHeight()/2)
    end,
    draw = function (self, ui)
      local icon
      if self.pressed then
        icon = self.icon_down
      else
        icon = self.icon_up
      end
      love.graphics.draw(
        icon,
        self.x - math.floor(icon:getWidth() / 2),
        self.y - math.floor(icon:getHeight() / 2)
      )
      love.graphics.print(
        self.label,
        self.x - math.floor(ui.font:getWidth(self.label)/2),
        self.y + math.ceil(icon:getHeight() * .8)
      )
    end,
    mousepressed = function (self, x, y)
      if self:isUnder(x, y) then
        self.pressed = true
      else
        self.pressed = false
      end
    end,
    mousereleased = function (self, x, y)
      if self.pressed then
        self.onClick()
      end
      self.pressed = false
    end
  }
end
