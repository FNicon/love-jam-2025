local levelmanager = require("src.level.levelmanager")
local palette      = require("assets.palette")
local ui           = require("src.ui.ui")

local app = {}

function app.load()
  levelmanager.init()
  ui.init(levelmanager)
end

function app.draw()
  love.graphics.clear(palette.blue[4])
  love.graphics.setLineWidth(8)
  local width, height = math.floor(ui.getWorldWidth() / levelmanager.grid.tile_size) - 1,
                        math.floor(ui.getWorldHeight() / levelmanager.grid.tile_size) - 1
  for y = 0, height, 1 do
    for x = 0, width, 1 do
      love.graphics.rectangle(
        "line",
        x * levelmanager.grid.tile_size,
        y * levelmanager.grid.tile_size,
        levelmanager.grid.tile_size,
        levelmanager.grid.tile_size
      )
    end
  end
end

function app.update(dt)
end

function app.keypressed(key)
end

function app.mousepressed(x, y, istouch, presses)
end

function app.mousemoved(x, y)
end

function app.mousereleased(x, y)
end

function app.touchpressed(id, x, y, dx, dy, pressure)
end

return app
