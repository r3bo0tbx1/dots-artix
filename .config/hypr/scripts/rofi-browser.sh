#!/bin/sh

# List of web browsers with their launch commands
browsers="Brave Web Browser
Firefox
Tor Browser
Chromium"

# Show the browsers in Rofi and get the selected browser
selected=$(printf "%s\n" "$browsers" | rofi -show -dmenu -p "Choose browser")

# Launch the selected browser
case "$selected" in
    "Brave Web Browser")
        brave --enable-features=WaylandWindowDecorations --ozone-platform-hint=wayland --enable-wayland-ime &
        ;;
    Firefox)
        firefox &
        ;;
    "Tor Browser")
        torbrowser-launcher &
        ;;
    Chromium)
        chromium --enable-features=WaylandWindowDecorations --ozone-platform-hint=wayland --enable-wayland-ime &
        ;;
    *)
        printf "No browser selected or unknown choice.\n"
        ;;
esac
