local votebox = {}

function votebox.new()
    local newVotebox = {
        participantcount = function(self)
          return self.votesupport + self.voteoppose
        end,
        goal = {},
        votesupport = 0,
        voteoppose = 0,
        countballots = function(self)
          local score = self.votesupport - self.voteoppose
          return score
        end,
        issupportwin = function(self)
          local score = self:countballots()
          return (score > 0)
        end,
        isopposewin = function(self)
          local score = self:countballots()
          return (score < 0)
        end,
        decideresult = function(self)
          self.goal.goal.state = "decided"
          if self:issupportwin() then
            return "support"
          elseif self:isopposewin() then
            return "oppose"
          else
            return "tie"
          end
        end,
    }
    return newVotebox
end


return votebox
