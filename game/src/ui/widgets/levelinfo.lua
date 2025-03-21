return function (levelmanager, font, x, y)
  return {
    levelmanager = levelmanager,
    x = x,
    y = y,
    font = font,
    draw = function (self, ui)
      love.graphics.setFont(ui.font)
      love.graphics.print(
        self.levelmanager.currentlevelname,
        self.x - ui.font:getWidth(self.levelmanager.currentlevelname) / 2,
        self.y
      )
    end
  }
end
