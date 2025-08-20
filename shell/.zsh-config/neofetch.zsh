# Load custom neofetch image from repo
if command -v neofetch >/dev/null; then
    IMAGE="$HOME/.config/neofetch/images/default.png"
    neofetch --kitty "$IMAGE"
fi
