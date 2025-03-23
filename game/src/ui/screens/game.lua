local widgets = require "src.ui.widgets"
local icons   = require "assets.icons"
local palette = require "assets.palette"

return function (ui, levelmanager)
  return {
    widgets = {
      widgets.background(palette.blue[4]),
      widgets.graphdisplay(
        levelmanager
      ),
      widgets.levelinfo(
        levelmanager,
        ui.getWorldWidth() / 2,
        10
      ),
      widgets.button(
        'advance',
        icons.advance_button.up,
        icons.advance_button.down,
        ui.getWorldWidth() - 60,
        ui.getWorldHeight() - 60,
        function ()
          levelmanager.advance()
        end
      ),
      widgets.button(
        'reset',
        icons.reset_button.up,
        icons.reset_button.down,
        ui.getWorldWidth() - 120,
        ui.getWorldHeight() - 60,
        function ()
          levelmanager.restartlevel()
        end
      )
    }
  }
end
