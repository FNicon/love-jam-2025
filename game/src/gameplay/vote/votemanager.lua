local nodedata = require("src.gameplay.nodedata")
local votetype = require("src.gameplay.vote.votetype")
local goalstate= require("src.gameplay.goal.goalstate")

local votemanager = {}

function votemanager.is_goal(node)
  return node.data:hasComponent(nodedata.components.progressable)
end

function votemanager.is_required_goal(node)
  local progress = node.data:getComponent(nodedata.components.progressable)
  return progress ~= nil and progress.required == true
end

function votemanager.is_heart(node)
  return node.data.type == "heart"
end

function votemanager.is_participant(node)
  return node.data:hasComponent(nodedata.components.voter)
end

function votemanager.new(levelmanager)
  return {
    levelmanager = levelmanager,
    handle_vote_result = function (self, goal)
      local progress = goal.data:getComponent(nodedata.components.progressable)
      local votebox = progress.votebox
      local result = votebox:decideresult()
      if not votebox:isdraw() then
        progress.votes[result].count = progress.votes[result].count + 1
        progress:on_progress()
      end
      votebox:resetvote()

      local support_count = progress.votes[votetype.support.label].count
      local oppose_count = progress.votes[votetype.oppose.label].count
      local total_count = support_count + oppose_count
      local winner = nil
      if total_count >= progress.quota then
        if support_count > oppose_count then
          progress.goal_state = goalstate.completed
          winner = votetype.support.label
        elseif support_count == oppose_count then
          -- tie counts as failed
          progress.goal_state = goalstate.failed
        else
          winner = votetype.oppose.label
          progress.goal_state = goalstate.failed
        end
        progress:on_complete(self.levelmanager, winner)
      end
    end,
    decideallresult = function(self)
      local goals = self.levelmanager.get_nodes_filtered(votemanager.is_goal)
      for _, goal in ipairs(goals) do
        self:handle_vote_result(goal)
      end
    end,
    poll = function(self)
      local participants = self.levelmanager.get_nodes_filtered(votemanager.is_participant)
      for _, participant in ipairs(participants) do
        local goal_neighbors = {}
        for _, neighbor in ipairs(participant.neighbors) do
          if votemanager.is_goal(neighbor) then
            table.insert(goal_neighbors, neighbor)
          end
        end
        for _, goal in ipairs(goal_neighbors) do
          local voter = participant.data:getComponent(nodedata.components.voter)
          local progress = goal.data:getComponent(nodedata.components.progressable)
          voter:vote(progress.votebox, goal)
        end
      end
      self:decideallresult()
    end
  }
end

return votemanager
