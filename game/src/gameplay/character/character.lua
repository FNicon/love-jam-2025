local graph = require('lib.graph')
local goal = require('src.gameplay.goal.goal')

local character = {}

function character.new(name)
  local newCharacter = {
    name = name,

    action = character.action,
    reaction = character.reaction,

  }
  return newCharacter
end

function character.action()
  -- Implement character action logic here
end

function character.reaction()
  -- Implement character reaction logic here
end

return character
