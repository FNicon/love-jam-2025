local goalnode = require('src.gameplay.goal.goalnode')
local characternode = require('src.gameplay.character.characternode')
local graph = require('lib.graph')

local function testsupport()
  local g1 = goalnode.new(graph,"n1")
  local g2 = goalnode.new(graph, "n2")
  local p1 = characternode.new(graph, "p1")
  local p2 = characternode.new(graph, "p2")

  p1:support(g1)
  p2:oppose(g2)
  p1:oppose(g2)
  p2:support(g1)
end

testsupport()
