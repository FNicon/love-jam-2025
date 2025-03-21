local node = require("src.gameplay.nodeobj.node")
local relay = require("src.gameplay.relay.relay")
local nodeobj = require("src.gameplay.nodeobj.node")

local relaynode = {}

local countweight = function(length, maxlength)
  if (length == nil or length == 0 or length > maxlength) then
    return 0
  else
    -- The longer the line, the lower the weight
    return math.floor(maxlength / length)
  end
end

local function on_connect(goal)
  print(goal.data.on_connect)
  if (goal.data.on_connect ~= nil) then
    for _, to_connect in ipairs(goal.data.on_connect) do
      local func_name = to_connect.func
      local args = to_connect.args
      args.src = goal
      local result = nodeobj.connect_functions[func_name](args)
      -- print(result.data.icon)
    end
  end
end

local function on_vote(goal)
  if (goal.data.on_vote ~= nil) then
    for _, to_connect in ipairs(goal.data.on_vote) do
      local func_name = to_connect.func
      local args = to_connect.args
      args.src = goal
      local result = nodeobj.vote_functions[func_name](args)
      -- print(result.data.icon)
    end
  end
end

function relaynode.new(data)
  local newchara = relay.new(data.label)
  local newnode = node.new(data.x, data.y, data.icon, data.label)
  newnode.data.type = "relay"
  newnode.data.active = data.active
  newnode.data.relay = newchara
  newnode.data.maxlength = data.maxlength

  local lambda = {
    pick_side = function(newgoalnode, side, length)
      local weight = countweight(length, newnode.data.maxlength)
      if (newnode:isneighbor(newgoalnode)) then
        newnode:update_edge(newgoalnode, weight, side)
      else
        newnode:connect(newgoalnode, weight, side)
        on_connect(newgoalnode)
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
          on_vote(votebox.goal)
        end
      end
    end
  }

  newnode.lambda = lambda
  return newnode
end


return relaynode
