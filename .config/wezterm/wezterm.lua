-- Pull in the wezterm API
local ok, wezterm = pcall(require, "wezterm")
if not ok then
	print("[ ERROR ] Wezterm module not found")
	return {}
end

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.font = wezterm.font("Comic Code Ligatures", {
  weight = "Medium",
})
config.font_size = 11.0

local custom_dracula = wezterm.color.get_builtin_schemes()["Dracula"]

custom_dracula.background = "#111111"
-- custom_dracula.foreground = "#dcdccc"

config.color_schemes = {
	["Custom Dracula"] = custom_dracula,
}

-- For example, changing the color scheme:
config.color_scheme = "Custom Dracula"

config.window_padding = {
	top = 0,
	right = 0,
	bottom = 0,
	left = 0,
}

config.window_background_opacity = 0.7

-- config.hide_tab_bar_if_only_one_tab = true
config.enable_tab_bar = false

config.foreground_text_hsb = {
	hue = 1.0,
	saturation = 1.0,
	brightness = 1.0,
}


-- and finally, return the configuration to wezterm
return config
