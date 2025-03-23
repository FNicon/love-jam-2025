-- adds globals from batteries lib, accessible to all files
-- https://github.com/1bardesign/batteries?tab=readme-ov-file#export-globals
require("lib.batteries"):export()

local overlayStats = require("lib.overlayStats")

local app
function love.load(args)
  if args[1] == '--editor' then
    app = require("editor")
  else
    app = require("game")
  end
  app.load(args)
  overlayStats.load() -- Should always be called last
end

function love.draw()
  app.draw()
  overlayStats.draw() -- Should always be called last
end

function love.update(dt)
  app.update(dt)
  overlayStats.update(dt) -- Should always be called last
end

function love.keypressed(key)
  if key == "escape" and love.system.getOS() ~= "Web" then
    love.event.quit()
  else
    overlayStats.handleKeyboard(key) -- Should always be called last
  end
  app.keypressed(key)
end

function love.mousepressed(x, y, button, istouch, presses)
  app.mousepressed(x, y, button, istouch, presses)
end

function love.mousemoved(x, y)
  app.mousemoved(x, y)
end

function love.mousereleased(x, y, button, istouch, presses)
  app.mousereleased(x, y)
end

function love.wheelmoved(x, y)
  app.wheelmoved(x, y)
end

function love.touchpressed(id, x, y, dx, dy, pressure)
  app.touchpressed(id, x, y, dx, dy, pressure)
  overlayStats.handleTouch(id, x, y, dx, dy, pressure) -- Should always be called last
end
