local node = require("src.gameplay.nodeobj.node")
local character = require("src.gameplay.character.character")
local characternode = {}

function characternode.new(data)
  local newchara = character.new(data.label)
  local newnode = node.new(data.x, data.y, data.icon, data.label)
  newnode.data.type = "character"
  newnode.data.active = data.active
  newnode.data.character = newchara

  local lambda = {
    support = function(newgoalnode)
      if (newnode:isneighbor(newgoalnode)) then
        local current_weight = newnode:getedge(newgoalnode).weight
        if (current_weight < 0) then
          newnode:getedge(newgoalnode).weight = newnode:getedge(newgoalnode).weight * -1
        end
      else
        newnode:connect(newgoalnode)
      end
    end,
    oppose = function(newgoalnode)
      if (newnode:isneighbor(newgoalnode)) then
        local current_weight = newnode:getedge(newgoalnode).weight
        if (current_weight > 0) then
          newnode:getedge(newgoalnode).weight = newnode:getedge(newgoalnode).weight * -1
        end
      else
        newnode:connect(newgoalnode, -1)
      end
    end,
    abstain = function(newgoalnode)
      newnode:disconnect(newgoalnode)
    end,
    vote = function(votebox)
      if (votebox.goal == nil or votebox.goal == {}) then
        votebox.goal = {}
      else
        if (newnode:isneighbor(votebox.goal)) then
          local current_weight = newnode:getedge(votebox.goal).weight
          -- calculate chance to vote here based on current weight and other factors
          if (current_weight > 0) then
            votebox.votesupport = votebox.votesupport + 1
          else
            votebox.voteoppose = votebox.voteoppose + 1
          end
        end
      end
    end
  }

  newnode.lambda = lambda
  return newnode
end


return characternode
