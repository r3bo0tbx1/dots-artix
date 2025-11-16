<div align="center">

# 🎨 Artix Linux Dotfiles - Hyprland Edition

![Artix Linux](https://img.shields.io/badge/Artix%20Linux-10A0CC?logo=artixlinux&logoColor=fff)
![Hyprland](https://img.shields.io/badge/WM-Hyprland-5e81ac?logo=wayland)
![Shell](https://img.shields.io/badge/Shell-Zsh-green?logo=gnu-bash)
![Wayland](https://img.shields.io/badge/Wayland-Compatible-blue?logo=wayland)
![PyWAL](https://img.shields.io/badge/Theme-PyWAL-orange)
![Maintained](https://img.shields.io/badge/Maintained-Yes-brightgreen)

</div>

> A modern, aesthetically-pleasing Wayland desktop environment configuration for Artix Linux (dinit) featuring Hyprland, dynamic PyWAL theming, and extensive customization.

## ✨ Features

### 🎯 Core Components
- **OS**: Artix Linux with dinit (systemd-free)
- **Compositor**: Hyprland (Wayland) with 240Hz support
- **Status Bar**: Hyprpanel
- **Terminal**: Alacritty (primary), Kitty (alternative)
- **Shell**: Zsh with Powerlevel10k prompt
- **Launcher**: Rofi (apps), Wofi (wallpapers)
- **Lock Screen**: Hyprlock with custom styling
- **Logout Menu**: Wlogout with power controls

### 🌈 Dynamic Theming
- **PyWAL Integration**: Automatic color scheme generation from wallpapers
- All UI elements synchronized: Hyprland, Alacritty, Rofi, Wlogout
- Seamless theme switching with wallpaper selector
- 15+ wallpapers included (see Wallpapers section)

### ⌨️ Keyboard-Driven Workflow
- Extensive Hyprland keybindings (SUPER as main modifier)
- Window management, workspace navigation, media controls
- Custom scripts triggered by hotkeys

### 🔧 Custom Scripts
- **Wallpaper Selector**: GUI picker with thumbnail generation and caching
- **Lock Screen**: Screenshot-based blur with automatic cleanup
- **Browser Launcher**: Quick browser selection menu
- **Battery Monitor**: Daemon with sound notifications at 15%, 50%, 100%
- **Flight Mode**: Quick WiFi toggle
- More automation scripts for daily tasks

### 🎨 Aesthetic Customization
- High-DPI support (1.333x scaling for 2560x1600 @ 240Hz)
- Custom fonts: MesloLGS NF, SF Pro Display, Roboto
- Smooth animations and blur effects
- Semi-transparent terminals and menus
- Catppuccin-inspired color palette

## 📋 What's Included

### Configuration Files
```
.config/
├── hypr/
│   ├── hyprland.conf
│   ├── hyprlock.conf
│   ├── keybinds/
│   ├── keywords/
│   └── scripts/
├── zsh/
│   ├── .zshrc
│   ├── .p10k.zsh
│   └── .zprofile
├── alacritty/
├── kitty/
├── rofi/
├── wofi/
├── wlogout/
└── aliasrc
```

### Custom Scripts
- `lockscreen` - Lock screen with screenshot blur
- `wofi-wallpaper-selector.sh` - Advanced wallpaper picker
- `rofi-browser.sh` - Browser selection menu
- `battery-checknow` - Battery monitoring daemon
- `flightmode` - WiFi toggle utility
- `afkscript` - Minecraft auto-fishing automation
- Plus more utility scripts

### Themes & Assets
- Lock screen profile images
- Wlogout power menu icons (16 themed PNGs)
- Custom system sounds for notifications
- Font files (JetBrains Mono Nerd, SF Pro Display)

## 🚧 Upcoming Features

- 🎨 rEFInd Themes
- 📦 Additional Packages

## 🚀 Quick Start

### Prerequisites

**System Requirements:**
- Artix Linux (dinit preferred) or Arch-based distribution
- Wayland support
- Basic familiarity with command line and Hyprland

**Essential Packages:**
```bash
# Core Wayland & Hyprland
hyprland hyprpanel hyprlock xdg-desktop-portal-hyprland

# Wallpaper & Theming
swww python-pywal imagemagick

# Launchers & Menus
rofi-wayland wofi wlogout

# Screenshots
grim slurp

# Audio & Media
pipewire pipewire-<your-init> wireplumber wireplumber-<your-init> playerctl paplay

# Terminal & Shell
alacritty kitty zsh

# Utilities
brightnessctl thunar eza fzf fastfetch zoxide
```

### Installation

> ⚠️ **WARNING**: This will replace your current configurations. Back up your existing dotfiles first!

**Automated Installation (Recommended):**

```bash
# 1. Clone this repository
cd ~
git clone https://github.com/ShengHuiPang/dotfiles.git
cd dotfiles

# 2. Run the installation script
./install.sh

# Or use command-line options for automation
./install.sh --help           # Show all options
./install.sh --yes --symlink  # Non-interactive symlink installation
```

The install script features:
- ✅ Dependency checking (required + optional packages)
- ✅ Automatic backup with timestamps
- ✅ Symlink or copy installation modes
- ✅ Zsh plugin installation (Powerlevel10k, fzf-tab, syntax-highlighting, autosuggestions)
- ✅ PyWAL theme initialization
- ✅ Interactive or non-interactive modes (--yes flag)
- ✅ Command-line arguments (--help, --symlink, --copy)
- ✅ Comprehensive error handling and feedback

**Manual Installation:**

```bash
# 1. Clone this repository
cd ~
git clone https://github.com/ShengHuiPang/dotfiles.git

# 2. Backup your current configs (IMPORTANT!)
mkdir -p ~/dotfiles-backup
cp -r ~/.config ~/dotfiles-backup/
cp ~/.zshenv ~/dotfiles-backup/

# 3. Create symlinks (or copy files)
# Option A: Symlink (recommended - keeps repo in sync)
ln -sf ~/dotfiles/.config/* ~/.config/
ln -sf ~/dotfiles/.zshenv ~/.zshenv

# Option B: Copy (standalone configs)
cp -r ~/dotfiles/.config/* ~/.config/
cp ~/dotfiles/.zshenv ~/.zshenv

# 4. Make scripts executable
chmod +x ~/dotfiles/Scripts/*
chmod +x ~/dotfiles/.config/hypr/scripts/*

# 5. Set Zsh as default shell
chsh -s $(which zsh)

# 6. Install Zsh plugins (if not already installed)
# Powerlevel10k
paru -S zsh-theme-powerlevel10k-git ttf-meslo-nerd-font-powerlevel10k
# Remaining Plugins
paru -S fzf-tab-git zsh-syntax-highlighting zsh-autosuggestions zsh-vi-mode zsh-you-should-use zsh-auto-notify

# 7. Add wallpapers to ~/dotfiles/Wallpapers/
mkdir -p ~/dotfiles/Wallpapers
# Copy your wallpapers here (jpg/png format)

# 8. Initialize PyWAL with first wallpaper
wal -i ~/dotfiles/Wallpapers/wallpaper1.jpg

# 9. Reload Hyprland
hyprctl reload
# Or restart your session

# 10. Configure personal settings
# Edit ~/.config/hypr/keywords/keywords.conf for your preferences
```

## ⚙️ Configuration

### First-Time Setup

After installation, you should customize these files:

1. **Personal Information**
   - Edit `~/.config/hypr/hyprlock.conf` - Update username and profile image

2. **Monitor Configuration**
   - Edit `~/.config/hypr/hyprland.conf` - Adjust monitor settings for your display
   ```conf
   # Change this line to match your monitor
   monitor=eDP-1, 2560x1600@240, 0x0, 1.333
   ```

3. **Preferred Applications**
   - Edit `~/.config/hypr/keywords/keywords.conf`
   ```conf
   $terminal = alacritty    # Your preferred terminal
   $fileManager = thunar    # Your preferred file manager
   ```

4. **GPU Configuration**
   - If using AMD/Intel GPU, remove or adjust NVIDIA-specific environment variables in `hyprland.conf`

### PyWAL Theme System

This setup uses PyWAL for dynamic color generation:

```bash
# Change theme by setting wallpaper
wal -i /path/to/wallpaper.jpg

# Or use the wallpaper selector
# Press SUPER+A to open GUI selector
```

**How it works:**
1. PyWAL analyzes wallpaper colors
2. Generates color schemes in `~/.cache/wal/`
3. All configs import these colors automatically
4. Instant theme synchronization across all apps

**Important:** Don't edit colors directly in app configs - they'll be overridden!

### Keybindings Cheat Sheet

| Keybind | Action |
|---------|--------|
| `SUPER + Q` | Open terminal (Alacritty) |
| `SUPER + E` | File manager (Thunar) |
| `SUPER + D` | Application launcher (Rofi) |
| `SUPER + A` | Wallpaper selector (Wofi) |
| `SUPER + W` | Browser selector |
| `SUPER + L` | Lock screen |
| `SUPER + M` | Logout menu |
| `SUPER + C` | Close window |
| `SUPER + V` | Toggle floating |
| `SUPER + F` | Toggle fullscreen |
| `SUPER + [1-9]` | Switch workspace |
| `SUPER + Shift + [1-9]` | Move window to workspace |
| `SUPER + Arrow Keys` | Move focus |
| `SUPER + Shift + Arrow Keys` | Move window |
| `Print` | Screenshot (full screen) |
| `SUPER + B` | Screenshot (region) |
| `Volume/Brightness Keys` | Media controls |

**Full keybind reference:** See `~/.config/hypr/keybinds/keybinds.conf`

## 📁 Wallpapers

Wallpapers are stored in `~/dotfiles/Wallpapers/` but **not included in this repository** due to file size.

**Current Wallpaper Collection:**
- 15 high-quality wallpapers (2560x1600 recommended)
- Naming: `wallpaper1.jpg` through `wallpaper15.png`
- Mix of JPG and PNG formats

**Adding Your Own Wallpapers:**
```bash
# Copy wallpapers to the folder
cp /path/to/your/wallpaper.jpg ~/dotfiles/Wallpapers/

# Use wallpaper selector to apply
# Press SUPER+A and select from thumbnails
```

The wallpaper selector will automatically:
- Generate thumbnails (250x141px)
- Cache them for faster loading
- Apply wallpaper with smooth transition
- Generate matching color scheme via PyWAL

## 🛠️ Customization Guide

### Adding Custom Scripts

1. Create script in `~/dotfiles/Scripts/`
   ```bash
   touch ~/dotfiles/Scripts/my-script.sh
   chmod +x ~/dotfiles/Scripts/my-script.sh
   ```

2. Add to keybinds (`~/.config/hypr/keybinds/keybinds.conf`)
   ```conf
   bind = SUPER, KEY, exec, $HOME/Scripts/my-script.sh
   ```

3. Reload Hyprland
   ```bash
   hyprctl reload
   ```

### Changing Shell Aliases

Edit `~/.config/aliasrc`:
```bash
alias myalias='command here'
```

Reload shell:
```bash
source ~/.config/zsh/.zshrc
```

### Adding Zsh Plugins

Edit `~/.config/zsh/.zshrc` and add conditional loading:
```bash
if [ -f /path/to/plugin.zsh ]; then
    source /path/to/plugin.zsh
fi
```

## 🐛 Troubleshooting

### Common Issues

**Hyprland won't start**
- Check logs: `cat ~/.hyprland/hyprland.log`
- Verify GPU drivers installed
- Ensure Wayland support enabled

**Colors look wrong**
- Run PyWAL: `wal -i ~/dotfiles/Wallpapers/wallpaper1.jpg`
- Check cache exists: `ls ~/.cache/wal/`
- Reload Hyprland: `hyprctl reload`

**Scripts don't execute**
- Verify executable: `chmod +x ~/dotfiles/Scripts/*`
- Check path in keybinds uses `$HOME/Scripts/`
- Test script manually from terminal

**Powerlevel10k not showing**
- Install required fonts: MesloLGS NF
- Run configuration wizard: `p10k configure`
- Check Zsh plugin loaded in `.zshrc`

**Lock screen shows wrong username**
- Edit `~/.config/hypr/hyprlock.conf`
- Update text label with your username

**Wallpaper selector is empty**
- Add wallpapers to `~/dotfiles/Wallpapers/`
- Verify wofi and swww installed
- Check script has execute permission

---

<div align="center">

**⭐ Star this repo if you find it useful!**

Made with 🩵 for Artix Linux and Hyprland

[![CI/CD Pipeline](https://img.shields.io/badge/CI%2FCD-Passing-brightgreen?logo=github-actions)](https://github.com/r3bo0tbx1/dotfiles/actions)

*Last Updated: 2025-11-16*

### I use Artix btw 😎✨

</div>
