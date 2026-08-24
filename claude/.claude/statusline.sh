#!/usr/bin/env bash
set -u
INPUT="$(cat)"
export INPUT_JSON="$INPUT"

# Terminal width for flex-spacer math. Honors STATUSLINE_COLS env override
# (used by parity tests); otherwise tries tput, finally falls back to 80.
STATUSLINE_COLS=${STATUSLINE_COLS:-$(tput cols 2>/dev/null || echo 80)}

# Visible-character length: strip CSI SGR sequences then count chars.
# Wide glyphs (emoji, CJK) count as 1 column — same simplification as the
# interpret backend uses.
__visible_len() {
  printf '%s' "$1" | sed 's/\x1b\[[0-9;]*m//g' | awk '{ printf "%s", length($0) }'
}

__repeat_char() {
  local ch="$1" n="$2" out=""
  if [ "$n" -le 0 ]; then printf ''; return; fi
  local i=0
  while [ "$i" -lt "$n" ]; do out+="$ch"; i=$((i+1)); done
  printf '%s' "$out"
}

__sgr() { printf '\033[%sm' "$1"; }
__reset() { printf '\033[0m'; }

if command -v jq >/dev/null 2>&1; then
  __field() {
    printf '%s' "$INPUT_JSON" | jq -r --arg p "$1" '
      ($p | split(".")) as $parts
      | reduce $parts[] as $k (.; if type == "object" and has($k) then .[$k] else null end)
      | if . == null then "" else (if type == "string" then . else tostring end) end
    ' 2>/dev/null
  }
else
  if command -v python3 >/dev/null 2>&1 && python3 -c 'import sys' >/dev/null 2>&1; then
    __PY=python3
  elif command -v python >/dev/null 2>&1; then
    __PY=python
  else
    __PY=""
  fi
  __field() {
    if [ -z "$__PY" ]; then printf ''; return; fi
    PATH_ARG="$1" "$__PY" - <<'PYEOF' 2>/dev/null
import json, os
d = json.loads(os.environ.get('INPUT_JSON','{}') or '{}')
p = os.environ.get('PATH_ARG','')
cur = d
for part in p.split('.'):
    if isinstance(cur, dict) and part in cur:
        cur = cur[part]
    else:
        cur = None
        break
if cur is None:
    print('', end='')
elif isinstance(cur, bool):
    print('true' if cur else 'false', end='')
else:
    print(cur, end='')
PYEOF
  }
fi

__basename() { local s="$1"; printf '%s' "${s##*/}"; }
__compact() {
  local s="$1"
  if [ -z "$s" ]; then printf ''; return; fi
  # Use awk so we don't depend on bash arrays. Split on '/', take the first
  # char of every segment except the last; preserve a leading slash by
  # emitting an empty initial element when the path starts with '/'.
  printf '%s' "$s" | awk 'BEGIN{FS="/"} {
    out=""
    for (i=1; i<=NF; i++) {
      if (i==NF) { piece = $i }
      else if ($i == "") { piece = "" }
      else { piece = substr($i, 1, 1) }
      if (i==1) { out = piece } else { out = out "/" piece }
    }
    printf "%s", out
  }'
}
__tildify() {
  local s="$1"
  local home="${HOME%/}"
  if [ -n "$home" ] && [[ "$s" == "$home"* ]]; then
    printf '~%s' "${s#$home}"
    return
  fi
  if [[ "$s" =~ ^/(Users|home)/[^/]+(.*)$ ]]; then
    printf '~%s' "${BASH_REMATCH[2]}"
    return
  fi
  printf '%s' "$s"
}
__truncate() {
  local s="$1" n="$2"
  if [ "$n" -le 0 ] || [ "${#s}" -le "$n" ]; then printf '%s' "$s"; return; fi
  if [ "$n" -le 1 ]; then printf '%s' "${s:0:$n}"; return; fi
  printf '%s…' "${s:0:$((n-1))}"
}
__cost_fmt() { printf '$%.*f' "$2" "$1"; }
__dur_hms() {
  local ms="$1" total h m s
  total=$((ms/1000)); h=$((total/3600)); m=$(((total%3600)/60)); s=$((total%60))
  if [ "$h" -gt 0 ]; then printf '%d:%02d:%02d' "$h" "$m" "$s"
  else printf '%d:%02d' "$m" "$s"; fi
}
__dur_human() {
  local ms="$1" total m s h mm
  total=$((ms/1000))
  if [ "$total" -lt 60 ]; then printf '%ds' "$total"; return; fi
  m=$((total/60)); s=$((total%60))
  if [ "$m" -lt 60 ]; then
    if [ "$s" -gt 0 ]; then printf '%dm %ds' "$m" "$s"; else printf '%dm' "$m"; fi
    return
  fi
  h=$((m/60)); mm=$((m%60))
  if [ "$mm" -gt 0 ]; then printf '%dh %dm' "$h" "$mm"; else printf '%dh' "$h"; fi
}
__bar() {
  local pct="$1" width="$2" filled="$3" empty="$4"
  local p i n=0 e=0
  p=${pct%.*}
  [ -z "$p" ] && p=0
  if [ "$p" -lt 0 ]; then p=0; fi
  if [ "$p" -gt 100 ]; then p=100; fi
  n=$(( (p * width + 50) / 100 ))
  e=$((width - n))
  local out=""
  for ((i=0; i<n; i++)); do out+="$filled"; done
  for ((i=0; i<e; i++)); do out+="$empty"; done
  printf '%s' "$out"
}
__git_branch() {
  local cwd dir
  cwd="$(__field workspace.current_dir)"
  if [ -z "$cwd" ]; then cwd="$(__field cwd)"; fi
  if [ -n "$cwd" ] && command -v git >/dev/null 2>&1; then
    git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null
  else
    __field workspace.git_worktree
  fi
}
__emit() {
  local style="$1" text="$2"
  if [ -n "$style" ]; then __sgr "$style"; fi
  printf '%s' "$text"
  if [ -n "$style" ]; then __reset; fi
}
__norm_int() {
  # Coerce a possibly-decimal/empty/garbage field value to a non-negative
  # integer string. Used by token-display helpers.
  local v="$1"
  v="${v%%.*}"
  case "$v" in
    ''|*[!0-9]*) printf '0' ;;
    *) printf '%s' "$v" ;;
  esac
}
__fmt_token_compact() {
  local n
  n="$(__norm_int "$1")"
  if [ "$n" -lt 1000 ]; then printf '%s' "$n"; return; fi
  if [ "$n" -lt 1000000 ]; then
    local whole=$((n / 1000))
    local rem=$((n - whole * 1000))
    local dec=$((rem / 100))
    if [ "$dec" -eq 0 ]; then printf '%dk' "$whole"; else printf '%d.%dk' "$whole" "$dec"; fi
    return
  fi
  local whole=$((n / 1000000))
  local rem=$((n - whole * 1000000))
  local dec=$((rem / 100000))
  if [ "$dec" -eq 0 ]; then printf '%dM' "$whole"; else printf '%d.%dM' "$whole" "$dec"; fi
}
__fmt_token_full() {
  local n
  n="$(__norm_int "$1")"
  printf '%s' "$n" | awk '{
    s=$0; out=""; n=length(s)
    while (n > 3) { out=","substr(s,n-2,3) out; n -= 3 }
    out=substr(s,1,n) out
    printf "%s", out
  }'
}
__tokens_used() { __field 'context_window.total_input_tokens'; }
__tokens_total() { __field 'context_window.context_window_size'; }
__tokens_remaining() {
  local u t
  u="$(__norm_int "$(__tokens_used)")"
  t="$(__norm_int "$(__tokens_total)")"
  local r=$((t - u))
  if [ "$r" -lt 0 ]; then r=0; fi
  printf '%d' "$r"
}
__tokens_pct_int() {
  local p="$(__field 'context_window.used_percentage')"
  __norm_int "$p"
}
__tick() {
  if [ -n "${STATUSLINE_CLOCK_OVERRIDE:-}" ]; then
    printf '%s' "$STATUSLINE_CLOCK_OVERRIDE"
  else
    date +%s
  fi
}
__epoch_from() {
  # Accept epoch seconds, epoch milliseconds, or an ISO 8601 timestamp and
  # print epoch seconds. Prints nothing when the value cannot be parsed.
  local v="$1"
  if [ -z "$v" ]; then printf ''; return; fi
  local digits="${v%%.*}"
  case "$digits" in
    ''|*[!0-9]*) ;;
    *)
      if [ "${#digits}" -ge 12 ]; then printf '%s' "$((digits / 1000))"
      else printf '%s' "$digits"; fi
      return ;;
  esac
  if command -v python3 >/dev/null 2>&1; then
    if ISO_ARG="$v" python3 - <<'PYISO' 2>/dev/null
import os, datetime
v = os.environ.get('ISO_ARG', '').strip()
if v.endswith('Z'):
    v = v[:-1] + '+00:00'
try:
    d = datetime.datetime.fromisoformat(v)
except ValueError:
    raise SystemExit(1)
if d.tzinfo is None:
    d = d.replace(tzinfo=datetime.timezone.utc)
print(int(d.timestamp()), end='')
PYISO
    then return; fi
  fi
  # GNU date, then BSD date.
  if date -u -d "$v" +%s 2>/dev/null; then return; fi
  local trimmed="${v%Z}"
  trimmed="${trimmed%%.*}"
  if date -j -u -f '%Y-%m-%dT%H:%M:%S' "$trimmed" +%s 2>/dev/null; then return; fi
  printf ''
}
__rel_time() {
  local target
  target="$(__epoch_from "$1")"
  if [ -z "$target" ]; then printf ''; return; fi
  local now diff d h m
  now=$(__tick)
  diff=$((target - now))
  if [ "$diff" -le 0 ]; then printf ''; return; fi
  if [ "$diff" -lt 60 ]; then printf '%ds' "$diff"; return; fi
  if [ "$diff" -lt 3600 ]; then printf '%dm' "$((diff / 60))"; return; fi
  if [ "$diff" -lt 86400 ]; then
    h=$((diff / 3600)); m=$(((diff % 3600) / 60))
    printf '%dh%02dm' "$h" "$m"; return
  fi
  d=$((diff / 86400)); h=$(((diff % 86400) / 3600))
  printf '%dd%02dh' "$d" "$h"
}
__v="$(__field 'model.display_name')"
__emit '' "$__v"
__emit '' ' '
if [ "$(__field 'thinking.enabled')" = 'true' ]; then
  __v="$(__field 'effort.level')"
  __emit '' "$__v"
fi
__emit '' ' | '
__out="$(__git_branch)"
__emit '' "$__out"
__emit '' ' | ctx: '
__u="$(__tokens_used)"
__t="$(__tokens_total)"
__uf="$(__fmt_token_compact "$__u")"
__tf="$(__fmt_token_compact "$__t")"
__emit '' "$__uf/$__tf"
__reset
printf '\n'
__reset
__v="$(__field 'rate_limits.five_hour.used_percentage')"
__bar_out="$(__bar "$__v" 13 '▮' '▯')"
__emit '1' "$__bar_out"
__limit_seg() {
  # "<pct>% · <time until reset>", with either half omitted when the
  # corresponding field is absent from the payload.
  local key="$1" pct rel
  pct="$(__field "rate_limits.$key.used_percentage")"
  rel="$(__rel_time "$(__field "rate_limits.$key.resets_at")")"
  if [ -n "$pct" ] && [ -n "$rel" ]; then printf '%s%% · %s' "$pct" "$rel"; return; fi
  if [ -n "$pct" ]; then printf '%s%%' "$pct"; return; fi
  printf '%s' "$rel"
}
__seg5="$(__limit_seg 'five_hour')"
__seg7="$(__limit_seg 'seven_day')"
if [ -n "$__seg5" ]; then __emit '' " $__seg5"; fi
if [ -n "$__seg5" ] && [ -n "$__seg7" ]; then __emit '' ' │ '
elif [ -n "$__seg7" ]; then __emit '' ' '; fi
if [ -n "$__seg7" ]; then __emit '' "$__seg7"; fi

exit 0
