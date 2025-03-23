local widgets = require "src.ui.widgets.init"
local nodedata = require "src.gameplay.nodedata"
local icons    = require "assets.icons"
local levelserializer = require "src.level.levelserializer"

return function (ui, levelmanager, level_file)
  local tile_size = levelmanager.grid.tile_size
  local grid_width, grid_height = math.floor(ui.getWorldWidth() / tile_size),
    math.floor(ui.getWorldHeight() / tile_size)

  local levelinfo
  if love.filesystem.getInfo(level_file) ~= nil then
    levelinfo = levelserializer.read_from_json(level_file)
  end

  local nodeplacer = widgets.nodeplacer(levelmanager.grid)
  local o = {
    widgets = {
      widgets.background(ui.background_color),
      widgets.griddisplay(grid_width, grid_height, tile_size),
      nodeplacer,
      widgets.button(
        "",
        icons.save,
        icons.save,
        ui:getWorldWidth() - 15,
        15,
        function ()
          levelinfo = {}
          levelinfo.nodes = {}
          levelinfo.connections = {}
          for _, node in ipairs(nodeplacer.nodes) do
            levelinfo.nodes[node.id] = {
              type = node.type,
              x = math.floor(node.x / tile_size),
              y = math.floor(node.y / tile_size),
            }
          end
          for node, node_info in pairs(nodeplacer.connections) do
            levelinfo.connections[node.id] = {nodes = {}}
            for _, target in ipairs(node_info.nodes) do
              table.insert(levelinfo.connections[node.id].nodes, target.id)
            end
          end
          levelserializer.write_as_json(levelinfo, level_file)
        end
      )
    }
  }
  if levelinfo ~= nil then
    local loaded_node_map = {}
    for name, node in pairs(levelinfo.nodes) do
      local data_type = nodedata.types[node.type]
      local x, y = levelmanager.grid:gridToWorldCoords(node.x, node.y)
      local dummy = data_type({}, {x = x, y = y})
      dummy.id = name
      loaded_node_map[name] = dummy
      nodeplacer:add_node(dummy)
    end
    for name, connect_info in pairs(levelinfo.connections) do
      for _, target in ipairs(connect_info.nodes) do
        nodeplacer:add_connection(loaded_node_map[name], loaded_node_map[target])
      end
    end
  end
  table.insert(o.widgets, widgets.nodeselector(nodeplacer, 10, ui:getWorldHeight() - 35))
  return o
end
