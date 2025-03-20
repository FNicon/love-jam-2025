local grid = {}

-- input as world coordinates
function grid.new(tile_size)

  local gridInstance = {
    tile_size = tile_size
  }

  function gridInstance.gridToWorldCoords(self, x, y)
    return x * self.tile_size, y * self.tile_size
  end

  function gridInstance.worldToGridCoords(self, x, y)
    return math.floor(x / self.tile_size), math.floor(y / self.tile_size)
  end

  function gridInstance.areAdjacent(self, worldx1, worldy1, worldx2, worldy2)
    local gridx1, gridy1 = self:worldToGridCoords(worldx1, worldy1)
    local gridx2, gridy2 = self:worldToGridCoords(worldx2, worldy2)
    local deltax, deltay = gridx2 - gridx1, gridy2 - gridy1
    return math.abs(deltax) <= 1 and math.abs(deltay) <= 1
  end

  return gridInstance
end

return grid
