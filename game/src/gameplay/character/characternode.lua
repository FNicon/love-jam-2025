local node = require("src.gameplay.nodeobj.node")
local character = require("src.gameplay.character.character")

local characternode = {}

local countweight = function(length, maxlength)
  if (length == nil or length == 0 or length > maxlength) then
    return 0
  else
    -- The longer the line, the lower the weight
    return math.floor(maxlength / length)
  end
end

function characternode.new(data)
  local newchara = character.new(data.label)
  local newnode = node.new(data.x, data.y, data.icon, data.label)
  newnode.data.type = "character"
  newnode.data.active = data.active
  newnode.data.character = newchara
  newnode.data.maxlength = data.maxlength
  newnode.data.controllable = data.controllable

  local lambda = {
    change_side = function(side)
    end,
    pick_side = function(newgoalnode, side, length)
      local weight = countweight(length, newnode.data.maxlength)
      if (newnode:isneighbor(newgoalnode)) then
        newnode:update_edge(newgoalnode, weight, side)
      else
        newnode:connect(newgoalnode, weight, side)
      end
    end,
    abstain = function(newgoalnode)
      newnode:disconnect(newgoalnode)
    end,
    vote = function(votebox, votelabel)
      if (votebox.goal == nil or votebox.goal == {}) then
        votebox.goal = {}
      else
        if (newnode:isneighbor(votebox.goal)) then
          local current_weight = newnode:getedge(votebox.goal).weight
          -- calculate chance to vote here based on current weight and other factors
          votebox:voteside(votelabel, current_weight)
        end
      end
    end
  }

  newnode.lambda = lambda
  return newnode
end


return characternode
