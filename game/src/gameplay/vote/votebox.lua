local voteutils = require("src.gameplay.vote.voteutils")

local votebox = {}

function votebox.new()
    local newVotebox = {
        participantcount = function(self)
          local count = 0
          for _, storage in pairs(self.votestorages) do
            count = count + storage.count
          end
          return count
        end,
        votestorages = {},
        drawstorages = {},
        voteside = function(self, side, weight)
          for _, storage in pairs(self.votestorages) do
            if (storage.progress and storage.label == side) then
              if (weight ~= nil and weight > 0) then
                storage.count = storage.count + 1 * weight
              end
              break
            end
          end
        end,
        definedraw = function(self)
          local useddraw = ""
          for _, storage in pairs(self.drawstorages) do
            useddraw = storage.label
            break
          end
          return useddraw
        end,
        countballots = function(self)
          local score = 0
          for _, storage in pairs(self.votestorages) do
            if (storage.progress and storage.count > score) then
              score = storage.count
            end
          end
          return score
        end,
        resetvote = function(self)
          self.votestorages = voteutils.initvotetypestorages()
          self.drawstorages = voteutils.initdrawstorages()
        end,
        getwinners = function(self)
          local maxscore = self:countballots()
          local winners = {}
          for _, storage in pairs(self.votestorages) do
            if (storage.progress and storage.count == maxscore) then
              table.insert(winners, storage.label)
            end
          end
          return winners
        end,
        decideresult = function(self)
          local winners = self:getwinners()
          if not self:isdraw() then
            return winners[1]
          else
            return self:definedraw()
          end
        end,
        isdraw = function(self)
          local winners = self:getwinners()
          return #winners ~= 1
        end,
    }
    newVotebox:resetvote()
    return newVotebox
end


return votebox
