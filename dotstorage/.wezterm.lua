local wezterm = require 'wezterm'
local config = wezterm.config_builder()

config.color_scheme = 'darkmoss (base16)'
config.font = wezterm.font('Victor Mono', {
    weight = 'DemiBold'
})
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
        '#030303',
        '#151918',
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
config.enable_tab_bar = false

return config
