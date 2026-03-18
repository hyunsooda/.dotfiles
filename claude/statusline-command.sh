#!/usr/bin/env bash

input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
remaining_pct=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
transcript=$(echo "$input" | jq -r '.transcript_path // empty')

# Colors
BLUE=$'\033[38;2;66;133;244m'
PINK=$'\033[38;2;239;124;142m'
GREEN=$'\033[38;2;80;200;120m'
YELLOW=$'\033[38;2;255;200;60m'
RED=$'\033[38;2;220;80;80m'
DIM=$'\033[2m'
RESET=$'\033[0m'

# Directory segment: "LAPTOP <path>"
dir_segment="LAPTOP $(printf "${BLUE}%s${RESET}" "${cwd}")"

# Git branch segment
git_branch=""
if git -C "${cwd}" rev-parse --is-inside-work-tree > /dev/null 2>&1; then
  branch=$(git -C "${cwd}" symbolic-ref --short HEAD 2>/dev/null || git -C "${cwd}" rev-parse --short HEAD 2>/dev/null)
  if [ -n "${branch}" ]; then
    git_branch=" $(printf "${PINK}%s${RESET}" "${branch}")"
  fi

  # Git status indicators
  git_flags=""
  git_status=$(git -C "${cwd}" status --porcelain 2>/dev/null)
  modified_count=$(echo "${git_status}" | grep -c '^ M\|^M ' 2>/dev/null || echo 0)
  staged_count=$(echo "${git_status}" | grep -c '^[MARC]' 2>/dev/null || echo 0)
  untracked_count=$(echo "${git_status}" | grep -c '^??' 2>/dev/null || echo 0)

  [ "${modified_count}" -gt 0 ] 2>/dev/null && git_flags="${git_flags} *${modified_count}"
  [ "${staged_count}" -gt 0 ] 2>/dev/null && git_flags="${git_flags} +${staged_count}"
  [ "${untracked_count}" -gt 0 ] 2>/dev/null && git_flags="${git_flags} ?${untracked_count}"

  if [ -n "${git_flags}" ]; then
    git_branch="${git_branch} [${git_flags# }]"
  fi
fi

# Model segment
model_segment=""
if [ -n "${model}" ]; then
  model_segment=" $(printf "${DIM}%s${RESET}" "${model}")"
fi

# Context usage segment with color coding and progress bar
ctx_segment=""
if [ -n "${used_pct}" ] && [ -n "${remaining_pct}" ]; then
  used_int=${used_pct%.*}
  rem_int=${remaining_pct%.*}

  # Choose color based on usage level
  if [ "${used_int}" -ge 85 ] 2>/dev/null; then
    ctx_color="${RED}"
    ctx_warn=" (!)"
  elif [ "${used_int}" -ge 65 ] 2>/dev/null; then
    ctx_color="${YELLOW}"
    ctx_warn=""
  else
    ctx_color="${GREEN}"
    ctx_warn=""
  fi

  # Show rate limit reset time from cache (updated by get-usage-reset.py)
  usage_line=""
  reset_str=""
  usage_cache="${HOME}/.claude/usage_reset_cache"
  if [ -f "${usage_cache}" ]; then
    session_pct=$(jq -r '.session_pct // empty' "${usage_cache}" 2>/dev/null)
    week_pct=$(jq -r '.week_pct // empty' "${usage_cache}" 2>/dev/null)
    reset_time=$(jq -r '.reset_time // empty' "${usage_cache}" 2>/dev/null)
    if [ -n "${session_pct}" ]; then
      if [ "${session_pct}" -ge 85 ] 2>/dev/null; then
        s_color="${RED}"
      elif [ "${session_pct}" -ge 65 ] 2>/dev/null; then
        s_color="${YELLOW}"
      else
        s_color="${GREEN}"
      fi
      usage_line="${s_color}current session ${session_pct}%${RESET}"
    fi
    [ -n "${week_pct}" ] && usage_line="${usage_line}${DIM} | current week ${week_pct}%${RESET}"
    [ -n "${reset_time}" ] && reset_str="${DIM} | reset at ${reset_time}${RESET}"
  fi

  second_line=""
  if [ -n "${usage_line}" ] || [ -n "${reset_str}" ]; then
    second_line=$'\n'"$(printf '%s%s' "${usage_line}" "${reset_str}")"
  fi

  ctx_segment=" $(printf '%sctx %s%%%s%s' "${ctx_color}" "${used_int}" "${ctx_warn}${RESET}" "${second_line}")"
fi

printf "%s%s%s%s\n" "${dir_segment}" "${git_branch}" "${model_segment}" "${ctx_segment}"
