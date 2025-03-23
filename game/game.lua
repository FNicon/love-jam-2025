local ui = require("src.ui.ui")
local levelmanager = require("src.level.levelmanager")
local start_screen = require("src.ui.screens.start")
local completion_screen = require("src.ui.screens.completion")
local audio_manager = require("src.audio.audiomanager")

local app = {}
app.nodes = {}

function app.load()
  levelmanager.init()
  levelmanager.load(1)
  levelmanager.printlevel()
  audio_manager.load_bgm("dungeon", true)
  ui.init(start_screen(ui, levelmanager))
end

function app.draw()
  ui.draw()
end

function app.update(dt)
  if levelmanager.all_levels_completed() then
    ui.change_screen(completion_screen(ui, levelmanager))
  end
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
