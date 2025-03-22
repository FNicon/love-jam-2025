local levelmanager = require("src.level.levelmanager")
local ui           = require("src.ui.ui")
local editor_screen = require("src.ui.screens.editor")

local app = {}

function app.load()
  levelmanager.init()
  ui.init(editor_screen(ui, levelmanager))
end

function app.draw()
  ui.draw()
end

function app.update(dt)
  ui.update(dt)
end

function app.keypressed(key)
  ui.keypressed(key)
end

function app.mousepressed(x, y, istouch, presses)
  ui.mousepressed(x, y)
end

function app.mousemoved(x, y)
  ui.mousemoved(x, y)
end

function app.mousereleased(x, y)
  ui.mousereleased(x, y)
end

function app.touchpressed(id, x, y, dx, dy, pressure)
end

return app

