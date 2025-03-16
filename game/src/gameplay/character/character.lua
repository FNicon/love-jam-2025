local graph = require('lib.graph')
local goal = require('src.gameplay.goal.goal')

local character = {}

local function isnewgoal(character, goal)
  if character.support == nil or character.support == {} then
    return true
  end
  if character.oppose == nil or character.oppose == {} then
    return true
  end
  for _, opposinggoal in ipairs(character.oppose) do
    if opposinggoal.node.id == goal.node.id then
      return false
    end
  end
  for _, supportinggoal in ipairs(character.support) do
    if supportinggoal.node.id == goal.node.id then
      return false
    end
  end
  return true
end

local function findopposinggoal(character, goal)
  if character.oppose == nil or character.oppose == {} then
    character.oppose = {}
  end
  for _, opposinggoal in ipairs(character.oppose) do
    if opposinggoal.node.id == goal.node.id then
      return opposinggoal
    end
  end
end

local function findsupportinggoal(character, goal)
  if character.support == nil or character.support == {} then
    character.support = {}
  end
  for _, supportinggoal in ipairs(character.support) do
    print(supportinggoal)
    if supportinggoal.node.id == goal.node.id then
      return supportinggoal
    end
  end
end

function character.new(name)
  local newCharacter = {
    node = graph.node(),
    name = name,
    dosupport = function(self, newgoal)
      self.dropoppose(newgoal)
      local newsupportinggoal = findsupportinggoal(self, newgoal)
      if newsupportinggoal == nil then
        table.insert(self.support, newgoal.node)
        self.node:connect(newgoal.node)
      end
    end,
    dooppose = function(self, newgoal)
      self.dropsupport(newgoal)
      local newsupportinggoal = findsupportinggoal(self, newgoal)
      if newsupportinggoal == nil then
        table.insert(self.oppose, newgoal.node)
        self.node:connect(newgoal.node)
      end
    end,
    dropsupport = function(self, oldgoal)
      local oldsupportinggoal = findsupportinggoal(self, oldgoal)
      if oldsupportinggoal then
        table.remove(self.support, oldsupportinggoal)
        self.node:disconnect(oldsupportinggoal.node)
      end
    end,
    dropoppose = function(self, oldgoal)
      local oldopposinggoal = findopposinggoal(self, oldgoal)
      if oldopposinggoal then
        table.remove(self.oppose, oldopposinggoal)
        self.node:disconnect(oldopposinggoal.node)
      end
    end,
    support = {},
    oppose = {},
    dogoalvote = function(self, goalsubject)
      if isnewgoal(self, goalsubject) then
        return 0
      end
      local findopposinggoal = findopposinggoal(self, goalsubject)
      if findopposinggoal then
        return -1
      end
      local findsupportinggoal= findsupportinggoal(self, goalsubject)
      if findsupportinggoal then
        return 1
      end
    end,

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
