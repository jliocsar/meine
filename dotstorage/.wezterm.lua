local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'Framer'
config.font = wezterm.font('Victor Mono', {
    weight = 'DemiBold'
})
config.enable_tab_bar = false

return config
