#!/usr/bin/env bash
#
# Generate alternate-app-icon (.appiconset) and preview (.imageset) catalog
# entries from the source PNGs in AppIconSource/.
#
# Usage:  ./Tools/generate-app-icons.sh
#
# Source files must be named <id>.png (see AppIconSource/README.md). For each
# id this creates:
#   - PATCOSchedule/Resources/Assets.xcassets/icon-<id>.imageset  (preview)
#   - PATCOSchedule/Resources/Assets.xcassets/AppIcon<Name>.appiconset
#     (the alternate app icon; skipped for "classic", which is the primary icon)
#
# Idempotent: safe to re-run after updating source files.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC="$ROOT/AppIconSource"
CAT="$ROOT/PATCOSchedule/Resources/Assets.xcassets"

# id : alternate-icon asset name  ("" = primary AppIcon, no alternate set)
ENTRIES=(
  "classic:"
  "black:AppIconBlack"
  "white:AppIconWhite"
  "blue:AppIconBlue"
  "green:AppIconGreen"
  "mint:AppIconMint"
  "peach:AppIconPeach"
  "purple:AppIconPurple"
  "yellow:AppIconYellow"
  "geometric:AppIconGeometric"
  "neon:AppIconNeon"
  "monochrome:AppIconMonochrome"
  "halloween:AppIconHalloween"
  "snow:AppIconSnow"
  "holidayLights:AppIconHolidayLights"
)

missing=0
made=0

for entry in "${ENTRIES[@]}"; do
  id="${entry%%:*}"
  alt="${entry#*:}"
  src="$SRC/$id.png"

  if [[ ! -f "$src" ]]; then
    echo "  MISSING  $src"
    missing=$((missing + 1))
    continue
  fi

  # --- Preview imageset (used by the picker grid) ---
  imgset="$CAT/icon-$id.imageset"
  mkdir -p "$imgset"
  cp "$src" "$imgset/icon-$id.png"
  cat > "$imgset/Contents.json" <<JSON
{
  "images" : [
    {
      "idiom" : "universal",
      "filename" : "icon-$id.png"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
JSON

  # --- Alternate app icon set (skip primary "classic") ---
  if [[ -n "$alt" ]]; then
    appset="$CAT/$alt.appiconset"
    mkdir -p "$appset"
    cp "$src" "$appset/$alt.png"
    cat > "$appset/Contents.json" <<JSON
{
  "images" : [
    {
      "idiom" : "universal",
      "platform" : "ios",
      "size" : "1024x1024",
      "filename" : "$alt.png"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
JSON
  fi

  echo "  ok       $id${alt:+  ->  $alt}"
  made=$((made + 1))
done

echo ""
echo "Generated $made icon(s); $missing missing."
if [[ $missing -gt 0 ]]; then
  echo "Add the missing PNGs to AppIconSource/ and re-run."
  exit 1
fi
