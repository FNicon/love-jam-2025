local graph = require("src.data.graph")
local palette = require("assets.palette")
local icons = require("assets.icons")
local buffer = require("src.ui.buffer")

local ui = {}

--- TODO: make sure this is deterministically run before loading any assets
love.graphics.setDefaultFilter("nearest", "nearest", 1)
love.graphics.setLineStyle("rough")
love.graphics.setLineWidth(3)

ui.pixel_scale = 4
ui.font = love.graphics.newFont("assets/m6x11.ttf", 16, "mono")
ui.node_radius = 15
ui.background_color = palette.blue[4]
local highlightedEdge

function ui.getWorldWidth()
  return love.graphics.getWidth() / ui.pixel_scale
end

function ui.getWorldHeight()
  return love.graphics.getHeight() / ui.pixel_scale
end

function ui.getWorldCoords(x, y)
  return x / ui.pixel_scale, y / ui.pixel_scale
end

local _levelmanager
function ui.init(levelmanager)
  _levelmanager = levelmanager
  buffer:init(ui.getWorldWidth(), ui.getWorldHeight(), ui.pixel_scale)
end

ui.advance_button = {
  pressed = false,
  x = ui.getWorldWidth() - 60,
  y = ui.getWorldHeight() - 60,
  radius = math.floor(icons.ui.advance_button.up:getWidth() / 2),
  label = "advance",
  isUnder = function (self, x, y)
    local distance = math.sqrt(
      math.pow(self.x - x, 2) +
      math.pow(self.y - y, 2)
    )
    return distance < self.radius
  end,
  draw = function (self)
    local icon
    if self.pressed then
      icon = icons.ui.advance_button.down
    else
      icon = icons.ui.advance_button.up
    end
    love.graphics.draw(
      icon,
      self.x - self.radius,
      self.y - self.radius
    )
    love.graphics.print(
      self.label,
      self.x - math.floor(ui.font:getWidth(self.label)/2),
      self.y + math.ceil(self.radius * 1.5)
    )
  end
}

local function nodeAtLocation(x, y)
  local found
  for _, node in ipairs(_levelmanager.nodes) do
    local distance = math.sqrt(
      math.pow(node.data.x - x, 2) +
      math.pow(node.data.y - y, 2)
    )
    if distance < ui.node_radius then
      found = node
    end
  end
  return found
end

function ui.startConnectionDrag(node)
  ui.connect = {}
  ui.connect.start = node
  ui.connect.target = {x = node.data.x, y = node.data.y}
end

function ui.tryStartConnectionDrag( x, y)
  local foundNode = nodeAtLocation(x, y)
  if foundNode ~= nil then
    ui.startConnectionDrag(foundNode)
  end
end

function ui.updateConnectionDragTarget(x, y)
  local foundNode = nodeAtLocation(x, y)
  if foundNode ~= nil and foundNode ~= ui.connect.start then
    ui.connect.target = foundNode
  else
    ui.connect.target = {x = x, y = y}
  end
end

function ui.releaseConnectionDrag(lambda)
  if ui.connect ~= nil then
    -- connect nodes if target is a node
    if ui.connect.target.data ~= nil and not ui.connect.start:isneighbor(ui.connect.target) then
      lambda.onConnect(ui.connect.start, ui.connect.target)
      -- ui.connect.start:connect(ui.connect.target)
    end
    ui.connect = nil
  end
end

function ui.mousepressed(mouseX, mouseY)
  local x, y = ui.getWorldCoords(mouseX, mouseY)
  ui.tryStartConnectionDrag(x, y)
  if ui.connect == nil then
    if ui.advance_button:isUnder(x, y) then
      ui.advance_button.pressed = true
    end
  end
end

local function onEdge(x, y, edge)
  local deltaY, deltaX =  edge.n2.data.y - edge.n1.data.y,
                          edge.n2.data.x - edge.n1.data.x
  local edgeAngle = math.atan2(deltaY, deltaX)
  local edgeLength = math.sqrt(math.pow(deltaX, 2) + math.pow(deltaY, 2))
  local hoverOffX, hoverOffY = x - edge.n1.data.x, y - edge.n1.data.y
  local hoverOffLength = math.sqrt(math.pow(hoverOffX, 2) + math.pow(hoverOffY, 2))
  local hoverAngle = math.atan2(hoverOffY, hoverOffX) - edgeAngle
  local hoverToEdgeDist = math.abs(hoverOffLength * math.sin(hoverAngle))
  local hoverEdgeLength = math.cos(hoverAngle) * hoverOffLength
  local hoverBetweenNodes =  hoverEdgeLength > 0 and hoverEdgeLength < edgeLength
  return hoverBetweenNodes and hoverToEdgeDist < 4
end

function ui.mousemoved(mouseX, mouseY)
  local x, y = ui.getWorldCoords(mouseX, mouseY)
  if ui.connect ~= nil then
    ui.updateConnectionDragTarget(x, y)
  end
  highlightedEdge = nil
  for _, edge in ipairs(_levelmanager.collectEdges()) do
    if (onEdge(x, y, edge)) then
      highlightedEdge = edge
      break
    end
  end
end

function ui.mousereleased(mouseX, mouseY)
  local x, y = ui.getWorldCoords(mouseX, mouseY)
  local lambda = {
    onConnect = function(startNode, targetNode)
      if (startNode.lambda ~= nil) then
        -- support or oppose action check here
        if (startNode.data.label == "player") then
          startNode.lambda.support(targetNode)
        else
          startNode.lambda.oppose(targetNode)
        end
      end
    end
  }
  ui.releaseConnectionDrag(lambda)
  if ui.advance_button.pressed then
    _levelmanager.checklevelprogress()
    _levelmanager.progressvote()
  end
  ui.advance_button.pressed = false
  if highlightedEdge ~= nil then
    highlightedEdge.n1:disconnect(highlightedEdge.n2)
  end
end

local function drawConnectionLineFromNodeToNode(from, to)
  local angle = math.atan2(
    to.data.y - from.data.y,
    to.data.x - from.data.x
  )
  local start_x, start_y =  from.data.x + math.cos(angle) * ui.node_radius,
                            from.data.y + math.sin(angle) * ui.node_radius
  local end_x, end_y =  to.data.x - math.cos(angle) * ui.node_radius,
                        to.data.y - math.sin(angle) * ui.node_radius
  if (highlightedEdge ~= nil) and
    ((from == highlightedEdge.n1 and to == highlightedEdge.n2) or
      (from == highlightedEdge.n2 and to == highlightedEdge.n1))
  then
    -- is highlightedEdge
    love.graphics.setColor(unpack(palette['orange'][2]))
  else
    love.graphics.setColor(unpack(palette['orange'][3]))
  end
  love.graphics.line(start_x, start_y, end_x, end_y)
end

local function drawConnectionLineFromNodeToPosition(from, to)
  local angle = math.atan2(
    to.y - from.data.y,
    to.x - from.data.x
  )
  local start_x, start_y =  from.data.x + math.cos(angle) * ui.node_radius,
                            from.data.y + math.sin(angle) * ui.node_radius
  love.graphics.line(start_x, start_y, to.x, to.y)
end

local function drawConnectionLine(from, to)
  -- assume if to is not a node then it is a table with {x =,y=}
  if to.data ~= nil then
    drawConnectionLineFromNodeToNode(from, to)
  else
    drawConnectionLineFromNodeToPosition(from, to)
  end
end

local function drawNodes()
  for _, node in ipairs(_levelmanager.nodes) do
    if node.data.progress ~= nil then
      local angleDelta = (2 * math.pi) / node.data.progress.max
      for i = 1, node.data.progress.max, 1 do
        if i <= node.data.progress.current then
          if (node.data.goal.winners ~= nil and node.data.goal.winners[i] ~= nil) then
            local winner = node.data.goal.winners[i]
            if winner == "support" then
              love.graphics.setColor(unpack(palette['green'][3]))
            elseif winner == "oppose" then
              love.graphics.setColor(unpack(palette['orange'][2]))
            else
              love.graphics.setColor(unpack(palette['blue'][3]))
            end
          end
        else
          love.graphics.setColor(unpack(palette['green'][1]))
        end
        love.graphics.arc(
          "fill",
          node.data.x,
          node.data.y,
          ui.node_radius * 1.5,
          (i - 2) * angleDelta,
          (i - 1) * angleDelta
        )
        love.graphics.setColor(unpack(palette['green'][4]))
        love.graphics.arc(
          "line",
          node.data.x,
          node.data.y,
          ui.node_radius * 1.5,
          (i - 2) * angleDelta,
          (i - 1) * angleDelta
        )
      end
    end
    -- node background
    love.graphics.setColor(unpack(palette['blue'][3]))
    love.graphics.circle("fill", node.data.x, node.data.y, ui.node_radius)
    -- node icon
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(node.data.icon, node.data.x - ui.node_radius, node.data.y - ui.node_radius)
    -- node outline
    love.graphics.setColor(unpack(palette['orange'][3]))
    love.graphics.circle("line", node.data.x, node.data.y, ui.node_radius)
    -- node label
    if node.data.label ~= nil then
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.print(
        node.data.label,
        node.data.x - ui.font:getWidth(node.data.label) / 2,
        node.data.y - ui.node_radius * 2.5
      )
    end
  end
end

local function drawEdges()
  love.graphics.setColor(unpack(palette['orange'][3]))
  for _, edge in ipairs(_levelmanager.collectEdges()) do
    drawConnectionLine(edge.n1, edge.n2)
  end
  -- if current attempting to create a connection draw the line
  if ui.connect ~= nil then
    drawConnectionLine(ui.connect.start, ui.connect.target)
  end
end

local function drawLevelInfo()
  love.graphics.setFont(ui.font)
  love.graphics.print(
    _levelmanager.currentlevelname,
    (ui.getWorldWidth() - ui.font:getWidth(_levelmanager.currentlevelname)) / 2,
    10
  )
end

local function drawInterface()
  ui.advance_button:draw()
end

function ui.draw()
  buffer:drawOn(function ()
    love.graphics.clear(unpack(ui.background_color))
    drawEdges()
    drawNodes()
    drawLevelInfo()
    drawInterface()
  end)
  buffer:draw()
end

-- WIP: Print text on screen
function ui.print(label, x, y)
  local newx = x - ui.font:getWidth(label) / 2
  local newy = y - ui.node_radius * 3
  love.graphics.setColor(unpack(palette['orange'][3]))
  love.graphics.print(label, newx, newy)
end

return ui
