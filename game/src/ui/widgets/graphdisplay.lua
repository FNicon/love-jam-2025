local distancecalculator = require("src.data.distance")
local votetypes = require("src.gameplay.vote.votetype")
local palette   = require("assets.palette")

return function(
  levelmanager
)
  local w = {
    levelmanager = levelmanager,
    node_radius = 15,
    connect = nil
  }

  function w:nodeAtLocation(x, y)
    local found
    for _, node in ipairs(self.levelmanager.nodes) do
      local distance = math.sqrt(
        math.pow(node.data.x - x, 2) +
        math.pow(node.data.y - y, 2)
      )
      if distance < self.node_radius then
        found = node
      end
    end
    return found
  end

  function w:startConnectionDrag(node)
    self.connect = {}
    self.connect.start = node
    self.connect.target = {x = node.data.x, y = node.data.y}
  end

  function w:tryStartConnectionDrag( x, y)
    local foundNode = self:nodeAtLocation(x, y)
    if foundNode ~= nil and foundNode.data.controllable then
      self:startConnectionDrag(foundNode)
    end
  end

  function w:updateConnectionDragTarget(x, y)
    local xoff, yoff = x - self.connect.start.data.x, y - self.connect.start.data.y
    local clampedxoff, clampedyoff = distancecalculator.clampWorldToGridDistance(
      self.levelmanager.grid,
      self.connect.start.data.maxlength,
      xoff,
      yoff
    )
    local clampedx, clampedy = self.connect.start.data.x + clampedxoff, self.connect.start.data.y + clampedyoff
    local foundNode = self:nodeAtLocation(clampedx, clampedy)
    if foundNode ~= nil and foundNode ~= self.connect.start then
      self.connect.target = foundNode
    else
      self.connect.target = {x = clampedx, y = clampedy}
    end
  end

  function w:releaseConnectionDrag(lambda)
    if self.connect ~= nil then
      -- connect nodes if target is a node
      if self.connect.target.data ~= nil and not self.connect.start:isneighbor(self.connect.target) then
        lambda.onConnect(self.connect.start, self.connect.target)
        -- self.connect.start:connect(self.connect.target)
      end
      self.connect = nil
    end
  end

  function w:mousepressed(x, y)
    self:tryStartConnectionDrag(x, y)
  end

  function w:onEdge(x, y, edge)
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

  function w:mousemoved(x, y)
    if self.connect ~= nil then
      self:updateConnectionDragTarget(x, y)
    end
    self.highlightedEdge = nil
    for _, edge in ipairs(self.levelmanager.collectEdges()) do
      if (w:onEdge(x, y, edge)) and (edge.n1.data.label == "player" or edge.n2.data.label == "player") then
        self.highlightedEdge = edge
        break
      end
    end
  end

  function w:mousereleased(x, y)
    local lambda = {
      onConnect = function(startNode, targetNode)
        if (startNode.lambda ~= nil) then
          -- support or oppose action check here
          local length = distancecalculator.worldToGridDistance(self.levelmanager.grid, startNode.data.x, startNode.data.y, targetNode.data.x, targetNode.data.y)
          print("connection distance ", length)
          startNode.lambda.pick_side(targetNode, "support", length)
        end
      end
    }
    self:releaseConnectionDrag(lambda)
    if self.highlightedEdge ~= nil then
      self.highlightedEdge.n1:disconnect(self.highlightedEdge.n2)
    end
  end

  function w:drawConnectionLineFromNodeToNode(from, to)
    local angle = math.atan2(
      to.data.y - from.data.y,
      to.data.x - from.data.x
    )
    local start_x, start_y =  from.data.x + math.cos(angle) * self.node_radius,
                              from.data.y + math.sin(angle) * self.node_radius
    local end_x, end_y =  to.data.x - math.cos(angle) * self.node_radius,
                          to.data.y - math.sin(angle) * self.node_radius
    if (self.highlightedEdge ~= nil) and
      ((from == self.highlightedEdge.n1 and to == self.highlightedEdge.n2) or
        (from == self.highlightedEdge.n2 and to == self.highlightedEdge.n1))
    then
      local edgelabel = (from:getedge(to).label)
      -- is self.highlightedEdge
      love.graphics.setColor(unpack(votetypes[edgelabel].highlight))
    else
      local edge = (from:getedge(to))
      if (edge ~= nil) then
        love.graphics.setColor(unpack(votetypes[edge.label].color))
      else
        love.graphics.setColor(unpack(votetypes["support"].color))
      end
    end
    love.graphics.line(start_x, start_y, end_x, end_y)
  end

  function w:drawConnectionLineFromNodeToPosition(from, to)
    local angle = math.atan2(
      to.y - from.data.y,
      to.x - from.data.x
    )
    love.graphics.setColor(unpack(votetypes["support"].color))
    local start_x, start_y =  from.data.x + math.cos(angle) * self.node_radius,
                              from.data.y + math.sin(angle) * self.node_radius
    love.graphics.line(start_x, start_y, to.x, to.y)
  end

  function w:drawConnectionLine(from, to)
    love.graphics.setLineWidth(3)
    -- assume if to is not a node then it is a table with {x =,y=}
    if to.data ~= nil then
      self:drawConnectionLineFromNodeToNode(from, to)
    else
      self:drawConnectionLineFromNodeToPosition(from, to)
    end
  end

  function w:drawNodes(ui)
    love.graphics.setLineWidth(2)
    for _, node in ipairs(self.levelmanager.nodes) do
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
            self.node_radius * 1.5,
            (i - 2) * angleDelta,
            (i - 1) * angleDelta
          )
          love.graphics.setColor(unpack(palette['green'][4]))
          love.graphics.arc(
            "line",
            node.data.x,
            node.data.y,
            self.node_radius * 1.5,
            (i - 2) * angleDelta,
            (i - 1) * angleDelta
          )
        end
      end
      -- node background
      love.graphics.setColor(unpack(palette['blue'][3]))
      love.graphics.circle("fill", node.data.x, node.data.y, self.node_radius)
      -- node icon
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.draw(node.data.icon, node.data.x - self.node_radius, node.data.y - self.node_radius)
      -- node outline
      love.graphics.setColor(unpack(palette['green'][4]))
      love.graphics.circle("line", node.data.x, node.data.y, self.node_radius)
      -- node label
      if node.data.label ~= nil then
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.print(
          node.data.label,
          node.data.x - ui.font:getWidth(node.data.label) / 2,
          node.data.y + self.node_radius
        )
      end
    end
  end

  function w:drawEdges(ui)
    love.graphics.setColor(unpack(palette['orange'][3]))
    for _, edge in ipairs(self.levelmanager.collectEdges()) do
      self:drawConnectionLine(edge.n1, edge.n2)
    end
    -- if current attempting to create a connection draw the line
    if self.connect ~= nil then
      self:drawConnectionLine(self.connect.start, self.connect.target)
    end
  end

  function w:draw(ui)
    self:drawEdges(ui)
    self:drawNodes(ui)
  end

  return w
end
