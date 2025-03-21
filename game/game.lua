local ui = require("src.ui.ui")
local levelmanager = require("src.level.levelmanager")
local screen = require("src.ui.screens.game")
local audio_manager = require("src.audio.audiomanager")

local nodes = {}

local app = {}
app.nodes = {}

function app.load()
  levelmanager.init(nodes)
  levelmanager.load(1)
  levelmanager.printlevel()
  audio_manager.load_bgm("dungeon", true)
  ui.init(screen(ui, levelmanager))
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
