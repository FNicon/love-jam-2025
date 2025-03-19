local votebox = require("src.gameplay.vote.votebox")
local votemanager = {}

function votemanager.retrieveallgoals(nodes)
  local newgoals = {}
    for _, node in ipairs(nodes) do
        if node.data.type == "goal" then
            table.insert(newgoals, node)
        end
    end
    return newgoals
end

function votemanager.retrieveallparticipants(nodes)
  local newparticipants = {}
   for _, node in ipairs(nodes) do
        if node.data.type ~= "goal" then
            table.insert(newparticipants, node)
        end
    end
    return newparticipants
end

local function handlewinner(votebox)
  local result = votebox:decideresult()
  votebox:resetvote()
  if result ~= "tie" then
    print(result)
    if result == "support" then
      table.insert(votebox.goal.data.goal.winners, "support")
    else
      table.insert(votebox.goal.data.goal.winners, "oppose")
    end
  else
      -- do something else here
  end
  votebox.goal.data.progress.current = #votebox.goal.data.goal.winners
  if votebox.goal.data.progress.current == votebox.goal.data.progress.max then
    votebox.goal.data.goal.state = "decided"
    local supportcount = 0
    local opposecount = 0
    for _, winner in ipairs(votebox.goal.data.goal.winners) do
      if (winner == "support") then
        supportcount = supportcount + 1
      else
        opposecount = opposecount + 1
      end
    end
    if supportcount > opposecount then
      votebox.goal.data.goal.winner = "support"
    elseif opposecount > supportcount then
      votebox.goal.data.goal.winner = "oppose"
    else
      votebox.goal.data.goal.winner = "tie"
    end
  end
end

function votemanager.new()
    local newVotemanager = {
        -- goals = {},
        voteboxes = {},
        decideresult = function(self, goal)
            for _, vb in ipairs(self.voteboxes) do
              if vb.goal == goal then
                  handlewinner(vb)
                  break
              end
            end
        end,
        decideallresult = function(self)
            for _, vb in ipairs(self.voteboxes) do
              handlewinner(vb)
            end
        end,
        addvotebox = function(self, goal)
          if goal~= nil then
            table.insert(self.voteboxes, votebox.new())
            self.voteboxes[#self.voteboxes].goal = goal
          end
        end,
        addvoteboxlist = function(self, goals)
          for _, goal in ipairs(goals) do
                self:addvotebox(goal)
            end
        end,
        startvote = function(self, participants)
          for _, vb in ipairs(self.voteboxes) do
              for _, participant in ipairs(participants) do
                if participant ~= nil then
                  participant.lambda.vote(vb)
                end
              end
            end
        end,
        endvote = function(self)
          self:decideallresult()
        end
    }
    return newVotemanager
end

return votemanager
