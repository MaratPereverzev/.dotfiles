# Claude Code — конфиг statusline

Файлы для переноса кастомного statusline Claude Code на другой ПК.

## Что внутри
- `statusline-command.sh` — сам скрипт statusline (имя чата, модель, % контекста, лимиты 5h/7d с цветовой индикацией).
- `settings-statusline-snippet.json` — кусок `~/.claude/settings.json`, который подключает этот скрипт.

## Как установить на новом ПК
1. Скопировать скрипт:
   ```bash
   cp statusline-command.sh ~/.claude/statusline-command.sh
   chmod +x ~/.claude/statusline-command.sh
   ```
2. Открыть `~/.claude/settings.json` на новом ПК и добавить/смержить туда ключ `statusLine` из `settings-statusline-snippet.json`:
   ```json
   "statusLine": {
     "type": "command",
     "command": "bash ~/.claude/statusline-command.sh"
   }
   ```
   Если домашняя папка на новом ПК называется иначе (не `/home/user`), либо пропишите свой путь, либо используйте `~/.claude/statusline-command.sh` — так надёжнее.
3. Требуется `jq` (скрипт парсит JSON из stdin). Установить при необходимости:
   ```bash
   sudo apt install jq
   ```
4. Перезапустить Claude Code — statusline должен появиться внизу.
