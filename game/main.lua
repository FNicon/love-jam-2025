local ui = require("src.ui.ui")
local overlayStats = require("lib.overlayStats")
local graph = require("src.data.graph")
local palette = require("assets.palette")
local icons = require("assets.icons")
local levelmanager = require("src.level.levelmanager")

local root
local nodes = {}

function love.load()
  levelmanager.init(nodes)
  levelmanager.load(1)
  levelmanager.printlevel()
  ui.init(levelmanager)
  print(ui:getWorldWidth(), ui:getWorldHeight())
  overlayStats.load() -- Should always be called last
end

function love.draw()
  ui.draw()
  overlayStats.draw() -- Should always be called last
end

function love.update(dt)
  overlayStats.update(dt) -- Should always be called last
end

function love.keypressed(key)
  if key == "escape" and love.system.getOS() ~= "Web" then
    love.event.quit()
  else
    overlayStats.handleKeyboard(key) -- Should always be called last
  end
end

function love.mousepressed(x, y, istouch, presses)
  ui.mousepressed(x, y)
end

function love.mousemoved(x, y)
  ui.mousemoved(x, y)
end

function love.mousereleased(x, y)
  ui.mousereleased(x, y)
end

function love.touchpressed(id, x, y, dx, dy, pressure)
  overlayStats.handleTouch(id, x, y, dx, dy, pressure) -- Should always be called last
end
