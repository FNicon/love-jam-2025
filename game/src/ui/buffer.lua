return {
  init = function (self, width, height, pixel_scale)
    self.canvas = love.graphics.newCanvas(width, height)
    self.pixel_scale = pixel_scale
  end,
  drawOn = function (self, draw)
    love.graphics.setCanvas(self.canvas)
    draw()
    love.graphics.setCanvas()
  end,
  draw = function (self)
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(self.canvas, 0, 0, 0, self.pixel_scale, self.pixel_scale)
  end
}
