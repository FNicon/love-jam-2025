local palette = require "assets.palette"
return function (levelmanager, x, y)
  return {
    levelmanager = levelmanager,
    x = x,
    y = y,
    font = font,
    draw = function (self, ui)
      love.graphics.setFont(ui.font.title)
      love.graphics.setColor(palette.orange[4])
      love.graphics.print(
        self.levelmanager.currentlevelname,
        self.x - ui.font.title:getWidth(self.levelmanager.currentlevelname) / 2,
        self.y
      )
    end
  }
end
