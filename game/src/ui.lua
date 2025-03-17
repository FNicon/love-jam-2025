local graph = require("lib.graph")
local palette = require("assets.palette")
local icons = require("assets.icons")

love.graphics.setDefaultFilter("nearest", "nearest", 1)
love.graphics.setLineStyle("rough")
love.graphics.setLineWidth(3)

local ui = {}

ui.buffer = love.graphics.newCanvas(love.graphics.getWidth()/4, love.graphics.getHeight()/4)
ui.font = love.graphics.newFont("assets/m6x11.ttf", 16, "mono")
ui.node_radius = 15

ui.advance_button = {
  pressed = false,
  x = ui.buffer:getWidth() - 60,
  y = ui.buffer:getHeight() - 60,
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
    love.graphics.print(self.label, self.x - math.floor(ui.font:getWidth(self.label)/2), self.y + math.ceil(self.radius * 1.5))
  end
}

local function nodeAtLocation(nodes, x, y)
  local found
  for _, node in ipairs(nodes) do
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

function ui.tryStartConnectionDrag(nodes, x, y)
  local foundNode = nodeAtLocation(nodes, x, y)
  if foundNode ~= nil then
    ui.startConnectionDrag(foundNode)
  end
end

function ui.updateConnectionDragTarget(nodes, x, y)
  local foundNode = nodeAtLocation(nodes, x, y)
  if foundNode ~= nil and foundNode ~= ui.connect.start then
    ui.connect.target = foundNode
  else
    ui.connect.target = {x = x, y = y}
  end
end

function ui.releaseConnectionDrag()
  if ui.connect ~= nil then
    -- connect nodes if target is a node
    if ui.connect.target.data ~= nil and not ui.connect.start:isneighbor(ui.connect.target) then
      ui.connect.start:connect(ui.connect.target)
    end
    ui.connect = nil
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

local function drawGraph(nodes)
  local visited = graph.visitedSet()
  local edges = {}
  love.graphics.setFont(ui.font)
  for _, node in ipairs(nodes) do
    if not visited:contains(node) then
      graph.traverse{node, onVisit = function (node)
        -- node progress
        if node.data.progress ~= nil then
          local angleDelta = (2 * math.pi) / node.data.progress.max
          for i = 1, node.data.progress.max, 1 do
            if i <= node.data.progress.current then
              love.graphics.setColor(unpack(palette['green'][3]))
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
          love.graphics.print(
            node.data.label,
            node.data.x - ui.font:getWidth(node.data.label) / 2,
            node.data.y - ui.node_radius * 3
          )
        end
        -- collect edges
        for _, neighbor in ipairs(node.neighbors) do
          if not visited:contains(neighbor) then
            table.insert(edges, graph.edge(node, neighbor))
          end
        end
      end}
    end
  end
  -- draw edges
  love.graphics.setColor(unpack(palette['orange'][3]))
  for _, edge in ipairs(edges) do
    drawConnectionLine(edge.n1, edge.n2)
  end
  -- if current attempting to create a connection draw the line
  if ui.connect ~= nil then
    drawConnectionLine(ui.connect.start, ui.connect.target)
  end
end

function ui.draw(nodes)
  love.graphics.setCanvas(ui.buffer)
  love.graphics.clear(unpack(palette.blue[4]))
  drawGraph(nodes)
  ui.advance_button:draw()
  love.graphics.setCanvas()
  love.graphics.setColor(1, 1, 1, 1)
  love.graphics.draw(ui.buffer, 0, 0, 0, 4, 4)
end

return ui
