local palette = require("assets.palette")
local buffer = require("src.ui.buffer")

local ui = {}

--- TODO: make sure this is deterministically run before loading any assets
love.graphics.setDefaultFilter("nearest", "nearest", 1)
love.graphics.setLineStyle("rough")

ui.font = require("assets.font")
ui.pixel_scale = 4
ui.node_radius = 15
ui.background_color = palette.blue[4]

-- world coordinates are based on the upscaling of the buffer by the pixel_scale
-- the buffer we draw to
function ui.getWorldWidth()
  return love.graphics.getWidth() / ui.pixel_scale
end

function ui.getWorldHeight()
  return love.graphics.getHeight() / ui.pixel_scale
end

function ui.getWorldCoords(x, y)
  return x / ui.pixel_scale, y / ui.pixel_scale
end

local function widgets_run(func_name, args)
  for _, widget in ipairs(ui.screen.widgets) do
    local f = widget[func_name]
    if f ~= nil then
      f(widget, unpack(args))
    end
  end
end

function ui.init(screen)
  buffer:init(ui.getWorldWidth(), ui.getWorldHeight(), ui.pixel_scale)
  ui.screen = screen
end

function ui.change_screen(screen)
  ui.screen = screen
end

function ui.draw()
  buffer:drawOn(function ()
    widgets_run("draw", {ui})
  end)
  buffer:draw()
end

function ui.update(dt)
  widgets_run("update", {dt})
end

function ui.keypressed(key)
  widgets_run("keypressed", {key})
end

function ui.mousepressed(mouseX, mouseY, button, istouch, presses)
  local x, y = ui.getWorldCoords(mouseX, mouseY)
  widgets_run("mousepressed", {x, y, button, istouch, presses})
end

function ui.mousemoved(mouseX, mouseY)
  local x, y = ui.getWorldCoords(mouseX, mouseY)
  widgets_run("mousemoved", {x, y})
end

function ui.mousereleased(mouseX, mouseY, button, istouch, presses)
  local x, y = ui.getWorldCoords(mouseX, mouseY)
  widgets_run("mousereleased", {x, y, button, istouch, presses})
end

function ui.wheelmoved(x, y)
  widgets_run("wheelmoved", {x, y})
end

function ui.touchpressed(id, mouseX, mouseY, dx, dy, pressure)
  local x, y = ui.getWorldCoords(mouseX, mouseY)
  widgets_run("touchpressed", {x, y})
end

return ui
