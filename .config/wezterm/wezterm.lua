local wezterm = require 'wezterm'
local act = wezterm.action

return {
    font_size = 10,
    dpi = 192,
    --color_scheme = 'nightfox',
    --color_scheme = 'Monokai Pro (Gogh)',
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

    colors = {
        -- The default text color
        foreground = '#80E0A7',
        -- The default background color
        background = '#252a36',

        -- Overrides the cell background color when the current cell is occupied by the
        -- cursor and the cursor style is set to Block
        cursor_bg = '#52ad70',
        -- Overrides the text color when the current cell is occupied by the cursor
        cursor_fg = 'black',
        -- Specifies the border color of the cursor when the cursor style is set to Block,
        -- or the color of the vertical or horizontal bar when the cursor style is set to
        -- Bar or Underline.
        cursor_border = '#52ad70',

        -- the foreground color of selected text
        selection_fg = 'black',
        -- the background color of selected text
        selection_bg = '#fffacd',

        -- The color of the scrollbar "thumb"; the portion that represents the current viewport
        scrollbar_thumb = '#222222',

        -- The color of the split lines between panes
        split = '#444444',

        ansi = {
            '#000000',
            '#36639B',
            '#38B169',
            '#3B968C',
            '#F65C4D',
            '#D3427D',
            '#F6A728',
            '#B4B4B4',
        },
        brights = {
            '#425563',
            '#66C7F9',
            '#AEF158',
            '#A3E9F1',
            '#FF9287',
            '#9C83F8',
            '#FFDE31',
            '#FFFFFF',
        },

        -- Arbitrary colors of the palette in the range from 16 to 255
        indexed = { [136] = '#af8700' },

        -- Since: 20220319-142410-0fcdea07
        -- When the IME, a dead key or a leader key are being processed and are effectively
        -- holding input pending the result of input composition, change the cursor
        -- to this color to give a visual cue about the compose state.
        compose_cursor = 'orange',

        -- Colors for copy_mode and quick_select
        -- available since: 20220807-113146-c2fee766
        -- In copy_mode, the color of the active text is:
        -- 1. copy_mode_active_highlight_* if additional text was selected using the mouse
        -- 2. selection_* otherwise
        copy_mode_active_highlight_bg = { Color = '#000000' },
        -- use `AnsiColor` to specify one of the ansi color palette values
        -- (index 0-15) using one of the names "Black", "Maroon", "Green",
        --  "Olive", "Navy", "Purple", "Teal", "Silver", "Grey", "Red", "Lime",
        -- "Yellow", "Blue", "Fuchsia", "Aqua" or "White".
        copy_mode_active_highlight_fg = { AnsiColor = 'Black' },
        copy_mode_inactive_highlight_bg = { Color = '#52ad70' },
        copy_mode_inactive_highlight_fg = { AnsiColor = 'White' },

        quick_select_label_bg = { Color = 'peru' },
        quick_select_label_fg = { Color = '#ffffff' },
        quick_select_match_bg = { AnsiColor = 'Navy' },
        quick_select_match_fg = { Color = '#ffffff' },
    }
}
