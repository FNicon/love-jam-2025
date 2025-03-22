return function (label, icon_up, icon_down, x, y, onClick, clickable_label)
  return {
    pressed = false,
    x = x,
    y = y,
    label = label,
    icon_up = icon_up,
    icon_down = icon_down,
    onClick = onClick,
    clickable_label = clickable_label,
    isUnder = function (self, x, y)
      local label_offset = 0
      if clickable_label then
        label_offset = math.ceil(icon_up:getHeight() * .8)
      end
      return math.abs(x - self.x) < math.floor(self.icon_up:getWidth()/2)
        and math.abs(y - self.y) < math.floor(self.icon_up:getHeight()/2 + label_offset)
    end,
    draw = function (self, ui)
      local icon
      if self.pressed then
        icon = self.icon_down
      else
        icon = self.icon_up
      end
      love.graphics.setFont(ui.font.default)
      love.graphics.draw(
        icon,
        self.x - math.floor(icon:getWidth() / 2),
        self.y - math.floor(icon:getHeight() / 2)
      )
      love.graphics.print(
        self.label,
        self.x - math.floor(ui.font.default:getWidth(self.label)/2),
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
