#!/bin/sh
# POSIX-compatible Wofi wallpaper selector using swww + pywal

# Configuration
WALLPAPER_DIR="$HOME/Wallpapers"
CACHE_DIR="$HOME/.cache/wallpaper-selector"
THUMBNAIL_WIDTH="250"
THUMBNAIL_HEIGHT="141"

# Create cache directory if it doesn't exist
[ -d "$CACHE_DIR" ] || mkdir -p "$CACHE_DIR"

# Paths
SHUFFLE_ICON="$CACHE_DIR/shuffle_thumbnail.png"
SHUFFLE_SRC="$HOME/.config/hypr/assets/shuffle.png"

# Generate thumbnail (POSIX version)
generate_thumbnail() {
    input=$1
    output=$2
    magick "$input" -thumbnail "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}^" \
        -gravity center -extent "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}" "$output"
}

# Generate shuffle thumbnail
if [ ! -f "$SHUFFLE_ICON" ]; then
    magick -size "${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}" xc:"#1e1e2e" \
        \( "$SHUFFLE_SRC" -resize "80x80" \) \
        -gravity center -composite "$SHUFFLE_ICON"
fi

# Generate menu for Wofi
generate_menu() {
    # Shuffle option
    printf 'img:%s\x00info:%s\x1f%s\n' "$SHUFFLE_ICON" "!Random Wallpaper" "RANDOM"

    # Wallpapers
    find "$WALLPAPER_DIR" -maxdepth 1 -type f \( \
        -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) | while IFS= read -r img; do
        [ -f "$img" ] || continue
        filename=$(basename "$img")
        name="${filename%.*}"
        thumbnail="$CACHE_DIR/$name.png"

        # Generate thumbnail if needed
        if [ ! -f "$thumbnail" ] || [ "$img" -nt "$thumbnail" ]; then
            generate_thumbnail "$img" "$thumbnail"
        fi

        # Output format for Wofi
        printf 'img:%s\x00info:%s\x1f%s\n' "$thumbnail" "$filename" "$img"
    done
}

# Launch Wofi with image preview
selected=$(generate_menu | wofi --show dmenu \
    --cache-file /dev/null \
    --define "image-size=${THUMBNAIL_WIDTH}x${THUMBNAIL_HEIGHT}" \
    --columns 3 \
    --allow-images \
    --insensitive \
    --sort-order=default \
    --prompt "Select Wallpaper" \
    --conf "$HOME/.config/wofi/wallpaper.conf")

# Exit if nothing was selected
[ -z "$selected" ] && exit 0

# Remove "img:" prefix to get path
thumbnail_path=$(printf '%s' "$selected" | sed 's/^img://')

# Check if shuffle was selected
if [ "$thumbnail_path" = "$SHUFFLE_ICON" ]; then
    # Pick random wallpaper
    original_path=$(find "$WALLPAPER_DIR" -type f \( \
        -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) | shuf -n 1)
else
    # Extract filename without extension
    original_filename=$(basename "$thumbnail_path" .png)
    original_path=$(find "$WALLPAPER_DIR" -type f -iname "${original_filename}.*" | head -n 1)
fi

# Ensure valid wallpaper was found
[ -z "$original_path" ] && {
    notify-send "Wallpaper Error" "Could not find the original wallpaper file."
    exit 1
}

# Set wallpaper and apply pywal
swww img "$original_path" \
    --transition-type grow \
    --transition-step 255 \
    --transition-fps 60 \
    --transition-duration 0.8

sleep 0.575
wal -i "$original_path"

# Save selection for persistence
echo "$original_path" > "$HOME/.cache/current_wallpaper"

