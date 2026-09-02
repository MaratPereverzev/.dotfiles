-- Editor: navigation, pickers, motions.
-- Picker is fzf (see options.lua and lazyvim.json).
return {
    {
        "ibhagwan/fzf-lua",
        -- Show dotfiles (already fzf-lua's default) and gitignored files
        -- (like .env) too -- otherwise they're only reachable per-search via
        -- the built-in <A-h>/<A-i> toggles.
        opts = {
            files = {
                hidden = true,
                fd_opts = [[--color=never --type f --type l --hidden --no-ignore --exclude .git --exclude .jj]],
            },
        },
        keys = {
            {
                "<leader>fp",
                function()
                    require("fzf-lua").files({
                        cwd = require("lazy.core.config").options.root,
                        fd_opts = "--color=never --type f --hidden --follow --exclude .git",
                    })
                end,
                desc = "Find Plugin File",
            },
        },
    },
}
