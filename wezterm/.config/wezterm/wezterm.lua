local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Disable the close confirmation dialog completely
config.window_close_confirmation = 'NeverPrompt'

return config
