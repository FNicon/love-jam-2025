local widgets = require "src.ui.widgets.init"
return function (ui, levelmanager)
  local tile_size = levelmanager.grid.tile_size
  local grid_width, grid_height = math.floor(ui.getWorldWidth() / tile_size),
    math.floor(ui.getWorldHeight() / tile_size)
  return {
    widgets = {
      widgets.griddisplay(grid_width, grid_height, tile_size)
    }
  }
end
