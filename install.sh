# Not Good at docs, but here goes nothing

# This script installs and configures various dotfiles and applications for a personalized Linux environment.
# Designed to be run on a Linux system with a Gnome desktop environment.
# It sets up Zsh, Oh My Zsh, Gnome themes, fonts, wallpapers
# and other applications, while also creating necessary symlinks and backups.
# It also installs dependencies and applies Gnome Shell extensions.
# Usage: Run this script in your terminal to set up your environment.
# Not tested yet, use at your own risk.
# Make sure to run this script with appropriate permissions, e.g., using sudo if necessary.
# Ensure you have a backup of your important files before running this script.

# This script is intended for personal use and may require modifications for different setups.
# It is recommended to review the script before running it to ensure it meets your needs.

# Author Info
# Username: Emiii
# Email: fiaromiangaly@gmail.com
# GitHub: Emii-lia
# Date: 2025-08-20
# Version: 1.0
# License: MIT License

#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/.dotfiles_backup"

# ===== Utils =====

have () {
    command -v "$1" >/dev/null 2>&1
}

backup () {
    local path="$1"

    if [ -e "$path" ] && [ ! -L "$path" ]; then
        mkdir -p "$BACKUP_DIR"
        echo "📋 Backing up $path to $BACKUP_DIR"
        mv "$path" "$BACKUP_DIR/"
    fi
}
extract_all () {
    local src="$1" dest="$2"

    [ -d "$src" ] || return 0
    shopt -s nullglob
    for file in "$src"/*; do
        case "$file" in
            *.tar.gz|*.tgz) tar -xzf "$file" -C "$dest" ;;
            *.tar.bz2|*.tbz2) tar -xjf "$file" -C "$dest" ;;
            *.tar.xz|*.txz) tar -xJf "$file" -C "$dest" ;;
            *.zip) unzip -q "$file" -d "$dest" ;;
            *) echo "Unsupported file type: $file" ;;
        esac  
}

# === Installation ===

# === Backup existing dotfiles ===

backup_files () {
    echo "🔄 Backing up existing dotfiles..."
    backup "$HOME/.zshrc"
    backup "$HOME/.zsh-config"
    backup "$HOME/.oh-my-zsh/custom/themes/custom-passion.zsh-theme"
    backup "$HOME/.config/neofetch"
    backup "$HOME/.config/kitty"
    backup "$HOME/.config/conky"
    backup "$HOME/.config/gnome-pie"
    backup "$HOME/.config/cowsay"
    backup "$HOME/.config/autostart"
    backup "$HOME/.config/gtk-3.0"
    backup "$HOME/.config/gtk-4.0"
    backup "$HOME/.config/fontconfig"
    echo "✅ Backup completed."
}

# === Install dependencies ===
install_dependencies () {
    echo "🔧 Installing dependencies..."
    if have apt-get; then
        sudo apt-get update
        sudo apt-get install -y zsh kitty conky neofetch unzip curl git rsync jq \
      gnome-tweaks gnome-shell-extensions fonts-firacode fonts-noto sddm cowsay oneko xpenguins
    elif have pacman; then
        sudo pacman -Syu --noconfirm zsh kitty conky neofetch unzip curl git rsync jq \
      gnome-tweaks gnome-shell-extensions fonts-firacode fonts-noto sddm cowsay oneko xpenguins
    elif have dnf; then
        sudo dnf install -y zsh kitty conky neofetch unzip curl git rsync jq \
      gnome-tweaks gnome-shell-extensions fonts-firacode fonts-noto sddm cowsay oneko xpenguins
    else
        echo "Unsupported package manager. Please install dependencies manually."
        exit 1
    fi
    echo "✅ Dependencies installed."
}

# === Gnome Shell Extensions ===
install_gnome_extensions () {
    echo "🔌 Installing Gnome Shell extensions..."

    LIST_FILE="$DOTFILES_DIR/desktop/gnome-extensions/extensions.list"
    if [ -f "$LIST_FILE" ]; then
        while IFS= read -r extension; do
            echo "Installing $extension..."
            gnome-extensions install "$extension" --force || echo "Failed to install $extension"
        done < "$LIST_FILE"
    else
        echo "No Gnome Shell extensions list found at $LIST_FILE"
    fi

    gnome-extensions enable user-theme@gnome-shell-extensions.gcampax.github.com || true
}

# === Shell ===

setup_shell () {
    echo "🔄 Setting up zsh"
    cp -rT "$DOTFILES_DIR/shell" "$HOME"
    # using zsh as default shell
    if ! grep -q "^$USER:.*:$(which zsh)" /etc/passwd; then
        echo "Changing default shell to zsh..."
        chsh -s "$(which zsh)" "$USER"
    fi
    echo "✅ Zsh setup completed."
}

# === Oh My Zsh ===

setup_oh_my_zsh () {
    echo "🔄 Setting up Oh My Zsh"
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        echo "Oh My Zsh is already installed."
    fi
    # Link custom theme
    mkdir -p "$HOME/.oh-my-zsh/custom/themes"
    create_link "$DOTFILES_DIR/oh-my-zsh/themes/custom-passion.zsh-theme" "$HOME/.oh-my-zsh/custom/themes/custom-passion.zsh-theme"
    echo "✅ Oh My Zsh setup completed."
}

# === Gnome Themes ===
setup_gnome_themes () {
    echo "🔄 Setting up Gnome themes and icons"
    mkdir -p "$HOME/.themes"
    mkdir -p "$HOME/.icons"
    extract_all "$DOTFILES_DIR/config/themes" "$HOME/.themes"
    extract_all "$DOTFILES_DIR/config/icons" "$HOME/.icons"

    # Set default theme and icons
    gsettings set org.gnome.desktop.interface gtk-theme "Lavanda-Sea-Dark-Customised"
    gsettings set org.gnome.desktop.interface icon-theme "Slot-Dark-Icons"
    gsettings set org.gnome.desktop.interface cursor-theme "Bocchi-The-Cursor"
    gsettings set org.gnome.shell.extensions.user-theme name "Orchis-Dark-Customised"

    echo "✅ Gnome themes and icons setup completed."
}

# === Fonts ===
install_fonts () {
    echo "🔄 Installing fonts"
    mkdir -p "$HOME/.local/share/fonts"
    cp -rT "$DOTFILES_DIR/desktop/fonts" "$HOME/.local/share/fonts"
    fc-cache -fv
    echo "✅ Fonts installed."
}

# === Wallpapers ===
set_wallpapers () {
    echo "🔄 Setting up wallpapers"
    WALLS="$DOTFILES_DIR/desktop/wallpapers"
    DEFAULT="$(find "$WALLS" -type f -iname '*.jpg' -o -iname '*.png' | sort | head -n1)"
    mkdir -p "$HOME/Pictures/Wallpapers"
    cp -rT "$DOTFILES_DIR/desktop/wallpapers" "$HOME/Pictures/Wallpapers"
    [ -n "$DEFAULT" ] || return 0
    gsettings set org.gnome.desktop.background picture-uri "file://$DEFAULT"
    gsettings set org.gnome.desktop.background picture-uri-dark "file://$DEFAULT" || true
    gsettings set org.gnome.desktop.screensaver picture-uri "file://$DEFAULT" || true
    echo "✅ Wallpapers set."
}

# === Dconf ===
apply_dconf_settings () {
    echo "🔄 Applying dconf settings"
    if [ -f "$DOTFILES_DIR/system/dconf-settings.ini" ]; then
        dconf load / < "$DOTFILES_DIR/system/dconf-settings.ini"
    else
        echo "No dconf settings file found."
    fi
    echo "✅ Dconf settings applied."
}

# === Create symlinks for dotfiles ===
link_configs () {
    echo "🔗 Creating symlinks for dotfiles..."
    link () {
        local src="$1" dest="$2"
        mkdir -p "$(dirname "$dest")"
        [ -e "$dest"] && rm -rf "$dest"
        ln -s "$src" "$dest"
    }
    [ -d "$DOTFILES_DIR/config/kitty" ] && link "$DOTFILES_DIR/config/kitty" "$HOME/.config/kitty"
    [ -d "$DOTFILES_DIR/config/conky" ] && link "$DOTFILES_DIR/config/conky" "$HOME/.config/conky"
    [ -d "$DOTFILES_DIR/config/neofetch" ] && link "$DOTFILES_DIR/config/neofetch" "$HOME/.config/neofetch"
    [ -d "$DOTFILES_DIR/config/gnome-pie" ] && link "$DOTFILES_DIR/config/gnome-pie" "$HOME/.config/gnome-pie"
    [ -d "$DOTFILES_DIR/config/cowsay" ] && link "$DOTFILES_DIR/config/cowsay" "$HOME/.config/cowsay"
}

# === Autostart ===
setup_autostart () {
    echo "🔄 Setting up autostart applications"
    AUTOSTART_SRC="$DOTFILES_DIR/desktop/autostart"
    AUTOSTART_DEST="$HOME/.config/autostart"
    [ -d "$AUTOSTART_SRC" ] && mkdir -p "$AUTOSTART_DEST" && cp -rT "$AUTOSTART_SRC" "$AUTOSTART_DEST"
    echo "✅ Autostart applications set."
}

# === Default Apps ===

set_default_apps () {
    echo "🔄 Setting default applications"
    if command -v kitty >/dev/null; then
        if command -v update-alternatives >/dev/null; then
            sudo update-alternatives --set x-terminal-emulator "$(which kitty)" || true
        fi
        gsettings set org.gnome.desktop.default-applications.terminal exec "kitty" || true
        gsettings set org.gnome.desktop.default-applications.terminal exec-arg "-e" || true
    fi
}

# === Other Apps ===
setup_apps () {
    echo "🔄 Setting up other applications"
    # Install Conky startup script
    if [ -d "$DOTFILES_DIR/apps/conky" ]; then
        CONKY_STARTUP="$DOTFILES_DIR/apps/conky/conky-startup.sh"
        if [ -f "$CONKY_STARTUP" ]; then
            cp "$CONKY_STARTUP" "$HOME/.config/conky/conky-startup.sh"
            chmod +x "$HOME/.config/conky/conky-startup.sh"
        fi
        echo "Setting up Conky configurations..."   
        rsync -avh --delete "$DOTFILES_DIR/apps/conky" "$HOME/.config/conky"
        chmod +x "$HOME/.config/conky/conky-startup.sh"
        echo "✅ Conky setup completed."
    fi

    # Install Gnome Pie
    if [ -d "$DOTFILES_DIR/apps/gnome-pie" ]; then
        rsync -avh --delete "$DOTFILES_DIR/apps/gnome-pie" "$HOME/.config/gnome-pie"  
    fi

    # Install Cowsay
    if [ -d "$DOTFILES_DIR/apps/cowsay" ]; then
        mkdir -p "$HOME/.cowsay/cowfiles"
        cp -rT "$DOTFILES_DIR/apps/cowsay" "$HOME/.cowsay/cowfiles"
        echo "✅ Cowsay setup completed."
    fi
}

# === Sddm script ===

setup_sddm () {
    echo "🔄 Setting up SDDM script"
    SDDM_SCRIPT="$DOTFILES_DIR/system/sddm/setup.sh"
    if [ -f "$SDDM_SCRIPT" ]; then
        sudo bash "$SDDM_SCRIPT"
        echo "✅ SDDM script executed."
    else
        echo "No SDDM setup script found."
    fi
}

# === Main Execution ===
main () {
    backup_files
    install_dependencies
    install_gnome_extensions
    setup_shell
    setup_oh_my_zsh
    setup_gnome_themes
    install_fonts
    set_wallpapers
    apply_dconf_settings
    link_configs
    setup_autostart
    set_default_apps
    setup_apps
    setup_sddm
    echo "🎉 Dotfiles installation completed successfully!"
}

main "$@"