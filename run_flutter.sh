#!/usr/bin/env bash
set -euo pipefail

# -----------------------------------------------------------------------------
# Hard-coded Android run script (Linux)
# - Launches only the specified AVD with GPU accel
# - Optionally kills any running emulator first (--kill)
# - Waits up to 30s for adb + sys.boot_completed
# - Runs `flutter run` ONLY against that emulator (no Chrome fallback)
# -----------------------------------------------------------------------------

AVD_NAME="flutter_emulator"   # exact name from `emulator -list-avds`
export ANDROID_SDK_ROOT="${HOME}/Android/Sdk"
export PATH="$ANDROID_SDK_ROOT/emulator:$ANDROID_SDK_ROOT/platform-tools:$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/tools/bin:$PATH"
export ADB_INSTALL_TIMEOUT=180

KILL_FIRST="no"
if [[ "${1-}" == "--kill" ]]; then
  KILL_FIRST="yes"
fi

info() { echo "[INFO] $*"; }
warn() { echo "[WARN] $*" >&2; }
fail() { echo "[ERROR] $*" >&2; exit 1; }
need() { command -v "$1" >/dev/null 2>&1 || fail "'$1' not found in PATH."; }

need flutter
need emulator
need adb

LOGFILE="${HOME}/.android/emulator-run.log"
ADB_WAIT_SECS=30
BOOT_WAIT_SECS=30

# --- kill any running emulator if requested
if [[ "$KILL_FIRST" == "yes" ]]; then
  info "Killing any running emulator..."
  adb devices | awk 'NR>1 && $1 ~ /^emulator-/ {print $1}' | while read -r dev; do
    info " - adb -s $dev emu kill"
    adb -s "$dev" emu kill || true
  done
  pkill -f "emulator -avd" || true
  sleep 2
fi

# --- verify AVD exists
if ! emulator -list-avds | grep -Fxq "$AVD_NAME"; then
  fail "AVD '$AVD_NAME' not found. Available: $(emulator -list-avds | tr '\n' ' ')"
fi

# --- clean + get
info "flutter clean"
flutter clean

info "flutter pub get"
flutter pub get

# --- snapshot current running emulators
mapfile -t BEFORE_IDS < <(adb devices | awk 'NR>1 && $1 ~ /^emulator-/ {print $1}')

# --- launch if none running
if [[ ${#BEFORE_IDS[@]} -gt 0 ]]; then
  info "An emulator is already running (devices: ${BEFORE_IDS[*]}). Reusing it."
else
  info "Launching AVD '$AVD_NAME' with GPU acceleration..."
  mkdir -p "$(dirname "$LOGFILE")"
  emulator -avd "$AVD_NAME" -gpu host -no-snapshot -no-boot-anim -netdelay none -netspeed full \
    >>"$LOGFILE" 2>&1 &
  EMU_PID=$!
  info "Emulator PID: $EMU_PID (logs: $LOGFILE)"
fi

# --- wait for adb device (max 30s)
TARGET_ID=""
START_TS=$(date +%s)
info "Waiting up to ${ADB_WAIT_SECS}s for emulator to connect to adb..."
while true; do
  mapfile -t NOW_IDS < <(adb devices | awk 'NR>1 && $1 ~ /^emulator-/ && $2=="device" {print $1}')
  if [[ ${#NOW_IDS[@]} -gt 0 ]]; then
    TARGET_ID="${NOW_IDS[0]}"
    break
  fi
  now=$(date +%s)
  if (( now - START_TS > ADB_WAIT_SECS )); then
    fail "Timed out (${ADB_WAIT_SECS}s) waiting for emulator device. Check: $LOGFILE"
  fi
  sleep 2
done
info "Emulator device detected: $TARGET_ID"

# --- wait for Android boot complete (max 30s)
info "Waiting up to ${BOOT_WAIT_SECS}s for Android to finish booting..."
BOOT_START=$(date +%s)
while true; do
  boot_ok="$(adb -s "$TARGET_ID" shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')"
  if [[ "$boot_ok" == "1" ]]; then
    break
  fi
  now=$(date +%s)
  if (( now - BOOT_START > BOOT_WAIT_SECS )); then
    warn "Timed out (${BOOT_WAIT_SECS}s) waiting for sys.boot_completed. Continuing anyway..."
    break
  fi
  sleep 2
done
info "Boot check finished."

# --- run only on this device
info "Starting app on $TARGET_ID..."
exec flutter run -d "$TARGET_ID"
