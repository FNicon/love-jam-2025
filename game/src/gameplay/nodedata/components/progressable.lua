local component = require("src.gameplay.nodedata.components.base")
local goalstate = require("src.gameplay.goal.goalstate")
local votetype  = require("src.gameplay.vote.votetype")
local voteutils = require("src.gameplay.vote.voteutils")
local votebox   = require("src.gameplay.vote.votebox")

local name = "progressable"

local progressable = {
  name = name,
  new = function (owner, params)
    local c = component.create(name, owner)
    c.votebox = votebox.new()
    c.quota = params.quota
    c.votes = voteutils.initvotetypestorages()
    c.on_connect = params.on_connect
    c.on_progress = params.on_progress
    c.on_complete = params.on_complete
    c.required = params.required or false
    c.goal_state = goalstate.pending
    return c
  end
}

return progressable
