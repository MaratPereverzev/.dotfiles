#!/usr/bin/env bash
# Claude Code status line — chat name, model, context usage, session limit, weekly limit

input=$(cat)

# 1. Chat name (session name if set, otherwise session id truncated)
chat_name=$(echo "$input" | jq -r '.session_name // empty')
if [ -z "$chat_name" ]; then
    session_id=$(echo "$input" | jq -r '.session_id // empty')
    chat_name="${session_id:0:8}"
else
    # Trim to first 2 words + "..." if the name has more than 2 words
    word_count=$(echo "$chat_name" | wc -w | tr -d ' ')
    if [ "$word_count" -gt 2 ]; then
        first_two=$(echo "$chat_name" | awk '{print $1, $2}')
        chat_name="${first_two}..."
    fi
fi

# 2. Model display name
model=$(echo "$input" | jq -r '.model.display_name // empty')

# 3. Context usage percentage used
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')

# 4. 5-hour session rate limit
five_hour_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_hour_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')

# 5. 7-day weekly rate limit
seven_day_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_day_resets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

# Helper: format seconds remaining as natural time
# For 5-hour window: "4h 30m" style (hours + minutes)
# For 7-day window: "2d 5h" style when >=1 day, "4h 30m" otherwise
fmt_time_short() {
    local diff="$1"
    if [ "$diff" -le 0 ]; then
        echo "0m"
        return
    fi
    local total_mins=$(( diff / 60 ))
    local hrs=$(( total_mins / 60 ))
    local mins=$(( total_mins % 60 ))
    if [ "$hrs" -gt 0 ] && [ "$mins" -gt 0 ]; then
        echo "${hrs}h ${mins}m"
    elif [ "$hrs" -gt 0 ]; then
        echo "${hrs}h"
    else
        echo "${mins}m"
    fi
}

fmt_time_long() {
    local diff="$1"
    if [ "$diff" -le 0 ]; then
        echo "0m"
        return
    fi
    local total_mins=$(( diff / 60 ))
    local total_hrs=$(( total_mins / 60 ))
    local days=$(( total_hrs / 24 ))
    local hrs=$(( total_hrs % 24 ))
    local mins=$(( total_mins % 60 ))
    if [ "$days" -gt 0 ] && [ "$hrs" -gt 0 ]; then
        echo "${days}d ${hrs}h"
    elif [ "$days" -gt 0 ]; then
        echo "${days}d"
    elif [ "$hrs" -gt 0 ] && [ "$mins" -gt 0 ]; then
        echo "${hrs}h ${mins}m"
    elif [ "$hrs" -gt 0 ]; then
        echo "${hrs}h"
    else
        echo "${mins}m"
    fi
}

secs_until() {
    local resets_at="$1"
    local now
    now=$(date +%s)
    local diff=$(( resets_at - now ))
    echo "$diff"
}

# Helper: strip ANSI escape sequences to get visible length
visible_length() {
    local str="$1"
    echo "$str" | sed 's/\x1b\[[0-9;]*m//g' | wc -c | tr -d ' '
}

# Build parts array with their strings
parts=()

[ -n "$chat_name" ] && parts+=("$chat_name")
[ -n "$model" ]     && parts+=("$model")

# Helper: apply usage-based color gradient to a label string.
# Coloring starts at 50% and intensifies toward red at 100%.
#   0-49%:  no color
#  50-64%:  yellow
#  65-79%:  orange-yellow
#  80-89%:  orange
#  90-99%:  orange-red
#   100%:   bold red
colorize_usage() {
    local pct_int="$1"
    local label="$2"
    if [ "$pct_int" -ge 100 ]; then
        printf '\033[1;31m%s\033[0m' "$label"
    elif [ "$pct_int" -ge 90 ]; then
        printf '\033[38;5;202m%s\033[0m' "$label"
    elif [ "$pct_int" -ge 80 ]; then
        printf '\033[38;5;208m%s\033[0m' "$label"
    elif [ "$pct_int" -ge 65 ]; then
        printf '\033[38;5;214m%s\033[0m' "$label"
    elif [ "$pct_int" -ge 50 ]; then
        printf '\033[33m%s\033[0m' "$label"
    else
        printf '%s' "$label"
    fi
}

if [ -n "$used" ]; then
    used_int=$(printf '%.0f' "$used")
    ctx_str=$(colorize_usage "$used_int" "ctx: ${used_int}% used")
    parts+=("$ctx_str")
fi

if [ -n "$five_hour_pct" ]; then
    pct_int=$(printf '%.0f' "$five_hour_pct")
    if [ -n "$five_hour_resets" ]; then
        diff=$(secs_until "$five_hour_resets")
        time_str=$(fmt_time_short "$diff")
        label="5h: ${pct_int}% used, ${time_str} left"
    else
        label="5h: ${pct_int}% used"
    fi
    five_str=$(colorize_usage "$pct_int" "$label")
    parts+=("$five_str")
fi

if [ -n "$seven_day_pct" ]; then
    pct_int=$(printf '%.0f' "$seven_day_pct")
    if [ -n "$seven_day_resets" ]; then
        diff=$(secs_until "$seven_day_resets")
        time_str=$(fmt_time_long "$diff")
        label="7d: ${pct_int}% used, ${time_str} left"
    else
        label="7d: ${pct_int}% used"
    fi
    seven_str=$(colorize_usage "$pct_int" "$label")
    parts+=("$seven_str")
fi

# Smart wrapping: get terminal width, wrap blocks to next line if they don't fit
terminal_width=$(tput cols 2>/dev/null || echo 120)
separator=" | "
sep_len=${#separator}

lines=()
current_line=""
current_line_len=0

for i in "${!parts[@]}"; do
    part="${parts[$i]}"
    part_visible_len=$(($(visible_length "$part") - 1))  # -1 for newline in wc

    # Check if we need separator space (not first part on line)
    if [ -z "$current_line" ]; then
        needed_len=$part_visible_len
    else
        needed_len=$((current_line_len + sep_len + part_visible_len))
    fi

    # If adding this part would exceed terminal width, start new line
    if [ $needed_len -gt $terminal_width ] && [ -n "$current_line" ]; then
        lines+=("$current_line")
        current_line="$part"
        current_line_len=$part_visible_len
    else
        # Add to current line
        if [ -z "$current_line" ]; then
            current_line="$part"
            current_line_len=$part_visible_len
        else
            current_line="${current_line}${separator}${part}"
            current_line_len=$needed_len
        fi
    fi
done

# Add remaining line
[ -n "$current_line" ] && lines+=("$current_line")

# Output: first line as-is, subsequent lines indented with "  " for readability
for i in "${!lines[@]}"; do
    if [ $i -eq 0 ]; then
        printf '%s' "${lines[$i]}"
    else
        printf '\n  %s' "${lines[$i]}"
    fi
done
