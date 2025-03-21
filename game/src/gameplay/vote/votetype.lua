local palette = require("assets.palette")

local votetypes = {
  support = {
    label = "support",
    color = palette['green'][2],
    highlight = palette['green'][1],
    progress = true,
  },
  oppose = {
   label = "oppose",
   color = palette['orange'][3],
   highlight = palette['orange'][2],
   progress = true,
  },
  tie = {
    label = "tie",
    color = palette['blue'][3],
    highlight = palette['blue'][2],
    progress = false,
  }
}

return votetypes
