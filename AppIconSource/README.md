# App icon source images

Drop your 15 alternate app-icon PNGs **in this folder** (`AppIconSource/`).
It lives outside the app target on purpose, so these raw files are **not**
bundled into the app — a generator script turns them into the proper asset
catalog entries.

## Required files

Name each file by its id, exactly as listed (note `holidayLights` is
camelCase). All 15:

```
classic.png      black.png        white.png
blue.png         green.png        mint.png
peach.png        purple.png       yellow.png
geometric.png    neon.png         monochrome.png
halloween.png    snow.png         holidayLights.png
```

## Format

- **1024 × 1024 px**, square, PNG.
- **No transparency / alpha channel** (App Store icon rule — the build will
  fail on the alternate-icon sets otherwise; iOS rounds the corners for you).
- `classic` is the primary icon. Selecting it in the picker restores the
  default `AppIcon`; we won't overwrite the existing `AppIcon` unless you ask.

## Then what

Once the files are here, the generator (`Tools/generate-app-icons.sh`) creates:

- `AppIcon<Name>.appiconset` for each alternate (used by
  `setAlternateIconName`), and
- `icon-<id>.imageset` preview thumbnails for the picker grid,

inside `PATCOSchedule/Resources/Assets.xcassets/`. I'll run it, enable
"Include All App Icon Assets", and wire up the picker + persistence.
