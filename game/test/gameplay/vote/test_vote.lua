local goalnode = require('src.gameplay.goal.goalnode')
local characternode = require('src.gameplay.character.characternode')
local votebox = require('src.gameplay.vote.votebox')

local function testvote()
  local g1 = goalnode.new{
    x = 0,
    y = 0,
    icon = {},
    label = 'find exit',
    progress = {max = 4, current = 0}
  }
  local g2 = goalnode.new{
    x = 1,
    y = 1,
    icon = {},
    label = 'find exit 2',
    progress = {max = 4, current = 0}
  }
  local p1 = characternode.new{
    x = 2,
    y = 2,
    icon = {},
    label = 'player1',
    active = true
  }
  local p2 = characternode.new{
    x = 3,
    y = 3,
    icon = {},
    label = 'player2',
    active = true
  }
  local p3 = characternode.new{
    x = 3,
    y = 3,
    icon = {},
    label = 'player3',
    active = true
  }

  local vb1 = votebox.new()
  local vb2 = votebox.new()

  vb1.goal = g1
  vb2.goal = g2

  p1.lambda.support(g1)
  p2.lambda.oppose(g1)

  p1.lambda.vote(vb1)
  p2.lambda.vote(vb1)


  local vb1res = vb1:decideresult()

  p1.lambda.oppose(g2)
  p2.lambda.oppose(g2)
  p3.lambda.support(g2)

  p1.lambda.vote(vb2)
  p2.lambda.vote(vb2)
  p3.lambda.vote(vb2)

  local vb2res = vb2:decideresult()

  print("vb1 result:", vb1res)
  print("vb2 result:", vb2res)

end

testvote()
