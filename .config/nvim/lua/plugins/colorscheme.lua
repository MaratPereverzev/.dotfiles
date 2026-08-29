-- Colorscheme.
-- Base theme (tokyonight) keeps full-color syntax highlighting for code/content.
-- The overrides below force only the *interface* chrome (statusline, sidebar,
-- popups, borders, tabs, icons) to near-black/grey -- code, buffer text, and
-- semantic state/action colors (diagnostics, git signs) are left untouched.
local mono = {
    bg0 = "#0d0d0d", -- floor: main window / sidebar / popup background
    bg1 = "#161616", -- raised: floats, pmenu, inactive tabs
    bg2 = "#202020", -- selected row / active statusline
    bg3 = "#2b2b2b", -- selected item in popups
    border = "#404040",
    fg0 = "#b8b8b8", -- primary chrome text (grey, not white)
    fg1 = "#8c8c8c", -- secondary chrome text
    fg2 = "#666666", -- dim chrome text (line numbers, inactive tabs)
}

local function apply_monochrome_ui()
    local hl = vim.api.nvim_set_hl

    -- Core window chrome
    hl(0, "Normal", { bg = mono.bg0, fg = mono.fg0 })
    hl(0, "NormalNC", { bg = mono.bg0, fg = mono.fg0 })
    hl(0, "NormalFloat", { bg = mono.bg1, fg = mono.fg0 })
    hl(0, "FloatBorder", { bg = mono.bg1, fg = mono.border })
    hl(0, "FloatTitle", { bg = mono.bg1, fg = mono.fg0, bold = true })
    hl(0, "SignColumn", { bg = mono.bg0 })
    hl(0, "LineNr", { bg = mono.bg0, fg = mono.fg2 })
    hl(0, "CursorLineNr", { bg = mono.bg0, fg = mono.fg0, bold = true })
    hl(0, "CursorLine", { bg = mono.bg1 })
    hl(0, "ColorColumn", { bg = mono.bg1 })
    hl(0, "VertSplit", { fg = mono.border, bg = mono.bg0 })
    hl(0, "WinSeparator", { fg = mono.border, bg = mono.bg0 })
    hl(0, "WinBar", { bg = mono.bg0, fg = mono.fg1 })
    hl(0, "WinBarNC", { bg = mono.bg0, fg = mono.fg2 })

    -- Status/tab line
    hl(0, "StatusLine", { bg = mono.bg2, fg = mono.fg0 })
    hl(0, "StatusLineNC", { bg = mono.bg1, fg = mono.fg2 })
    hl(0, "TabLine", { bg = mono.bg1, fg = mono.fg2 })
    hl(0, "TabLineSel", { bg = mono.bg2, fg = mono.fg0, bold = true })
    hl(0, "TabLineFill", { bg = mono.bg0 })

    -- Completion / popup menu
    hl(0, "Pmenu", { bg = mono.bg1, fg = mono.fg0 })
    hl(0, "PmenuSel", { bg = mono.bg3, fg = mono.fg0, bold = true })
    hl(0, "PmenuSbar", { bg = mono.bg2 })
    hl(0, "PmenuThumb", { bg = mono.border })
    hl(0, "MsgArea", { bg = mono.bg0, fg = mono.fg0 })

    -- Telescope
    hl(0, "TelescopeNormal", { bg = mono.bg1, fg = mono.fg0 })
    hl(0, "TelescopeBorder", { bg = mono.bg1, fg = mono.border })
    hl(0, "TelescopeTitle", { bg = mono.bg1, fg = mono.fg0, bold = true })
    hl(0, "TelescopePromptNormal", { bg = mono.bg2, fg = mono.fg0 })
    hl(0, "TelescopePromptBorder", { bg = mono.bg2, fg = mono.border })
    hl(0, "TelescopePromptTitle", { bg = mono.bg2, fg = mono.fg0, bold = true })
    hl(0, "TelescopePreviewTitle", { bg = mono.bg1, fg = mono.fg0, bold = true })
    hl(0, "TelescopeSelection", { bg = mono.bg3, fg = mono.fg0 })
    hl(0, "TelescopeSelectionCaret", { bg = mono.bg3, fg = mono.fg0 })

    -- fzf-lua
    hl(0, "FzfLuaNormal", { bg = mono.bg1, fg = mono.fg0 })
    hl(0, "FzfLuaBorder", { bg = mono.bg1, fg = mono.border })
    hl(0, "FzfLuaTitle", { bg = mono.bg1, fg = mono.fg0, bold = true })
    hl(0, "FzfLuaTitleFlags", { bg = mono.bg1, fg = mono.fg1 })
    hl(0, "FzfLuaPreviewNormal", { bg = mono.bg1, fg = mono.fg0 })
    hl(0, "FzfLuaPreviewBorder", { bg = mono.bg1, fg = mono.border })
    hl(0, "FzfLuaPreviewTitle", { bg = mono.bg1, fg = mono.fg0, bold = true })
    hl(0, "FzfLuaHelpNormal", { bg = mono.bg1, fg = mono.fg0 })
    hl(0, "FzfLuaHelpBorder", { bg = mono.bg1, fg = mono.border })
    hl(0, "FzfLuaCursorLine", { bg = mono.bg2 })
    hl(0, "FzfLuaFzfNormal", { bg = mono.bg1, fg = mono.fg0 })
    hl(0, "FzfLuaFzfBorder", { bg = mono.bg1, fg = mono.border })
    hl(0, "FzfLuaFzfCursorLine", { bg = mono.bg2 })
    hl(0, "FzfLuaFzfGutter", { bg = mono.bg1 })
    hl(0, "FzfLuaFzfPointer", { fg = mono.fg0 })
    hl(0, "FzfLuaFzfMarker", { fg = mono.fg0 })
    hl(0, "FzfLuaBackdrop", { bg = mono.bg0 })

    -- which-key
    hl(0, "WhichKeyNormal", { bg = mono.bg1, fg = mono.fg0 })
    hl(0, "WhichKeyBorder", { bg = mono.bg1, fg = mono.border })
    hl(0, "WhichKeyTitle", { bg = mono.bg1, fg = mono.fg0, bold = true })

    -- snacks.nvim (dashboard, notifier, picker chrome, terminal, input)
    hl(0, "SnacksDashboardNormal", { bg = mono.bg0, fg = mono.fg0 })
    hl(0, "SnacksNormal", { bg = mono.bg1, fg = mono.fg0 })
    hl(0, "SnacksWinBar", { bg = mono.bg1, fg = mono.fg1 })
    hl(0, "SnacksBackdrop", { bg = mono.bg0 })
    hl(0, "SnacksInputTitle", { bg = mono.bg1, fg = mono.fg0, bold = true })
    hl(0, "SnacksPickerBox", { bg = mono.bg1, fg = mono.border })

    -- snacks.dashboard defines its own field-specific groups (logo, menu
    -- icons/labels/shortcut keys, footer) that default-link to colorful
    -- base groups (Title/Special/Number/NonText) -- override each directly.
    hl(0, "SnacksDashboardHeader", { fg = mono.fg0, bold = true })
    hl(0, "SnacksDashboardTitle", { fg = mono.fg0, bold = true })
    hl(0, "SnacksDashboardDesc", { fg = mono.fg0 })
    hl(0, "SnacksDashboardIcon", { fg = mono.fg1 })
    hl(0, "SnacksDashboardKey", { fg = mono.fg1 })
    hl(0, "SnacksDashboardSpecial", { fg = mono.fg1 })
    hl(0, "SnacksDashboardFooter", { fg = mono.fg2 })
    hl(0, "SnacksDashboardFile", { fg = mono.fg0 })
    hl(0, "SnacksDashboardDir", { fg = mono.fg2 })

    -- mini.icons: these hue groups are purely decorative per-filetype icon
    -- colors (file explorer/picker glyphs), not semantic state -- grey them
    -- out too. Diagnostic*/GitSigns* groups are deliberately left alone below.
    for _, group in ipairs({
        "MiniIconsAzure",
        "MiniIconsBlue",
        "MiniIconsCyan",
        "MiniIconsGreen",
        "MiniIconsGrey",
        "MiniIconsOrange",
        "MiniIconsPurple",
        "MiniIconsRed",
        "MiniIconsYellow",
    }) do
        hl(0, group, { fg = mono.fg1 })
    end

    -- Explicitly NOT overridden -- these carry meaning and stay colorful:
    -- DiagnosticError/Warn/Info/Hint (+ Underline/VirtualText/Sign/Floating variants)
    -- GitSignsAdd/Change/Delete
end

return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {
            style = "night",
        },
        config = function(_, opts)
            require("tokyonight").setup(opts)
            vim.api.nvim_create_autocmd("ColorScheme", {
                pattern = "tokyonight*",
                callback = apply_monochrome_ui,
            })
        end,
    },

    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "tokyonight",
        },
    },
}
