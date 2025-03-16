local goal = require('src.gameplay.goal.goal')
local character = require('src.gameplay.character.character')
local graph = require('lib.graph')

local function testsupport()
  local g1 = goal.new("n1")
  local g2 = goal.new("n2")
  local p1 = character.new("p1")
  local p2 = character.new("p2")

  p1:dosupport(g1)
  p2:dosupport(g2)
  p1:dooppose(g2)
  p2:dooppose(g1)
  print(p1.support)
  print(p2.support)
  print(p1.opposes)
  print(p2.opposes)
end

testsupport()
