return function (text, x, y)
  return {
    x = x,
    y = y,
    text = text,
    draw = function (self, ui)
      love.graphics.setFont(ui.font.title)
      love.graphics.print(
        self.text,
        self.x - ui.font.title:getWidth(self.text) / 2,
        self.y
      )
    end
  }
end
