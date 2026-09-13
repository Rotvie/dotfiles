#! /bin/bash
# Builds ~/Applications/mpv.app around Homebrew's mpv and makes it the default video player.

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP="$HOME/Applications/mpv.app"
PLIST="$APP/Contents/Info.plist"
BUNDLE_ID="local.rotvie.mpv"
PB=/usr/libexec/PlistBuddy
LSREGISTER=/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister

EXTENSIONS=(mkv mp4 webm mov avi m4v flv)

command -v mpv >/dev/null || brew install mpv
command -v duti >/dev/null || brew install duti

# The UTI behind an extension depends on installed apps (another player may claim mkv), so resolve it here.
uti_for() {
    osascript -l JavaScript -e "ObjC.import('CoreServices');
        ObjC.castRefToObject(\$.UTTypeCreatePreferredIdentifierForTag(
            \$.kUTTagClassFilenameExtension, \$('$1'), null)).js"
}

UTIS=()
for ext in "${EXTENSIONS[@]}"; do
    UTIS+=("$(uti_for "$ext")")
done
CONTENT_TYPES=(public.movie public.audiovisual-content public.audio "${UTIS[@]}")

mkdir -p "$HOME/Applications"
rm -rf "$APP"
osacompile -o "$APP" "$DIR/mpv.applescript"

$PB -c "Add :CFBundleIdentifier string $BUNDLE_ID" "$PLIST"
# Replace the "*" wildcard so mpv only shows up in "Open With" for media.
$PB -c "Delete :CFBundleDocumentTypes" "$PLIST"
$PB -c "Add :CFBundleDocumentTypes array" "$PLIST"
$PB -c "Add :CFBundleDocumentTypes:0 dict" "$PLIST"
$PB -c "Add :CFBundleDocumentTypes:0:CFBundleTypeRole string Viewer" "$PLIST"
$PB -c "Add :CFBundleDocumentTypes:0:LSItemContentTypes array" "$PLIST"
for i in "${!CONTENT_TYPES[@]}"; do
    $PB -c "Add :CFBundleDocumentTypes:0:LSItemContentTypes:$i string ${CONTENT_TYPES[$i]}" "$PLIST"
done

# Editing Info.plist breaks the signature seal.
codesign --force --deep -s - "$APP"
"$LSREGISTER" -f "$APP"

# duti by extension exits 0 and changes nothing on current macOS; by UTI it works.
for i in "${!EXTENSIONS[@]}"; do
    duti -s "$BUNDLE_ID" "${UTIS[$i]}" all
    printf '%-5s -> %s\n' "${EXTENSIONS[$i]}" "$(duti -x "${EXTENSIONS[$i]}" | head -1)"
done
