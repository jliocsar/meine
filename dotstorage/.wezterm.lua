local wezterm = require 'wezterm'

local config = wezterm.config_builder()
-- local plugin = wezterm.plugin
local act = wezterm.action
local home = wezterm.home_dir
local _, stdout = wezterm.run_child_process { 'zsh', '-c', '-i', '"alias"' }
local aliases_lut = {}

if stdout then
  for line in stdout:gmatch '[^\n]*\n?' do
    local alias, value = line:match '(.*)=(.*)'
    value = value:gsub('^[\'"]', ''):gsub('[\'"]', '')
    aliases_lut[alias] = value
  end
end

-- # Events
wezterm.on('trigger-aether', function(window, pane)
  -- Open a new window running vim and tell it to open the file
  window:perform_action(
    act.SpawnCommandInNewTab {
      label = 'Aether',
      args = { 'aether' },
      cwd = home .. '/Projects/aether',
      set_environment_variables = {
        EDITOR = 'nvim',
      },
    },
    pane
  )
end)

config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.2,
}

-- ## Font Configuration
-- Turn off ligatures, shit's disgusting
config.harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }
config.font_size = 11
config.line_height = 1
-- config.font = wezterm.font('Victor Mono', {
config.font = wezterm.font('Victor Mono', {
  weight = 500,
})

-- ## Key Bindings
config.keys = {
  -- Trigger Aether for prompting
  {
    key = 'i',
    mods = 'CTRL|SHIFT',
    action = act.EmitEvent 'trigger-aether',
  },
  -- Use Vim-like motions to scroll up and down
  {
    key = 'j',
    mods = 'CTRL|SHIFT',
    action = act.ScrollByPage(0.1),
  },
  {
    key = 'k',
    mods = 'CTRL|SHIFT',
    action = act.ScrollByPage(-0.1),
  },
  {
    key = 'd',
    mods = 'CTRL|SHIFT',
    action = act.ScrollByPage(0.5),
  },
  {
    key = 'u',
    mods = 'CTRL|SHIFT',
    action = act.ScrollByPage(-0.5),
  },
}

-- ## Colors
config.color_scheme = 'Circus (base16)'
config.window_background_gradient = {
  -- Can be "Vertical" or "Horizontal".  Specifies the direction
  -- in which the color gradient varies.  The default is "Horizontal",
  -- with the gradient going from left-to-right.
  -- Linear and Radial gradients are also supported; see the other
  -- examples below
  orientation = {
    Radial = {
      -- Specifies the x coordinate of the center of the circle,
      -- in the range 0.0 through 1.0.  The default is 0.5 which
      -- is centered in the X dimension.
      cx = 1,

      -- Specifies the y coordinate of the center of the circle,
      -- in the range 0.0 through 1.0.  The default is 0.5 which
      -- is centered in the Y dimension.
      cy = 1.25,

      -- Specifies the radius of the notional circle.
      -- The default is 0.5, which combined with the default cx
      -- and cy values places the circle in the center of the
      -- window, with the edges touching the window edges.
      -- Values larger than 1 are possible.
      radius = 1.5,
    },
  },

  -- Specifies the set of colors that are interpolated in the gradient.
  -- Accepts CSS style color specs, from named colors, through rgb
  -- strings and more
  colors = {
    'hsla(230, 0.01, 0.04, 90%)',
    'hsla(228, 0.012, 0.12, 90%)',
  },

  -- Instead of specifying `colors`, you can use one of a number of
  -- predefined, preset gradients.
  -- A list of presets is shown in a section below.
  -- preset = "Warm",

  -- Specifies the interpolation style to be used.
  -- "Linear", "Basis" and "CatmullRom" as supported.
  -- The default is "Linear".
  interpolation = 'Linear',

  -- How the colors are blended in the gradient.
  -- "Rgb", "LinearRgb", "Hsv" and "Oklab" are supported.
  -- The default is "Rgb".
  blend = 'Rgb',

  -- To avoid vertical color banding for horizontal gradients, the
  -- gradient position is randomly shifted by up to the `noise` value
  -- for each pixel.
  -- Smaller values, or 0, will make bands more prominent.
  -- The default value is 64 which gives decent looking results
  -- on a retina macbook pro display.
  noise = 64,

  -- By default, the gradient smoothly transitions between the colors.
  -- You can adjust the sharpness by specifying the segment_size and
  -- segment_smoothness parameters.
  -- segment_size configures how many segments are present.
  -- segment_smoothness is how hard the edge is; 0.0 is a hard edge,
  -- 1.0 is a soft edge.

  -- segment_size = 11,
  -- segment_smoothness = 0.0,
}
config.colors = {
  tab_bar = {
    -- The color of the strip that goes along the top of the window
    -- (does not apply when fancy tab bar is in use)
    background = 'rgba(0, 0, 0, 0.1)',

    -- The active tab is the one that has focus in the window
    active_tab = {
      -- The color of the background area for the tab
      bg_color = 'rgba(0, 0, 0, 0.1)',
      -- The color of the text for the tab
      fg_color = '#ccc',

      -- Specify whether you want "Half", "Normal" or "Bold" intensity for the
      -- label shown for this tab.
      -- The default is "Normal"
      intensity = 'Normal',

      -- Specify whether you want "None", "Single" or "Double" underline for
      -- label shown for this tab.
      -- The default is "None"
      underline = 'None',

      -- Specify whether you want the text to be italic (true) or not (false)
      -- for this tab.  The default is false.
      italic = false,

      -- Specify whether you want the text to be rendered with strikethrough (true)
      -- or not for this tab.  The default is false.
      strikethrough = false,
    },

    -- Inactive tabs are the tabs that do not have focus
    inactive_tab = {
      bg_color = 'rgba(0, 0, 0, 0.1)',
      fg_color = '#666',

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `inactive_tab`.
    },

    -- You can configure some alternate styling when the mouse pointer
    -- moves over inactive tabs
    inactive_tab_hover = {
      bg_color = 'rgba(255, 255, 255, 0.025)',
      fg_color = '#666',
      italic = false,

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `inactive_tab_hover`.
    },

    -- The new tab button that let you create new tabs
    new_tab = {
      bg_color = 'rgba(255, 255, 255, 0.025)',
      fg_color = '#666',

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `new_tab`.
    },

    -- You can configure some alternate styling when the mouse pointer
    -- moves over the new tab button
    new_tab_hover = {
      bg_color = '#999',
      fg_color = 'rgba(0, 0, 0, 0.1)',
      italic = false,

      -- The same options that were listed under the `active_tab` section above
      -- can also be used for `new_tab_hover`.
    },
  },
}

-- ## Tabs Configuration
config.enable_tab_bar = true
config.tab_bar_at_bottom = true
config.use_fancy_tab_bar = false
config.tab_max_width = 32

-- This function returns the suggested title for a tab.
-- It prefers the title that was set via `tab:set_title()`
-- or `wezterm cli set-tab-title`, but falls back to the
-- title of the active pane in that tab.
function custom_tab_title(title, foreground_process_name, working_dir)
  local working_dir_str = tostring(working_dir)

  -- Return a custom tab title when running Aether
  if
    foreground_process_name == '/usr/bin/perl'
    and working_dir_str:match '/Projects/aether$'
  then
    return 'aether'
  end

  local alias = aliases_lut[title]
  if alias then
    return alias
  end

  return title
end

function tab_title(tab_info)
  local title = tab_info.tab_title
  -- if the tab title is explicitly set, take that
  if title and #title > 0 then
    return title
  end

  local tab_index = tab_info.tab_index + 1
  local active_pane = tab_info.active_pane
  local active_pane_foreground_process_name = active_pane.foreground_process_name
  local active_pane_working_dir = active_pane.current_working_dir
  local custom_title = custom_tab_title(
    active_pane.title,
    active_pane_foreground_process_name,
    active_pane_working_dir
  )

  return tab_index .. ': ' .. custom_title
end

wezterm.on('format-tab-title', function(tab, tabs, panes, _config, hover, max_width)
  local title = tab_title(tab)
  return {
    { Text = ' ' .. title .. ' ' },
  }
end)

-- ## Plugins

return config
