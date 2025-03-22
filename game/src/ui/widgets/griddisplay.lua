return function (width, height, tile_size)
  return {
    width = width,
    height = height,
    tile_size = tile_size,
    draw = function (self)
      for y = 0, height, 1 do
        for x = 0, width - 1, 1 do
          love.graphics.setLineWidth(2)
          local v = .3
          love.graphics.setColor({v, v, v, 1})
          love.graphics.rectangle(
           "line",
            x * tile_size,
            y * tile_size,
            tile_size,
            tile_size
          )
        end
      end
    end
  }
end
