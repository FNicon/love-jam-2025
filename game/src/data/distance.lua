local distancecalculator = {}

function distancecalculator.manhattan(x1, y1, x2, y2)
  return math.abs(x1 - x2) + math.abs(y1 - y2)
end

-- only get grid radial distance
function distancecalculator.manhattan_simplified(x1, y1, x2, y2)
  return math.max(math.abs(x1 - x2), math.abs(y1 - y2))
end

function distancecalculator.worldToGridDistance(grid, worldx1, worldy1, worldx2, worldy2)
  local gridx1, gridy1 = grid:worldToGridCoords(worldx1, worldy1)
  local gridx2, gridy2 = grid:worldToGridCoords(worldx2, worldy2)
  return distancecalculator.manhattan_simplified(gridx1, gridy1, gridx2, gridy2)
end

-- provide x and y offsets and return clamped offsets based on grid
function distancecalculator.clampWorldToGridDistance(grid, griddistance, worldxoff, worldyoff)
  -- clamped to rectangluar grid coords
  return math.clamp(worldxoff, grid.tile_size * -griddistance, grid.tile_size * griddistance),
          math.clamp(worldyoff, grid.tile_size * -griddistance, grid.tile_size * griddistance)
end

return distancecalculator
