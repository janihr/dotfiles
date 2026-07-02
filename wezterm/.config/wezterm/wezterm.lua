local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Disable the close confirmation dialog completely
config.window_close_confirmation = 'NeverPrompt'

-- advanced keyboard protocol
config.enable_kitty_keyboard = true

return config
