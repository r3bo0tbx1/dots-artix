#!/bin/bash

# ============================================================================
# Dotfiles Installation Script
# Automated installation for Artix Linux + Hyprland dotfiles
# ============================================================================

set -e  # Exit on error

# Parse command line arguments
INSTALL_MODE=""
NON_INTERACTIVE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --help|-h)
            echo "Dotfiles Installation Script"
            echo ""
            echo "Usage: $0 [OPTIONS]"
            echo ""
            echo "Options:"
            echo "  -h, --help          Show this help message"
            echo "  -y, --yes           Non-interactive mode (auto-yes to prompts)"
            echo "  --symlink           Force symlink mode (recommended)"
            echo "  --copy              Force copy mode"
            echo ""
            echo "Examples:"
            echo "  $0                  # Interactive installation"
            echo "  $0 --yes --symlink  # Automated symlink installation"
            echo ""
            exit 0
            ;;
        -y|--yes)
            NON_INTERACTIVE=true
            shift
            ;;
        --symlink)
            INSTALL_MODE="symlink"
            shift
            ;;
        --copy)
            INSTALL_MODE="copy"
            shift
            ;;
        *)
            echo "Unknown option: $1"
            echo "Run '$0 --help' for usage information"
            exit 1
            ;;
    esac
done

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
CONFIG_DIR="$HOME/.config"

# ============================================================================
# Helper Functions
# ============================================================================

print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

ask_confirmation() {
    local prompt="$1"
    local default="${2:-n}"

    # Auto-yes in non-interactive mode
    if [ "$NON_INTERACTIVE" = true ]; then
        echo "$prompt [auto-yes]"
        return 0
    fi

    if [ "$default" = "y" ]; then
        prompt="$prompt [Y/n]: "
    else
        prompt="$prompt [y/N]: "
    fi

    read -p "$prompt" -n 1 -r
    echo

    if [[ $REPLY =~ ^[Yy]$ ]] || ( [ -z "$REPLY" ] && [ "$default" = "y" ] ); then
        return 0
    else
        return 1
    fi
}

check_command() {
    if command -v "$1" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# ============================================================================
# Pre-installation Checks
# ============================================================================

print_header "Dotfiles Installation Script"
echo "Installation directory: $DOTFILES_DIR"
echo "Backup directory: $BACKUP_DIR"
echo ""

# Check if running as root
if [ "$EUID" -eq 0 ]; then
    print_error "Do not run this script as root!"
    exit 1
fi

# Confirm installation
if ! ask_confirmation "This will replace your current configurations. Continue?"; then
    print_info "Installation cancelled."
    exit 0
fi

# ============================================================================
# Dependency Check
# ============================================================================

print_header "Checking Dependencies"

REQUIRED_DEPS=(
    "git"
    "hyprland"
    "alacritty"
    "zsh"
    "rofi"
    "wofi"
    "swww"
    "python-pywal16"
    "grim"
    "slurp"
)

OPTIONAL_DEPS=(
    "ags-hyprpanel-git"
    "hyprlock"
    "wlogout"
    "kitty"
    "playerctl"
    "brightnessctl"
    "thunar"
    "eza"
    "fzf"
    "fastfetch"
    "zoxide"
)

missing_required=()
missing_optional=()

for dep in "${REQUIRED_DEPS[@]}"; do
    if check_command "$dep"; then
        print_success "$dep installed"
    else
        print_error "$dep not found (REQUIRED)"
        missing_required+=("$dep")
    fi
done

for dep in "${OPTIONAL_DEPS[@]}"; do
    if check_command "$dep"; then
        print_success "$dep installed"
    else
        print_warning "$dep not found (optional)"
        missing_optional+=("$dep")
    fi
done

if [ ${#missing_required[@]} -gt 0 ]; then
    echo ""
    print_error "Missing required dependencies:"
    printf '%s\n' "${missing_required[@]}"
    echo ""
    print_info "Install missing dependencies first, then run this script again."
    echo "Example for Artix/Arch:"
    echo "  sudo pacman -S ${missing_required[*]}"
    exit 1
fi

if [ ${#missing_optional[@]} -gt 0 ]; then
    echo ""
    print_warning "Missing optional dependencies:"
    printf '%s\n' "${missing_optional[@]}"
    if ! ask_confirmation "Continue anyway?"; then
        exit 0
    fi
fi

# ============================================================================
# Backup Existing Configurations
# ============================================================================

print_header "Backing Up Existing Configurations"

mkdir -p "$BACKUP_DIR"
print_success "Created backup directory: $BACKUP_DIR"

# List of configs to backup
BACKUP_ITEMS=(
    ".config/hypr"
    ".config/alacritty"
    ".config/kitty"
    ".config/rofi"
    ".config/wofi"
    ".config/wlogout"
    ".config/zsh"
    ".zshenv"
    "Scripts"
)

for item in "${BACKUP_ITEMS[@]}"; do
    if [ -e "$HOME/$item" ]; then
        cp -r "$HOME/$item" "$BACKUP_DIR/" 2>/dev/null || true
        print_success "Backed up: $item"
    fi
done

print_success "Backup completed!"

# ============================================================================
# Create Necessary Directories
# ============================================================================

print_header "Creating Directories"

mkdir -p "$HOME/.config"
mkdir -p "$HOME/.cache"
mkdir -p "$HOME/Pictures/Screenshots"
mkdir -p "$DOTFILES_DIR/Wallpapers"

print_success "Directories created"

# ============================================================================
# Install Configuration Files
# ============================================================================

print_header "Installing Configuration Files"

# Determine installation mode
if [ -n "$INSTALL_MODE" ]; then
    # Mode specified via command line
    use_symlinks=$( [ "$INSTALL_MODE" = "symlink" ] && echo true || echo false )
elif ask_confirmation "Use symlinks (recommended for development)?"; then
    use_symlinks=true
else
    use_symlinks=false
fi

if [ "$use_symlinks" = true ]; then
    # Symlink .config subdirectories
    for dir in "$DOTFILES_DIR/.config"/*; do
        if [ -d "$dir" ]; then
            dir_name=$(basename "$dir")

            # Remove existing
            rm -rf "$CONFIG_DIR/$dir_name"

            # Create symlink
            ln -sf "$dir" "$CONFIG_DIR/$dir_name"
            print_success "Linked: .config/$dir_name"
        fi
    done

    # Symlink root-level dotfiles
    ln -sf "$DOTFILES_DIR/.zshenv" "$HOME/.zshenv"
    print_success "Linked: .zshenv"

    # Symlink Scripts directory
    rm -rf "$HOME/Scripts"
    ln -sf "$DOTFILES_DIR/Scripts" "$HOME/Scripts"
    print_success "Linked: Scripts/"

    # Copy profile images (not symlinked)
    if [ -f "$DOTFILES_DIR/.profile1.jpg" ]; then
        cp "$DOTFILES_DIR/.profile1.jpg" "$HOME/.profile1.jpg"
        print_success "Copied: .profile1.jpg"
    fi
    if [ -f "$DOTFILES_DIR/.profile2.jpg" ]; then
        cp "$DOTFILES_DIR/.profile2.jpg" "$HOME/.profile2.jpg"
        print_success "Copied: .profile2.jpg"
    fi
else
    # Copy approach
    cp -r "$DOTFILES_DIR/.config"/* "$CONFIG_DIR/"
    cp "$DOTFILES_DIR/.zshenv" "$HOME/.zshenv"
    cp -r "$DOTFILES_DIR/Scripts" "$HOME/"
    [ -f "$DOTFILES_DIR/.profile1.jpg" ] && cp "$DOTFILES_DIR/.profile1.jpg" "$HOME/"
    [ -f "$DOTFILES_DIR/.profile2.jpg" ] && cp "$DOTFILES_DIR/.profile2.jpg" "$HOME/"
    print_success "Configuration files copied"
fi

# Make scripts executable
print_info "Making scripts executable..."
if [ -d "$HOME/Scripts" ]; then
    find "$HOME/Scripts" -type f -exec chmod +x {} \; 2>/dev/null
    print_success "Made Scripts/ executable"
fi
if [ -d "$HOME/.config/hypr/scripts" ]; then
    find "$HOME/.config/hypr/scripts" -type f -exec chmod +x {} \; 2>/dev/null
    print_success "Made .config/hypr/scripts/ executable"
fi

# ============================================================================
# Install Zsh Plugins
# ============================================================================

print_header "Installing Zsh Plugins"

# Powerlevel10k
if [ ! -d "$HOME/.local/share/powerlevel10k" ]; then
    print_info "Installing Powerlevel10k..."
    paru -S --noconfirm zsh-theme-powerlevel10k-git ttf-meslo-nerd-font-powerlevel10k
    print_success "Powerlevel10k installed"
else
    print_success "Powerlevel10k already installed"
fi

# fzf-tab
if [ ! -d "/usr/share/zsh/plugins/fzf-tab-git" ]; then
    print_info "Installing fzf-tab..."
    paru -S --noconfirm fzf-tab-git
    print_success "fzf-tab installed"
else
    print_success "fzf-tab already installed"
fi

# zsh-syntax-highlighting
if [ ! -d "/usr/share/zsh/plugins/zsh-syntax-highlighting" ]; then
    print_info "Installing zsh-syntax-highlighting..."
    paru -S --noconfirm zsh-syntax-highlighting
    print_success "zsh-syntax-highlighting installed"
else
    print_success "zsh-syntax-highlighting already installed"
fi

# zsh-autosuggestions
if [ ! -d "/usr/share/zsh/plugins/zsh-autosuggestions" ]; then
    print_info "Installing zsh-autosuggestions..."
    paru -S --noconfirm zsh-autosuggestions
    print_success "zsh-autosuggestions installed"
else
    print_success "zsh-autosuggestions already installed"
fi

# zsh-vi-mode
if [ ! -d "/usr/share/zsh/plugins/zsh-vi-mode" ]; then
    print_info "Installing zsh-autosuggestions..."
    paru -S --noconfirm zsh-vi-mode
    print_success "zsh-vi-mode installed"
else
    print_success "zsh-vi-mode already installed"
fi

# zsh-you-should-use
if [ ! -d "/usr/share/zsh/plugins/zsh-you-should-use" ]; then
    print_info "Installing zsh-you-should-use..."
    paru -S --noconfirm zsh-you-should-use
    print_success "zsh-you-should-use installed"
else
    print_success "zsh-you-should-use already installed"
fi

# zsh-auto-notify
if [ ! -d "/usr/share/zsh/plugins/zsh-auto-notify" ]; then
    print_info "Installing zsh-auto-notify..."
    paru -S --noconfirm zsh-auto-notify
    print_success "zsh-auto-notify installed"
else
    print_success "zsh-auto-notify already installed"
fi

# ============================================================================
# Initialize PyWAL
# ============================================================================

print_header "Initializing PyWAL Theme System"

if [ -d "$DOTFILES_DIR/Wallpapers" ] && [ "$(ls -A "$DOTFILES_DIR/Wallpapers" 2>/dev/null)" ]; then
    # Find first wallpaper
    first_wallpaper=$(find "$DOTFILES_DIR/Wallpapers" -type f \( -name "*.jpg" -o -name "*.png" \) | head -n 1)

    if [ -n "$first_wallpaper" ]; then
        print_info "Generating color scheme from: $(basename "$first_wallpaper")"
        wal -i "$first_wallpaper" -n
        print_success "PyWAL theme generated"
    else
        print_warning "No wallpapers found in Wallpapers/ directory"
        print_info "Add wallpapers to $DOTFILES_DIR/Wallpapers/ and run: wal -i /path/to/wallpaper.jpg"
    fi
else
    print_warning "Wallpapers directory is empty"
    print_info "Add wallpapers to $DOTFILES_DIR/Wallpapers/"
    print_info "Then run: wal -i /path/to/wallpaper.jpg"
fi

# ============================================================================
# Set Zsh as Default Shell
# ============================================================================

print_header "Setting Up Shell"

if [ "$SHELL" != "$(which zsh)" ]; then
    if ask_confirmation "Set Zsh as default shell?"; then
        chsh -s "$(which zsh)"
        print_success "Zsh set as default shell"
        print_info "Log out and back in for this to take effect"
    else
        print_info "Skipped setting Zsh as default"
    fi
else
    print_success "Zsh is already the default shell"
fi

# ============================================================================
# Post-Installation Instructions
# ============================================================================

print_header "Installation Complete!"

echo ""
print_success "Dotfiles installed successfully!"
echo ""
print_info "Backup saved to: $BACKUP_DIR"
echo ""
echo "Next steps:"
echo "  1. Add wallpapers to $DOTFILES_DIR/Wallpapers/"
echo "  2. Log out and log back in (or restart)"
echo "  3. Launch Hyprland"
echo "  4. Press SUPER+A to select a wallpaper and generate theme"
echo "  5. Customize settings in ~/.config/hypr/keywords/keywords.conf"
echo ""
echo "Configuration locations:"
echo "  - Hyprland: ~/.config/hypr/hyprland.conf"
echo "  - Keybinds: ~/.config/hypr/keybinds/keybinds.conf"
echo "  - Zsh: ~/.config/zsh/.zshrc"
echo "  - Aliases: ~/.config/aliasrc"
echo ""
echo "Useful commands:"
echo "  hyprctl reload          - Reload Hyprland configuration"
echo "  source ~/.config/zsh/.zshrc  - Reload shell configuration"
echo "  wal -i /path/to/image   - Change theme"
echo ""
print_success "Enjoy your new setup!"
echo ""
