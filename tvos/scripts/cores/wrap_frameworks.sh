#!/usr/bin/env bash
# Wraps each staged core dylib (from fetch_cores.sh or build_cores.sh) into a
# tvOS framework bundle under tvos/Frameworks/Cores/, ready for the Runner's
# Embed Frameworks phase (added by wire_tvos_cores.rb, code-sign-on-copy).
#
# Also runs the no-JIT compliance gate: fails if a core exports dynarec/lightrec
# symbols or requests executable remapping.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CORES_DIR="$SCRIPT_DIR/../../Frameworks/Cores"
STAGING="$CORES_DIR/staging"
MIN_OS="16.0"

[ -d "$STAGING" ] || { echo "error: $STAGING not found; run fetch_cores.sh or build_cores.sh first" >&2; exit 1; }

shopt -s nullglob
dylibs=("$STAGING"/*_libretro*.dylib)
[ ${#dylibs[@]} -gt 0 ] || { echo "error: no dylibs in $STAGING" >&2; exit 1; }

failed=()
for dylib in "${dylibs[@]}"; do
  base="$(basename "$dylib" .dylib)"
  name="${base%_tvos}"                       # fceumm_libretro_tvos -> fceumm_libretro
  fw="$CORES_DIR/$name.framework"
  echo "==> $name"

  # No-JIT gate: dynarec/lightrec symbols or W^X remap calls must not appear.
  if nm -gU "$dylib" 2>/dev/null | grep -qiE 'lightrec|dynarec|drc_|new_dynarec'; then
    echo "SKIP: $name contains dynarec symbols - rebuild from source with DYNAREC=0" >&2
    failed+=("$name")
    continue
  fi
  if strings "$dylib" | grep -q 'MAP_JIT'; then
    echo "SKIP: $name references MAP_JIT" >&2
    failed+=("$name")
    continue
  fi

  rm -rf "$fw"
  mkdir -p "$fw"
  cp "$dylib" "$fw/$name"
  install_name_tool -id "@rpath/$name.framework/$name" "$fw/$name"

  # CFBundleIdentifier forbids underscores.
  bundle_id="org.moonfin.core.$(echo "${name%_libretro}" | tr '_' '-')"

  cat > "$fw/Info.plist" <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key><string>en</string>
	<key>CFBundleExecutable</key><string>$name</string>
	<key>CFBundleIdentifier</key><string>$bundle_id</string>
	<key>CFBundleInfoDictionaryVersion</key><string>6.0</string>
	<key>CFBundleName</key><string>$name</string>
	<key>CFBundlePackageType</key><string>FMWK</string>
	<key>CFBundleShortVersionString</key><string>1.0</string>
	<key>CFBundleVersion</key><string>1</string>
	<key>MinimumOSVersion</key><string>$MIN_OS</string>
</dict>
</plist>
PLIST
done

echo "done: frameworks in $CORES_DIR"
echo "next: ruby ../wire_tvos_cores.rb"
if [ ${#failed[@]} -gt 0 ]; then
  echo "NOT wrapped (failed the no-JIT gate): ${failed[*]}" >&2
  exit 1
fi
