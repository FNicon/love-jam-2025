local ui = require("src.ui")
local overlayStats = require("lib.overlayStats")
local graph = require("lib.graph")
local palette = require("assets.palette")
local icons = require("assets.icons")
local levelmanager = require("src.level.levelmanager")

local root
local nodes = {}

function love.load()
  levelmanager.init(nodes)
  levelmanager.load(1)
  levelmanager.printlevel()
  overlayStats.load() -- Should always be called last
end

function love.draw()
  ui.draw(levelmanager)
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
  ui.tryStartConnectionDrag(levelmanager.nodes, x/4, y/4)
  if ui.connect == nil then
    if ui.advance_button:isUnder(x/4, y/4) then
      ui.advance_button.pressed = true
    end
  end
end

function love.mousemoved(x, y)
  if ui.connect ~= nil then
    ui.updateConnectionDragTarget(levelmanager.nodes, x/4, y/4)
  end
end

function love.mousereleased(x, y)
  local lambda = {
    onConnect = function(startNode, targetNode)
      if (startNode.lambda ~= nil) then
        -- support or oppose action check here
        if (startNode.data.label == "player") then
          print("support")
          startNode.lambda.support(targetNode)
        else
          startNode.lambda.oppose(targetNode)
        end
      end
    end
  }
  ui.releaseConnectionDrag(lambda)
  if ui.advance_button.pressed then
    -- for _, node in ipairs(nodes) do
    --   if node.data.active == true then
    --     for _, neighbor in ipairs(node.neighbors) do
    --       if neighbor.data.progress ~= nil then
    --         -- neighbor.data.progress.current = neighbor.data.progress.current + 1
    --       end
    --     end
    --   end
    -- end
    levelmanager.checklevelprogress()
    levelmanager.progressvote()
  end
  ui.advance_button.pressed = false
end

function love.touchpressed(id, x, y, dx, dy, pressure)
  overlayStats.handleTouch(id, x, y, dx, dy, pressure) -- Should always be called last
end
