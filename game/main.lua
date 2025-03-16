local overlayStats = require("lib.overlayStats")
local graph = require("lib.graph")
local palette = require("lib.palette")

local root
local buffer = love.graphics.newCanvas(love.graphics.getWidth()/4, love.graphics.getHeight()/4)
buffer:setFilter("nearest")

local portrait_1 = love.graphics.newImage("assets/character_portrait_1.png")
portrait_1:setFilter("nearest")

function love.load()
  root = graph.node({x = buffer:getWidth() / 2, y = buffer:getHeight() / 2, portrait = portrait_1})
  for i = 1, 2, 1 do
    local newNodes = {}
    graph.traverse{root, onVisit=function (node)
      if #node.neighbors == 0 then
        newNodes[node] = {}
        local numNodes = 2
        local angle = math.atan2(node.data.y - root.data.y, node.data.x - root.data.x) - 15 * (numNodes - 1) * (2 - i)
        for j = 1, numNodes, 1 do
          local x = node.data.x + math.cos(angle) * 60
          local y = node.data.y + math.sin(angle) * 60
          table.insert(newNodes[node], graph.node{x = x, y = y, portrait = portrait_1})
          angle = angle + 5
        end
      end
    end}
    for node, neighbors in pairs(newNodes) do
      for _, neighbor in ipairs(neighbors) do
        node:connect(neighbor)
      end
    end
  end
  overlayStats.load() -- Should always be called last
end

function love.draw()
  love.graphics.setCanvas(buffer)
  love.graphics.clear(unpack(palette['blue'][4]))
  graph.draw(root)
  love.graphics.setCanvas()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(buffer, 0, 0, 0, 4, 4)
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
