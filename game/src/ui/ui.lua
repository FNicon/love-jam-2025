local graph = require("src.data.graph")
local palette = require("assets.palette")
local icons = require("assets.icons")
local buffer = require("src.ui.buffer")
local votetypes = require("src.gameplay.vote.votetype")
local distancecalculator = require("src.data.distance")

local ui = {}
local lastdrawnx = 0
local lastdrawny = 0

--- TODO: make sure this is deterministically run before loading any assets
love.graphics.setDefaultFilter("nearest", "nearest", 1)
love.graphics.setLineStyle("rough")

ui.pixel_scale = 4
ui.font = love.graphics.newFont("assets/m6x11.ttf", 16, "mono")
ui.node_radius = 15
ui.background_color = palette.blue[4]
local highlightedEdge

-- world coordinates are based on the upscaling of the buffer by the pixel_scale
-- the buffer we draw to
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

local function Button (label, icon_up, icon_down, x, y, onClick)
  return {
    pressed = false,
    x = x,
    y = y,
    label = label,
    icon_up = icon_up,
    icon_down = icon_down,
    onClick = onClick,
    isUnder = function (self, x, y)
      return math.abs(x - self.x) < math.floor(self.icon_up:getWidth()/2)
        and math.abs(y - self.y) < math.floor(self.icon_up:getHeight()/2)
    end,
    draw = function (self)
      local icon
      if self.pressed then
        icon = self.icon_down
      else
        icon = self.icon_up
      end
      love.graphics.draw(
        icon,
        self.x - math.floor(icon:getWidth() / 2),
        self.y - math.floor(icon:getHeight() / 2)
      )
      love.graphics.print(
        self.label,
        self.x - math.floor(ui.font:getWidth(self.label)/2),
        self.y + math.ceil(icon:getHeight() * .8)
      )
    end
  }
end

ui.buttons = {
  Button(
    'advance',
    icons.ui.advance_button.up,
    icons.ui.advance_button.down,
    ui.getWorldWidth() - 60,
    ui.getWorldHeight() - 60,
    function ()
      local levelinprogress = _levelmanager.checklevelprogress()
      if (levelinprogress) then
        _levelmanager.progressvote()
      end
    end
  ),
  Button(
    'reset',
    icons.ui.reset_button.up,
    icons.ui.reset_button.down,
    ui.getWorldWidth() - 120,
    ui.getWorldHeight() - 60,
    function ()
      _levelmanager.restartlevel()
    end
  )
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
  if foundNode ~= nil and foundNode.data.controllable then
    ui.startConnectionDrag(foundNode)
  end
end

function ui.updateConnectionDragTarget(x, y)
  local xoff, yoff = x - ui.connect.start.data.x, y - ui.connect.start.data.y
  local clampedxoff, clampedyoff = distancecalculator.clampWorldToGridDistance(
    _levelmanager.grid,
    ui.connect.start.data.maxlength,
    xoff,
    yoff
  )
  local clampedx, clampedy = ui.connect.start.data.x + clampedxoff, ui.connect.start.data.y + clampedyoff
  local foundNode = nodeAtLocation(clampedx, clampedy)
  if foundNode ~= nil and foundNode ~= ui.connect.start then
    ui.connect.target = foundNode
  else
    ui.connect.target = {x = clampedx, y = clampedy}
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
    for _, button in ipairs(ui.buttons) do
      if button:isUnder(x, y) then
        button.pressed = true
      else
        button.pressed = false
      end
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
    if (onEdge(x, y, edge)) and (edge.n1.data.label == "player" or edge.n2.data.label == "player") then
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
        local length = distancecalculator.worldToGridDistance(_levelmanager.grid, startNode.data.x, startNode.data.y, targetNode.data.x, targetNode.data.y)
        print("connection distance ", length)
        startNode.lambda.pick_side(targetNode, "support", length)
      end
    end
  }
  ui.releaseConnectionDrag(lambda)
  for _, button in ipairs(ui.buttons) do
    if button.pressed then
      button.onClick()
    end
    button.pressed = false
  end
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
    local edgelabel = (from:getedge(to).label)
    -- is highlightedEdge
    love.graphics.setColor(unpack(votetypes[edgelabel].highlight))
  else
    local edge = (from:getedge(to))
    if (edge ~= nil) then
      love.graphics.setColor(unpack(votetypes[edge.label].highlight))
    else
      love.graphics.setColor(unpack(palette['orange'][3]))
    end
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
  love.graphics.setLineWidth(3)
  -- assume if to is not a node then it is a table with {x =,y=}
  if to.data ~= nil then
    drawConnectionLineFromNodeToNode(from, to)
  else
    drawConnectionLineFromNodeToPosition(from, to)
  end
end

local function drawNodes()
  love.graphics.setLineWidth(2)
  for _, node in ipairs(_levelmanager.nodes) do
    if node.data.progress ~= nil then
      local angleDelta = (2 * math.pi) / node.data.progress.max
      for i = 1, node.data.progress.max, 1 do
        if i <= node.data.progress.current then
          if (node.data.goal.winners ~= nil and node.data.goal.winners[i] ~= nil) then
            local winner = node.data.goal.winners[i]
            love.graphics.setColor(unpack(votetypes[winner].color))
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
    love.graphics.setColor(unpack(palette['green'][4]))
    love.graphics.circle("line", node.data.x, node.data.y, ui.node_radius)
    -- node label
    if node.data.label ~= nil then
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.print(
        node.data.label,
        node.data.x - ui.font:getWidth(node.data.label) / 2,
        node.data.y + ui.node_radius
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
  for _, button in ipairs(ui.buttons) do
    button:draw()
  end
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
