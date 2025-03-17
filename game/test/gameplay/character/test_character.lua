local goalnode = require('src.gameplay.goal.goalnode')
local characternode = require('src.gameplay.character.characternode')

local function testsupport()
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

  p1.lambda.support(g1)
  p2.lambda.oppose(g2)
  p1.lambda.oppose(g2)
  p2.lambda.support(g1)
end

testsupport()
