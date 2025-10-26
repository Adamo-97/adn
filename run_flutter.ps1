<# ========================================================================
Always launch the same emulator, wait 30s, then run the app.

Usage:
  .\run_flutter.ps1
  .\run_flutter.ps1 -EmulatorId "Some Other Emulator ID"   # optional override

Steps:
  1) flutter clean
  2) flutter pub get
  3) flutter emulators --launch "<ID>"
  4) Start-Sleep -Seconds 30
  5) flutter run (targets first Android device if detected)
========================================================================= #>

param(
  [string]$EmulatorId
)

$ErrorActionPreference = "Stop"

# --- CONFIG: set your default emulator ID here ---
$DEFAULT_EMULATOR_ID = "Medium Phone API 36.0"   # <-- change this to your emulator's ID
# --- Preferred physical device ID (user's S23 Ultra) ---
$PREFERRED_DEVICE_ID = "RFCW905391F"

if (-not $EmulatorId -or $EmulatorId.Trim() -eq "") {
  $EmulatorId = $DEFAULT_EMULATOR_ID
}

function Require-Cmd($name) {
  if (-not (Get-Command $name -ErrorAction SilentlyContinue)) {
    throw "'$name' not found in PATH."
  }
}

function Info($m) { Write-Host "[INFO] $m" }
function Warn($m) { Write-Host "[WARN] $m" -ForegroundColor Yellow }

# --- preflight ---
Require-Cmd flutter
if (-not (Get-Command adb -ErrorAction SilentlyContinue)) {
  Warn "adb not found in PATH (Android SDK platform-tools). Detection may be slower."
}

# --- clean + get ---
Info "Running 'flutter clean'..."
flutter clean | Out-Host

Info "Running 'flutter pub get'..."
flutter pub get | Out-Host

# --- launch emulator (non-interactive, fixed ID) ---
Info "Launching emulator '$EmulatorId'..."
try {
  flutter emulators --launch "$EmulatorId" | Out-Null
}
catch {
  Warn "Launch command returned an error; emulator may still start. Continuing."
}

# --- fixed wait ---
$WAIT_SECS = 30
Info ("Waiting {0}s for the emulator to boot..." -f $WAIT_SECS)
Start-Sleep -Seconds $WAIT_SECS

# --- try to pick an Android device (optional; falls back to auto) ---
$deviceId = $null
try {
  $json = flutter devices --machine | ConvertFrom-Json
  foreach ($d in $json) {
    if ($d.targetPlatform -eq "android") {
      $deviceId = $d.id
      break
    }
  }
}
catch {
  $plain = flutter devices 2>$null
  foreach ($line in $plain) {
    if ($line -match "android" -and $line -match "emulator-") {
      $deviceId = ($line -split "\s+")[0]
      break
    }
  }
}

# --- run ---
# If preferred device is set, use it
if ($PREFERRED_DEVICE_ID) {
  Info "Running 'flutter run -d $PREFERRED_DEVICE_ID'..."
  flutter run -d "$PREFERRED_DEVICE_ID"
}
elseif ($deviceId) {
  Info "Running 'flutter run -d $deviceId'..."
  flutter run -d "$deviceId"
}
else {
  Info "No Android device detected yet; running 'flutter run' (Flutter will attach when ready)..."
  flutter run
}
