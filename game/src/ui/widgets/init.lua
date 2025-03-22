local widgets = {}

for _, file in ipairs(love.filesystem.getDirectoryItems('src/ui/widgets')) do
  local widget_name = string.gsub(file, '.lua', '')
  if widget_name ~= 'init' then
    widgets[widget_name] = require('src.ui.widgets.' .. widget_name)
  end
end

return widgets
