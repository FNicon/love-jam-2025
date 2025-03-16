local goalnode = require('src.gameplay.goal.goalnode')
local characternode = require('src.gameplay.character.characternode')
local votebox = require('src.gameplay.vote.votebox')

local graph = require('lib.graph')

local function testvote()
  local g1 = goalnode.new(graph,"n1")
  local g2 = goalnode.new(graph, "n2")
  local p1 = characternode.new(graph, "p1")
  local p2 = characternode.new(graph, "p2")
  local p3 = characternode.new(graph, "p3")

  local vb1 = votebox.new()
  local vb2 = votebox.new()

  vb1.goal = g1
  vb2.goal = g2

  p1:support(g1)
  p2:oppose(g1)

  p1:vote(vb1)
  p2:vote(vb1)


  local vb1res = vb1:decideresult()

  p1:oppose(g2)
  p2:oppose(g2)
  p3:support(g2)

  p1:vote(vb2)
  p2:vote(vb2)
  p3:vote(vb2)

  local vb2res = vb2:decideresult()

  print("vb1 result:", vb1res)
  print("vb2 result:", vb2res)

end

testvote()
