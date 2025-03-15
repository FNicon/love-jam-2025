local overlayStats = require("lib.overlayStats")

function love.load()
  overlayStats.load() -- Should always be called last
end

function love.draw()
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

function love.touchpressed(id, x, y, dx, dy, pressure)
  overlayStats.handleTouch(id, x, y, dx, dy, pressure) -- Should always be called last
end
