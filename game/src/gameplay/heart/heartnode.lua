local node = require("src.gameplay.nodeobj.node")
local heart = require("src.gameplay.heart.heart")

local heartnode = {}

-- data : x, y, label, icon, progress
function heartnode.new(data)
  local newheart = heart.new(data.label, data.icon)
  local newnode = node.new(data.x, data.y, data.icon, data.label)
  newnode.data.type = "heart"
  newnode.data.goal = newheart
  newnode.data.progress = data.progress
  newnode.data.maxlength = data.maxlength
  newnode.data.on_complete = data.on_complete
  newnode.data.on_connect = data.on_connect
  newnode.data.on_vote = data.on_vote
  newnode.data.char_owner = data.char_owner

  local lambda = {
  }
  newnode.data.lambda = lambda
  return newnode
end

return heartnode
