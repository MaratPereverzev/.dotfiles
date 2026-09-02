-- UI: statusline, dashboard, notifications, icons.
-- Override LazyVim's UI plugins or add new ones here.
return {
    -- Only surface WARN/ERROR notifications; hide INFO chatter like
    -- mason's "installing ..." messages. vim.notify is routed through
    -- the snacks notifier in LazyVim.
    {
        "folke/snacks.nvim",
        opts = {
            notifier = {
                level = vim.log.levels.WARN,
            },
            -- Explorer (<leader>e) hides dotfiles and gitignored files by
            -- default; show both. Still togglable per-session with
            -- Shift+H/Shift+I inside the explorer.
            picker = {
                sources = {
                    explorer = {
                        hidden = true,
                        ignored = true,
                    },
                },
            },
        },
    },

    -- Example: append a component to lualine.
    -- {
    --     "nvim-lualine/lualine.nvim",
    --     opts = function(_, opts)
    --         table.insert(opts.sections.lualine_x, { "", color = { fg = "#a6e3a1" } })
    --     end,
    -- },
}
