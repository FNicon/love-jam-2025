local votetypes = require("src.gameplay.vote.votetype")

local voteutils = {}

function voteutils.initvotetypestorages()
  local newvotestorage = {}
  for _, votetype in pairs(votetypes) do
    if votetype.progress then
      newvotestorage[votetype.label] = {
        label = votetype.label,
        count = 0,
        color = votetype.color,
        progress = votetype.progress,
      }
    end
  end
  return newvotestorage
end

function voteutils.initdrawstorages()
  local newdrawstorage = {}
  for _, votetype in pairs(votetypes) do
    if not votetype.progress then
      newdrawstorage[votetype.label] = {
        label = votetype.label,
        count = 0,
        color = votetype.color,
        progress = false,
      }
    end
  end
  return newdrawstorage
end

return voteutils
