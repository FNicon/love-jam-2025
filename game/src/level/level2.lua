local level1 = {}
level1.name = "Two Doors"
-- level1.icon = icons.level[1]

function level1.load(nodes, graph, icons, ui)
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
  table.insert(nodes, graph.node{
    x = ui.buffer:getWidth() / 2,
    y = ui.buffer:getHeight() / 2 + 60,
    icon = icons.object.door,
    label = 'find exit',
    progress = {max = 4, current = 0}
  })
end

return level1
