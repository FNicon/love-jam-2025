
local distancecalculator = {}

function distancecalculator.manhattan(x1, y1, x2, y2)
  print("=============")
  print(x1, y1, x2, y2)
  print(math.abs(x1 - x2), math.abs(y1 - y2))
  return math.abs(x1 - x2) + math.abs(y1 - y2)
end

function distancecalculator.worldToGridDistance(grid, worldx1, worldy1, worldx2, worldy2)
  local gridx1, gridy1 = grid:worldToGridCoords(worldx1, worldy1)
  local gridx2, gridy2 = grid:worldToGridCoords(worldx2, worldy2)
  return distancecalculator.manhattan(gridx1, gridy1, gridx2, gridy2)
end

return distancecalculator
