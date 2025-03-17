local ui = require("src.ui")
local overlayStats = require("lib.overlayStats")
local graph = require("lib.graph")
local palette = require("assets.palette")
local icons = require("assets.icons")

local root
local nodes = {}

function love.load()
  table.insert(nodes, graph.node{
    x = ui.buffer:getWidth() / 2 - 60,
    y = ui.buffer:getHeight() / 2,
    icon = icons.character[1],
    label = 'player',
    active = true
  })
  table.insert(nodes, graph.node{
    x = ui.buffer:getWidth() / 2 + 60,
    y = ui.buffer:getHeight() / 2,
    icon = icons.object.door,
    label = 'find exit',
    progress = {max = 4, current = 0}
  })
  overlayStats.load() -- Should always be called last
end

function love.draw()
  ui.draw(nodes)
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
  -- TODO: create screen to world coordinates function
  ui.tryStartConnectionDrag(nodes, x/4, y/4)
  if ui.connect == nil then
    if ui.advance_button:isUnder(x/4, y/4) then
      ui.advance_button.pressed = true
    end
  end
end

function love.mousemoved(x, y)
  if ui.connect ~= nil then
    ui.updateConnectionDragTarget(nodes, x/4, y/4)
  end
end

function love.mousereleased(x, y)
  ui.releaseConnectionDrag()
  if ui.advance_button.pressed then
    for _, node in ipairs(nodes) do
      if node.data.active == true then
        for _, neighbor in ipairs(node.neighbors) do
          if neighbor.data.progress ~= nil then
            neighbor.data.progress.current = neighbor.data.progress.current + 1
          end
        end
      end
    end
  end
  ui.advance_button.pressed = false
end

function love.touchpressed(id, x, y, dx, dy, pressure)
  overlayStats.handleTouch(id, x, y, dx, dy, pressure) -- Should always be called last
end
