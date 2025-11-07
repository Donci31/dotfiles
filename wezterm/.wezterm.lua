local wezterm = require("wezterm")

local config = wezterm.config_builder()
local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
	if mux then
		local _, _, window = mux.spawn_window(cmd or {})
		window:gui_window():maximize()
	end
end)

config.default_cwd = "D:/BME_cuccok/MSC-3-Felev/dipterv"
config.default_prog = { "nu" }

config.disable_default_mouse_bindings = false

config.font_size = 14
config.line_height = 1.2
config.color_scheme = "Dracula (Official)"
config.font = wezterm.font("JetBrains Mono")

config.window_background_opacity = 0.85
config.enable_kitty_graphics = true

config.colors = {
	cursor_bg = "#8BE9FD",
	cursor_border = "#8BE9FD",
}

config.window_decorations = "RESIZE"
config.enable_tab_bar = false

config.keys = {
	{
		key = "f",
		mods = "CTRL",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "f",
		mods = "CTRL|SHIFT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
}

return config
