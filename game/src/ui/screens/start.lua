local widgets = require "src.ui.widgets"
local icons   = require "assets.icons"
local palette = require "assets.palette"
local game_screen = require "src.ui.screens.game"
local audiomanager= require "src.audio.audiomanager"

return function (ui, levelmanager)
  return {
    widgets = {
      widgets.background(palette.blue[4]),
      widgets.title(
        'Placeholder Title',
        (ui.getWorldWidth() - icons.path:getWidth())/2,
        (ui.getWorldHeight() - icons.path:getHeight())/2 - 64
      ),
      widgets.button(
        'START',
        icons.path,
        icons.path,
        (ui.getWorldWidth() - icons.path:getWidth())/2,
        (ui.getWorldHeight() - icons.path:getHeight())/2,
        function ()
          audiomanager.play_sfx("door")
          ui.change_screen(game_screen(ui, levelmanager))
        end,
        true
      )
    }
  }
end
