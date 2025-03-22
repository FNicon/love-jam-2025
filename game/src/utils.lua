local utils = {}

function utils.require_dirrectory(path, ignore_list)
  local t = {}
  for _, file in ipairs(love.filesystem.getDirectoryItems(path)) do
    local module_name = string.gsub(file, '.lua', '')
    local ignore = false
    for _, ignore_name in ipairs(ignore_list) do
      if module_name == ignore_name then
        ignore = true
        break
      end
    end
    if not ignore then
      local require_path = string.gsub(path, '/', '.')
      t[module_name] = require(require_path .. '.' .. module_name)
    end
  end
  return t
end

return utils
