local palette = require("assets.palette")

local votetypes = {
  support = {
    label = "support",
    color = palette['green'][3],
    progress = true,
  },
  oppose = {
   label = "oppose",
   color = palette['orange'][3],
   progress = true,
  },
  tie = {
    label = "tie",
    color = palette['blue'][3],
    progress = false,
  }
}

return votetypes
