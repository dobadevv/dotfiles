-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.font = wezterm.font("JetbrainsMono Nerd Font")
config.font_size = 16

config.enable_tab_bar = false

config.window_decorations = "RESIZE"

-- Fix mouse selection disappearing
config.mouse_bindings = {
	{
		event = { Down = { streak = 1, button = "Left" } },
		mods = "SHIFT",
		action = wezterm.action.SelectTextAtMouseCursor("Cell"),
	},
	{
		event = { Drag = { streak = 1, button = "Left" } },
		mods = "SHIFT",
		action = wezterm.action.ExtendSelectionToMouseCursor("Cell"),
	},
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "SHIFT",
		action = wezterm.action_callback(function(window, pane)
			window:perform_action(wezterm.action.CompleteSelection("ClipboardAndPrimarySelection"), pane)
		end),
	},
}

-- Binding clipboard to neovim
config.keys = {
	{
		key = "c",
		mods = "CMD",
		action = wezterm.action_callback(function(window, pane)
			local process = pane:get_foreground_process_name() or ""
			if process:match("nvim") then
				window:perform_action(wezterm.action.SendKey({ key = '"', mods = "" }), pane)
				window:perform_action(wezterm.action.SendKey({ key = "+", mods = "" }), pane)
				window:perform_action(wezterm.action.SendKey({ key = "y", mods = "" }), pane)
			else
				window:perform_action(wezterm.action({ CopyTo = "ClipboardAndPrimarySelection" }))
			end
		end),
	},
	{ key = "v", mods = "CMD", action = wezterm.action({ PasteFrom = "Clipboard" }) },
	{ key = "k", mods = "CMD", action = wezterm.action.ClearScrollback("ScrollbackAndViewport") },
}

-- config.window_background_opacity = 0.5
-- config.macos_window_background_blur = 50

config.color_scheme = "Catppuccin Mocha"

return config
