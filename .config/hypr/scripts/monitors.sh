#!/bin/sh

MON="tablet"
PID_FILE="/tmp/wayvnc_pid"
RES="1920x1280@60"
SCALE="1"

# Function: Show wofi menu
choose_position() {
    # echo -e is not POSIX; use printf
    printf "Left\nRight\nCancel\n" | wofi --dmenu --prompt "Tablet position:" --width 300 --height 127
}

# Main logic
EXISTS=$(hyprctl monitors | grep "$MON")

if [ -z "$EXISTS" ]; then
    hyprctl output create headless "$MON"
    sleep 1

    # Run menu
    CHOICE=$(choose_position)

    case "$CHOICE" in
        "Left")
            POSITION="auto-left"
            ;;
        "Right")
            POSITION="auto-right"
            ;;
        "Cancel" | "" )
            hyprctl output remove "$MON"
            rm -f $HOME/.cache/wofi-dmenu
            exit 0
            ;;
        *)
            hyprctl output remove "$MON"
            rm -f $HOME/.cache/wofi-dmenu
            exit 1
            ;;
    esac

    # Extra safety check
    if [ -z "$POSITION" ]; then
        hyprctl output remove "$MON"
        exit 1
    fi

    # Set up virtual monitor
    hyprctl keyword monitor "$MON,$RES,$POSITION,$SCALE"

    # Remove "auto-" prefix using sed
    POS_TEXT=$(printf "%s" "$POSITION" | sed 's/^auto-//')

    # Notify
    hyprctl notify -1 5000 "rgb(1ea3ff)" "✅ Tablet monitor connected on the $POS_TEXT side"

    # Start wayvnc (dash can't disown)
    wayvnc --output "$MON" 0.0.0.0 5901 &
    echo "$!" > "$PID_FILE"
else
    # Clean up
    if [ -f "$PID_FILE" ]; then
        kill "$(cat "$PID_FILE")" && rm "$PID_FILE"
    else
        pkill wayvnc
    fi

    hyprctl output remove "$MON"
    sleep 1

    hyprctl notify -1 5000 "rgb(ff5e5e)" "⚠️ Tablet monitor disconnected"
fi

