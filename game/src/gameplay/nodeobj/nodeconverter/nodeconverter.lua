local icons              = require("assets.icons")

return function(args)
  print(args.src.data.label)
  local node_type = args.to.type

  if node_type == "relay" then
    local relaynode = require("src.gameplay.relay.relaynode")
    local new_relay_node = relaynode.new{
      x = args.src.data.x,
      y = args.src.data.y,
      icon = icons[args.to.icon],
      label = args.to.label,
      active = true,
      maxlength = args.to.maxlength
    }
    new_relay_node.data.controllable = true

    local index
    for i, node in ipairs(args.levelmanager.nodes) do
      if node == args.src then
        index = i
        break
      end
    end
    table.remove(args.levelmanager.nodes, index)
    table.insert(args.levelmanager.nodes, new_relay_node)
    if args.src.data.type == "goal" then
      for i, vb in ipairs(args.votemanager.voteboxes) do
        if vb.goal == args.src then
          table.remove(args.votemanager.voteboxes, i)
          break
        end
      end
    end

    print("Controllable?",new_relay_node.data.controllable)
    return true
  end
end
