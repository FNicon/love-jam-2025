local character = require("src.gameplay.character.character")
local characternode = {}

function characternode.new(graph, charadata)
  local newchara = character.new(charadata.name)
  local node = graph.node({
    type = "character",
    data = newchara,
  })
  local nodeobj = {
    node = node,
    character = newchara,
    support = function(self, newgoal)
      if (self.node:isneighbor(newgoal.node)) then
        local current_weight = self.node:getedge(newgoal.node).weight
        if (current_weight < 0) then
          self.node:getedge(newgoal.node).weight = self.node:getedge(newgoal.node).weight * -1
        end
      else
        self.node:connect(newgoal.node)
      end
    end,
    oppose = function(self, newgoal)
      if (self.node:isneighbor(newgoal.node)) then
        local current_weight = self.node:getedge(newgoal.node).weight
        if (current_weight > 0) then
          self.node:getedge(newgoal.node).weight = self.node:getedge(newgoal.node).weight * -1
        end
      else
        self.node:connect(newgoal.node, -1)
      end
    end,
    abstain = function(self, newgoal)
      self.node:disconnect(newgoal.node)
    end,
    vote = function(self, votebox)
      if (votebox.goal == nil or votebox.goal == {}) then
        votebox.goal = {}
      else
        if (self.node:isneighbor(votebox.goal.node)) then
          local current_weight = self.node:getedge(votebox.goal.node).weight
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
  return nodeobj
end


return characternode
