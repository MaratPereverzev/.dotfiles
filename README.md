# Personal terminal setup for Linux (GNU Stow)

| Tool | Role |
| --- | --- |
| Zsh + Oh My Zsh | Shell |
| Starship | Prompt |
| Kitty | Terminal emulator |
| tmux | Multiplexer |
| Neovim + LazyVim | Editor |
| Yazi | File manager |
| GNU Stow | Symlink manager |

## Install

```bash
sudo apt install zsh kitty tmux xclip neovim yazi stow fonts-jetbrains-mono \
  starship zoxide eza bat fd-find ripgrep atuin

chsh -s $(which zsh)
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

git clone https://github.com/your-username/dotfiles.git ~/.dotfiles
cd ~/.dotfiles && stow .
```

Then in tmux: `Ctrl+b` `Shift+I` to fetch `tmux-resurrect`/`tmux-continuum` via TPM.

Optional Node (only if needed):
```bash
PROFILE=/dev/null NVM_DIR="$HOME/.config/nvm" bash -c "$(curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh)"
```

Neovim: LazyVim installs its own plugins on first launch.

## Shell

| Tool | Replaces | Notes |
| --- | --- | --- |
| `starship` | OMZ theme | `~/.config/starship.toml` |
| `zoxide` | OMZ `z` plugin | `z <name>` jumps to a matching dir |
| `eza` | `ls` | aliased `ls`/`ll`/`la`/`lt` |
| `bat` | `cat`/`man` pager | Ubuntu binary is `batcat`, aliased to `bat`/`cat` |
| `fd-find` | `find` | Ubuntu binary is `fdfind`, aliased to `fd` |
| `atuin` | history search | `Ctrl+R`, local-only |
| `fzf` | — | `eval "$(fzf --zsh)"`: `Ctrl+T`/`Ctrl+R`/`**<Tab>` |

Plus: `cl`/`cls` → `clear`. Active OMZ plugins: `git`, `zsh-autosuggestions`, `zsh-syntax-highlighting`. Vi mode (`bindkey -v`, must load before fzf/atuin/starship or it wipes their keybindings). History: `$XDG_STATE_HOME/zsh/history`, shared across sessions, dedup'd.

## System controls

| Alias | Runs | Notes |
| --- | --- | --- |
| `wifi` | `wifi-menu` (`.local/bin/`) | fzf menu over `nmcli`: connect/switch, disconnect, forget, show config |
| `bt` | `bt-menu` (`.local/bin/`) | fzf menu over `bluetoothctl`: connect/disconnect/pair/forget/scan/power/info |
| `sound` | `pulsemixer` | needs `sudo apt install pulsemixer` |

Both custom menus share one shape with `wifi-menu`/`bt-menu`: pick an action from the top menu, act, land back on the menu (Esc there to quit). `Ctrl+J`/`Ctrl+K` move up/down everywhere so plain letters stay free for typing a filter. Neither script has a `.sh` extension — see `.stow-local-ignore`.

## Kitty

- Font: JetBrains Mono Nerd Font, size 13.
- `cursor_trail` — animated cursor.
- Monochrome background/cursor/tabs/borders; `color0`-`color15` untouched so `ls`/`git`/`bat` output stays full-color.

## tmux

No prefix key — everything is `Alt`-modified directly.

| Key | Action |
| --- | --- |
| `Alt+n` | New window |
| `Alt+L`/`Alt+H` | Next/prev window |
| `Alt+{`/`Alt+}` | Swap window left/right |
| `Alt+Q` | Kill window |
| `Alt+Enter` | Split horizontal |
| `Alt+\` | Split vertical |
| `Alt+h/j/k/l` | Move focus |
| `Alt+,`/`.`/`K`/`J` | Move focus + swap pane |
| `Ctrl+Alt+h/j/k/l` | Resize pane |
| `Alt+f` | Zoom pane |
| `Alt+q` | Kill pane |
| `Alt+[` | Copy mode |
| `Alt+p` | Paste (via `xclip`) |
| `Alt+BSpace` | Clear scroll history |
| `Alt+R` | Reload config |

Copy mode (vi-style): `v` select, `y` copy to system clipboard, `Escape` cancel.

Mouse is on (click to select, drag to resize). Plugins via TPM: `tmux-resurrect` + `tmux-continuum` (autosave every 15 min, restore on start). Note: since this config lives at `~/.config/tmux/tmux.conf`, TPM installs plugins under `~/.config/tmux/plugins/`, not `~/.tmux/plugins/` (only TPM itself lives there).

Status bar (right side, monochrome, only shows when relevant):
- `SSH` — active pane is running `ssh` (warm accent, so you notice you're on a remote host)
- `ZOOM` — a pane in the window is zoomed
- `saved HH:MM` / `autosave off` / `not saved yet` — from `scripts/tmux-last-save`, reads tmux-continuum's real save timestamp (its own `#{continuum_status}` only shows the configured interval, not a time)

## Neovim

LazyVim extras (`lazyvim.json`): `ai.claudecode`, `coding.yanky`, `editor.fzf`+`editor.telescope`, `editor.inc-rename`, `editor.dial`, `formatting.black`, `formatting.prettier`, `linting.eslint`, `lang.*` (Go, Python, TS, SQL, YAML, JSON, TOML, Markdown, Terraform, Ansible, Docker, Tailwind, Git).

Colorscheme: `tokyonight` (`night`) + monochrome chrome override, see [Theme](#theme).

`init.lua` also prepends `~/.local/node/bin`, `~/.local/go/bin`, `~/.local/bin` to `PATH` (for GUI launches with a stripped env) and auto-reloads buffers changed on disk (`autoread`/`checktime`).

## Yazi

`h/j/k/l` remapped for vim-style navigation (`keymap.toml`).

## Theme

Chrome (window/status bar backgrounds, borders, popups) is black/grey/white everywhere. Content and state stay colored:

- **Neovim**: `tokyonight` drives syntax highlighting; a `ColorScheme` autocmd repaints only chrome groups (statusline, floats, tabs, Telescope/fzf-lua/which-key/snacks, mini.icons) grey. `Diagnostic*`/`GitSigns*` untouched.
- **Kitty**: grey background/tabs/borders; ANSI `color0`-`15` untouched.
- **tmux**: status bar bg/fg = Neovim's `Normal` group exactly (`#0d0d0d`/`#b8b8b8`); pane borders grey.
- **Starship**: `directory`/`git_branch` neutral; `character` stays green/red for success/fail, `git_status` stays yellow.
- **fzf**: grey chrome; match highlight/pointer/marker keep accent colors (blue/red/green).

## Directory structure

```
~/.dotfiles/
├── .bash_aliases        # Extra aliases for .bashrc
├── .bashrc              # Bash, kept as fallback shell
├── .vimrc               # Minimal vim config
├── .stow-local-ignore   # Files Stow skips (.git, *.md, *.sh)
├── .local/bin/
│   ├── wifi-menu        # fzf/nmcli Wi-Fi menu (no .sh, see .stow-local-ignore)
│   └── bt-menu          # fzf/bluetoothctl Bluetooth menu (same reason)
└── .config/
    ├── zsh/
    │   ├── .zshenv      # XDG paths, EDITOR, PATH
    │   └── .zshrc       # Everything else: OMZ, tools, aliases
    ├── starship.toml
    ├── kitty/
    │   └── kitty.conf
    ├── tmux/
    │   ├── tmux.conf
    │   └── scripts/
    │       └── tmux-last-save  # no .sh extension — see .stow-local-ignore
    ├── nvim/            # LazyVim
    │   ├── init.lua
    │   └── lazyvim.json
    └── yazi/
        └── keymap.toml
```

## XDG base directories

| Variable | Path | What goes here |
| --- | --- | --- |
| `XDG_CONFIG_HOME` | `~/.config` | App configs |
| `XDG_CACHE_HOME` | `~/.cache` | Disposable cache |
| `XDG_DATA_HOME` | `~/.local/share` | Persistent app data (fonts, completions, DBs) |
| `XDG_STATE_HOME` | `~/.local/state` | Shell/undo history |

Set in `.zshenv` so Zsh, Neovim, and everything else that respects XDG stays out of `$HOME`.
