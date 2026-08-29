-- Editor: navigation, pickers, motions.
-- Picker is fzf (see options.lua and lazyvim.json).
return {
    {
        "ibhagwan/fzf-lua",
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
