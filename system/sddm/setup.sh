#!/usr/bin/env bash
set -e

# Predefined setup for Japanese aesthetic variant of Astronaut SDDM theme
THEME_REPO="https://github.com/Keyitdev/sddm-astronaut-theme.git"
THEME_NAME="sddm-astronaut-theme"
TARGET_DIR="/usr/share/sddm/themes/$THEME_NAME"
CUSTOM_MAIN="$HOME/dotfiles/system/sddm/Main.qml"

green='\033[0;32m'
red='\033[0;31m'
no_color='\033[0m'

echo -e "${green}[*] Installing dependencies...${no_color}"
if command -v pacman >/dev/null; then
    sudo pacman --noconfirm --needed -S sddm qt6-svg qt6-virtualkeyboard qt6-multimedia-ffmpeg
elif command -v apt >/dev/null; then
    sudo apt install -y sddm qml6-module-qtquick-controls qml6-module-qtquick-virtualkeyboard qml6-module-qtmultimedia qml6-module-qt5compat-graphicaleffects qml6-module-qtquick-shapes
elif command -v dnf >/dev/null; then
    sudo dnf install -y sddm qt6-qtsvg qt6-qtvirtualkeyboard qt6-qtmultimedia
fi

echo -e "${green}[*] Cloning SDDM theme...${no_color}"
rm -rf "/tmp/$THEME_NAME"
git clone --depth=1 "$THEME_REPO" "/tmp/$THEME_NAME"

echo -e "${green}[*] Installing SDDM theme to $TARGET_DIR...${no_color}"
sudo rm -rf "$TARGET_DIR"
sudo mkdir -p "$TARGET_DIR"
sudo cp -r "/tmp/$THEME_NAME"/* "$TARGET_DIR/"

# Apply your custom Main.qml
if [ -f "$CUSTOM_MAIN" ]; then
    echo -e "${green}[*] Applying custom Main.qml...${no_color}"
    sudo cp "$CUSTOM_MAIN" "$TARGET_DIR/Main.qml"
fi

# Japanese aesthetic variant
METADATA="$TARGET_DIR/metadata.desktop"
sudo sed -i "s|^ConfigFile=Themes/.*|ConfigFile=Themes/japanese_aesthetic.conf|" "$METADATA"
echo -e "${green}[*] Japanese aesthetic theme selected.${no_color}"

# Enable theme in sddm.conf
echo "[Theme]
Current=$THEME_NAME" | sudo tee /etc/sddm.conf > /dev/null
echo "[General]
InputMethod=qtvirtualkeyboard" | sudo tee /etc/sddm.conf.d/virtualkbd.conf > /dev/null

# Enable SDDM
echo -e "${green}[*] Enabling SDDM...${no_color}"
sudo systemctl disable display-manager.service || true
sudo systemctl enable sddm.service
sudo systemctl set-default graphical.target

echo -e "${green}SDDM Astronaut theme installed with Japanese aesthetic ✅${no_color}"

