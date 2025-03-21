return function(color)
  return {
    color = color,
    draw = function (self, ui)
      love.graphics.clear(self.color)
    end
  }
end
