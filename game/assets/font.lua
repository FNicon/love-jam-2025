love.graphics.setDefaultFilter("nearest", "nearest", 1)
love.graphics.setLineStyle("rough")
return {
  default = love.graphics.newFont("assets/m6x11.ttf", 16, "mono"),
  title = love.graphics.newFont("assets/m6x11.ttf", 32, "mono")
}
