local votemanager        = require("src.gameplay.vote.votemanager")
local graph              = require("src.data.graph")
local distancecalculator = require("src.data.distance")
local grid               = require("src.data.grid")
local levelserializer    = require("src.level.levelserializer")
local audiomanager       = require("src.audio.audiomanager")
local nodedata           = require("src.gameplay.nodedata")
local goalstate          = require("src.gameplay.goal.goalstate")

local levelmanager = {}
local currentvotemanager = {}
local turncount = 0
local levels = {}
local levels_directory = 'assets/levels'

local level_states = {
  success = 1,
  failed = 2,
  in_progress = 3
}

local function level_path_from_index(index)
  return string.format('assets/levels/level%s.json', index)
end

-- returning a string and then calling error helps diagnostics know that error was called
local function load_level_error(level_index, message)
  return string.format("Failed to load level, %s: %s", message, level_path_from_index(level_index))
end

local function load_level_files()
  local files = love.filesystem.getDirectoryItems(levels_directory)
  for _, file in ipairs(files) do
    local index_str = string.gsub(file, ".*(%d+).*", "%1")
    local index = tonumber(index_str)
    local path = string.format("%s/%s", levels_directory, file)
    print(string.format("loading level: %s, from: %s", index, path))
    levels[index] = levelserializer.read_from_json(path)
  end
end

function levelmanager.is_level_loaded()
  return levelmanager.currentlevel ~= -1
end

local function init_levelmanager_info(index, name)
  levelmanager.nodes = {}
  levelmanager.currentlevel = index
  levelmanager.turncount = 0
  levelmanager.currentlevelname = name
end

function levelmanager.init()
  init_levelmanager_info(-1, "No Level Loaded")
  levelmanager.grid = grid.new(60)
  load_level_files()
end

function levelmanager.on_load(index)
  audiomanager.play_sfx("next_level")
end

local function convert_params_coords(params)
  params.x, params.y = levelmanager.grid:gridToWorldCoords(params.x, params.y)
end

function levelmanager.create_node(params)
  local node = graph.node()
  local data_type = nodedata.types[params.type]
  node.data = data_type(node, params)
  table.insert(levelmanager.nodes, node)
  return node
end

local function create_player_node(params)
  params.type = "player"
  return levelmanager.create_node(params)
end

function levelmanager.remove_node(node_to_remove)
  local index
  for i, node in ipairs(levelmanager.nodes) do
    if node == node_to_remove then
      index = i
      break
    end
  end
  table.remove(levelmanager.nodes, index)
end

function levelmanager.get_nodes_filtered(filter_func)
  local nodes = {}
  for _, node in ipairs(levelmanager.nodes) do
    if filter_func(node) == true then
      table.insert(nodes, node)
    end
  end
  return nodes
end

local function load_nodes(level_info_node_map, loaded_node_map)
  for name, params in pairs(level_info_node_map) do
    convert_params_coords(params)
    if loaded_node_map[name] ~= nil then
      error(load_level_error("node names must be unique, found duplicate[" .. name .."]"))
    end
    loaded_node_map[name] = levelmanager.create_node(params)
  end
end

function levelmanager.load(index)
  print("Loading Level " .. index)
  levelmanager.on_load(index)

  -- grab level info from table, preferably this is verified to exist
  -- and is validated load time
  local levelinfo = table.deep_copy(levels[index])
  init_levelmanager_info(index, levelinfo.name)

  -- used to build existing connections and enforce unique names
  local loaded_node_map = {}

  print(#levelmanager.nodes)
  -- create player
  convert_params_coords(levelinfo.player_location)
  local player = create_player_node(levelinfo.player_location)
  loaded_node_map["player"] = player
  print(#levelmanager.nodes)

  -- load other nodes
  load_nodes(levelinfo.nodes, loaded_node_map)

  -- create exiting connections
  if levelinfo.connections ~= nil then
    print("Creating existing connections")
    for name, node in pairs(loaded_node_map) do
      if levelinfo.connections[name] ~= nil then
        local targets = levelinfo.connections[name].nodes
        for _, name in ipairs(targets) do
          local target = loaded_node_map[name]
          local length = distancecalculator.worldToGridDistance(
            levelmanager.grid,
            node.data.x, node.data.y,
            target.data.x, target.data.y
          )
          print("connection distance ", length)
          local voter = node.data:getComponent(nodedata.components.voter)
          voter:on_connect(length, target)
        end
      end
    end
  end

  -- setup votemanager
  levelmanager.setupvotemanager(false)

  print("Level loaded successfully")
end

function levelmanager.get_level_status()
  local goals = levelmanager.get_nodes_filtered(votemanager.is_required_goal)
  local current_state = level_states.success
  for _, goal in ipairs(goals) do
    local progress = goal.data:getComponent(nodedata.components.progressable)
    if progress.goal_state == goalstate.pending then
      current_state = level_states.in_progress
    elseif progress.goal_state == goalstate.failed then
      return level_states.failed
    end
  end
  -- to do is heart list check really needed?
  local hearts = levelmanager.get_nodes_filtered(votemanager.is_heart)
  for _, heart in ipairs(hearts) do
    local progress = heart.data:getComponent(nodedata.components.progressable)
    if progress.goal_state == goalstate.pending then
      current_state = level_states.in_progress
    elseif progress.goal_state == goalstate.failed then
      return level_states.failed
    end
  end
  return current_state
end

function levelmanager.advance()
  local level_status = levelmanager.get_level_status()
  if (level_status == level_states.failed) then
    -- handle failure
  elseif level_status == level_states.success then
    levelmanager.loadnextlevel()
  else
    turncount = turncount + 1
    print("Start vote turn ", turncount)
    currentvotemanager:poll()
  end
end

function levelmanager.setupvotemanager(is_re_setup)
  if not (is_re_setup) then
    currentvotemanager = votemanager.new(levelmanager)
  end
end

function levelmanager.restartlevel()
  if levelmanager.currentlevel == nil then
    error("No level loaded")
  else
    print("restarting")
    levelmanager.load(levelmanager.currentlevel)
  end
end

function levelmanager.all_levels_completed()
  return levelmanager.currentlevel >= #levels and levelmanager.get_level_status() == level_states.success
end

function levelmanager.loadnextlevel()
  levelmanager.load(levelmanager.currentlevel + 1)
end

function levelmanager.printlevel()
  print("Current Level: " .. levelmanager.currentlevel)
  print("Level Name: " .. levelmanager.currentlevelname)
end

function levelmanager.collectEdges()
  local edges = {}
  local visited = graph.visitedSet()
  for _, node in ipairs(levelmanager.nodes) do
    if not visited:contains(node) then
      graph.traverse{node, onVisit = function (node)
        for _, neighbor in ipairs(node.neighbors) do
          if not visited:contains(neighbor) then
            table.insert(edges, graph.edge(node, neighbor))
          end
        end
      end}
    end
  end
  return edges
end

return levelmanager
