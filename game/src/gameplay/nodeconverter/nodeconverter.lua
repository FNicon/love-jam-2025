local icons              = require("assets.icons")
local node_converter = {}

function node_converter.convert_to(args, original_node)
  print(original_node.data.label)
  local node_type = ""
  local new_data = {}
  for index, arg in ipairs(args) do
    if index == 1 then
      node_type = arg
    elseif index == 2 then
      -- label, icon
      new_data = arg
    end
  end

  if node_type == "relay" then
    local relaynode = require("src.gameplay.relay.relaynode")
    local new_relay_node = relaynode.new{
      x = original_node.x,
      y = original_node.y,
      icon = icons.characters[new_data.icon],
      label = new_data.label,
      active = true,
      maxlength = original_node.data.maxlength,
    }
    new_relay_node.data.controllable = true

    print("Controllable?",new_relay_node.data.controllable)
    -- table.remove(_level_manager.nodes, original_node)
    -- table.insert(_level_manager.nodes, new_relay_node)
    -- levelmanager.setupvotemanager(true)
    return new_relay_node
  end
end

return node_converter
