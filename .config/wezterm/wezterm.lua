local wezterm = require 'wezterm'
local act = wezterm.action

return {
    font_size = 10,
    dpi = 192,
    --color_scheme = 'nightfox',
    color_scheme = 'Monokai Pro (Gogh)',
    hide_tab_bar_if_only_one_tab = true,
    enable_wayland = true,
    window_background_opacity = 1,
    window_padding = {
        left = 5,
        right =5,
        top = 5,
        bottom = 5,
    },
    --font = wezterm.font('DejaVu Sans', { weight = 'Regular' }),
    font = wezterm.font_with_fallback {
        'JetBrains Mono',
        { family = 'DejaVu Sans', weight = 'Regular' },
        'Symbola',
        'MS Reference Sans Serif',
        'Segoe UI Symbol',
        'Segoe MDL2 Assets',
        --'Noto Color Emoji',
        'Font Awesome 6 Free',
        'Font Awesome 6 Free Solid',
        'Font Awesome 6 Brands',
        'Font Awesome v4 Compatibility',
        'Symbols Nerd Font',
    },
    keys = {
        { key = 'V', mods = 'ALT', action = act.PasteFrom 'Clipboard' },
        { key = 'V', mods = 'CTRL|SHIFT', action = act.PasteFrom 'Clipboard' },
        {
            key = 'H',
            mods = 'SHIFT|CTRL',
            action = wezterm.action.Search { Regex = '!> (.*)$' },
        }
    },
}
