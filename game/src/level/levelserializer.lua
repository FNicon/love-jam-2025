local json  = require("lib.json.json")

return {
  read_from_json = function (filepath)
    local content, _ = love.filesystem.read(filepath)
    local _json = json.decode(content)
    -- return arson.decode(_json)
    return _json
  end,
  write_as_json = function(levelinfo, filepath)
    local content = json.encode(levelinfo)
    print(filepath)
    print(content)
    love.filesystem.write(filepath, content)
  end
}
