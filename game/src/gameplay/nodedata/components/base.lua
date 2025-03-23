local component = {}

function component.create(name, owner)
  if name == nil or owner == nil then
    error("Component creation requires name and node owner")
  end
  local c = {}
  c.name = name
  c.owner = owner
  return c
end

return component
