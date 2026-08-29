-- Prepend ~/.local/bin and ~/.local/node/bin so Mason can find npm, fzf, fd, rg, go, etc.
-- Neovim launched from a GUI/desktop shortcut often inherits a stripped PATH.
do
    local home = vim.uv.os_homedir()
    local prepend = home .. "/.local/node/bin:" .. home .. "/.local/go/bin:" .. home .. "/.local/bin:"
    if not vim.env.PATH:find(home .. "/.local/node/bin", 1, true) then
        vim.env.PATH = prepend .. vim.env.PATH
    end
end

require("config.lazy")

vim.opt.clipboard = "unnamedplus"
vim.opt.autoread = true

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    pattern = "*",
    callback = function()
        if vim.fn.mode() ~= "c" then
            vim.cmd("checktime")
        end
    end,
})
