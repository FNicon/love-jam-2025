local node_data = require("src.gameplay.nodedata.base")
local components = require("src.gameplay.nodedata.components")
local icons      = require("assets.icons")
local sfxplayer  = require("src.audio.sfxplayer")
local audiomanager = require("src.audio.audiomanager")

local type_name = "door"

return function (owner, params)
  local door = node_data(type_name, owner, params.x, params.y)
  door:addComponent(
    components.progressable,
    {
      quota = params.quota,
      required = params.required,
      on_connect = function (self)
        audiomanager.play_sfx("connect")
      end,
      on_progress = function (self)
        audiomanager.play_sfx("progress")
      end,
      on_complete = function (self)
        audiomanager.play_sfx("door")
      end
    }
  )
  door:addComponent(
    components.display,
    {
      icon = icons.door,
      label = params.label or type_name
    }
  )
  return door
end
