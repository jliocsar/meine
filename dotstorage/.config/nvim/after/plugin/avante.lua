local avante = require 'avante'

avante.setup {
  provider = 'openai',
  windows = {
    height = 100,
    input = {
      height = 4,
    },
    sidebar_header = {
      rounded = false,
    },
    ask = {
      border = { ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ' },
    },
  },
}
