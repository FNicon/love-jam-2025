local widgets = require "src.ui.widgets"
local icons   = require "assets.icons"
local palette = require "assets.palette"
local game_screen = require "src.ui.screens.game"

return function (ui, levelmanager)
  return {
    widgets = {
      widgets.background(palette.blue[4]),
      widgets.title(
        'You Escaped!',
        (ui.getWorldWidth() - icons.path:getWidth())/2,
        (ui.getWorldHeight() - icons.path:getHeight())/2
      ),
    }
  }
end
