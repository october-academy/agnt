#!/usr/bin/env bash
# Agnt SFX Hook — plays sound effects triggered by [SFX:filename] markers
# Invoked as a Claude Code Stop hook. Reads JSON event from stdin.
set -uo pipefail

INPUT=$(cat)

# Single python3 call: extract cwd, check project scope, find [SFX:*] markers
eval "$(python3 -c "
import json, re, sys, shlex
q = shlex.quote

try:
    evt = json.loads(sys.argv[1])
except:
    print('AGNT_SFX_EXIT=true')
    sys.exit(0)

cwd = evt.get('cwd', '')
msg = evt.get('last_assistant_message', '')

# Project scope check
import os
sfx_dir = os.path.join(cwd, '.claude', 'agnt', 'sounds')
if not os.path.isdir(sfx_dir):
    print('AGNT_SFX_EXIT=true')
    sys.exit(0)

# Extract [SFX:filename] markers
markers = re.findall(r'\[SFX:([^\]]+)\]', msg)
if not markers:
    print('AGNT_SFX_EXIT=true')
    sys.exit(0)

print('AGNT_SFX_EXIT=false')
print('SFX_DIR=' + q(sfx_dir))
# Output markers as bash array
print('SFX_MARKERS=(' + ' '.join(q(m) for m in markers) + ')')
" "$INPUT" 2>/dev/null)" || exit 0

[ "${AGNT_SFX_EXIT:-true}" = "true" ] && exit 0

# --- Platform detection ---
detect_platform() {
  case "$(uname -s)" in
    Darwin) echo "mac" ;;
    Linux)
      if grep -qi microsoft /proc/version 2>/dev/null; then
        echo "wsl"
      else
        echo "linux"
      fi ;;
    *) echo "unknown" ;;
  esac
}

detect_linux_player() {
  for cmd in pw-play paplay ffplay mpv play aplay; do
    command -v "$cmd" &>/dev/null && echo "$cmd" && return 0
  done
  return 1
}

VOL="${AGNT_SFX_VOLUME:-0.5}"
PLATFORM="$(detect_platform)"

# --- Resolve sound file: try as-is, then with common extensions ---
resolve_sound() {
  local marker="$1"
  for ext in "" ".mp3" ".wav" ".ogg" ".m4a" ".aac"; do
    local candidate="${SFX_DIR}/${marker}${ext}"
    if [[ -f "$candidate" ]]; then
      echo "$candidate"
      return 0
    fi
  done
  return 1
}

# --- Play a single sound file (blocking) ---
play_file() {
  local file="$1"
  case "$PLATFORM" in
    mac)
      afplay -v "$VOL" "$file" ;;
    wsl)
      local wpath
      wpath="$(wslpath -w "$file" 2>/dev/null || echo "$file")"
      local safe_path="${wpath//\\/\\\\}"
      safe_path="${safe_path//\'/\'\'}"
      powershell.exe -NoProfile -NonInteractive -Command \
        "(New-Object Media.SoundPlayer '${safe_path}').PlaySync()" ;;
    linux)
      local player
      player="$(detect_linux_player)" || return 0
      case "$player" in
        pw-play)  pw-play --volume "$VOL" "$file" ;;
        paplay)   paplay --volume="$(python3 -c "print(max(0,min(65536,int($VOL*65536))))")" "$file" ;;
        ffplay)   ffplay -nodisp -autoexit -volume "$(python3 -c "print(max(0,min(100,int($VOL*100))))")" "$file" ;;
        mpv)      mpv --no-video --volume="$(python3 -c "print(max(0,min(100,int($VOL*100))))")" "$file" ;;
        play)     play -v "$VOL" "$file" ;;
        aplay)    aplay -q "$file" ;;
      esac ;;
  esac
}

# Sequential playback in background subshell
(
  for marker in "${SFX_MARKERS[@]}"; do
    resolved="$(resolve_sound "$marker")" || continue
    play_file "$resolved"
  done
) &>/dev/null &

exit 0
