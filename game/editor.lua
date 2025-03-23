local levelmanager = require("src.level.levelmanager")
local ui           = require("src.ui.ui")
local editor_screen = require("src.ui.screens.editor")

local app = {}

function app.load(args)
  local level_file = args[2]
  assert(level_file ~= nil, 'usage: love . --editor [path to level file]')
  levelmanager.init()
  ui.init(editor_screen(ui, levelmanager, level_file))
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

function app.mousepressed(x, y, button, istouch, presses)
  ui.mousepressed(x, y, button, istouch, presses)
end

function app.mousemoved(x, y)
  ui.mousemoved(x, y)
end

function app.mousereleased(x, y, button, istouch, presses)
  ui.mousereleased(x, y, button, istouch, presses)
end

function app.wheelmoved(x, y)
  ui.wheelmoved(x, y)
end

function app.touchpressed(id, x, y, dx, dy, pressure)
end

return app

