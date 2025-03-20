
local distancecalculator = {}

function distancecalculator.manhattan(x1, y1, x2, y2)
  return math.abs(x1 - x2) + math.abs(y1 - y2)
end

return distancecalculator
