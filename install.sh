#!/usr/bin/env bash
#
# Installation script for Spectacle OCR
#

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_DIR="$HOME/.local/bin"
DESKTOP_DIR="$HOME/.local/share/applications"
CONFIG_DIR="$HOME/.config/spectacle-ocr"

echo -e "${GREEN}=== Spectacle OCR Installation ===${NC}\n"

# Check dependencies
echo "Checking dependencies..."
MISSING_DEPS=()

if ! command -v tesseract &>/dev/null; then
    MISSING_DEPS+=("tesseract")
fi

if ! command -v magick &>/dev/null && ! command -v convert &>/dev/null; then
    MISSING_DEPS+=("imagemagick")
fi

if ! command -v wl-copy &>/dev/null && ! command -v xclip &>/dev/null; then
    MISSING_DEPS+=("wl-clipboard or xclip")
fi

if ! command -v notify-send &>/dev/null; then
    MISSING_DEPS+=("libnotify (notify-send)")
fi

if [ ${#MISSING_DEPS[@]} -ne 0 ]; then
    echo -e "${RED}Error: Missing dependencies:${NC}"
    for dep in "${MISSING_DEPS[@]}"; do
        echo "  - $dep"
    done
    echo -e "\n${YELLOW}Install them with:${NC}"
    echo ""
    echo "  Arch Linux (install language packs first to avoid interactive prompt):"
    echo "    sudo pacman -S tesseract-data-eng tesseract-data-spa"
    echo "    sudo pacman -S tesseract imagemagick wl-clipboard libnotify"
    echo ""
    echo "  Ubuntu/Debian:"
    echo "    sudo apt install tesseract-ocr tesseract-ocr-eng tesseract-ocr-spa imagemagick wl-clipboard libnotify-bin"
    exit 1
fi

echo -e "${GREEN}✓${NC} All dependencies found\n"

# Create directories if they don't exist
mkdir -p "$BIN_DIR"
mkdir -p "$DESKTOP_DIR"
mkdir -p "$CONFIG_DIR"

# Install scripts
echo "Installing OCR scripts..."
cp "$SCRIPT_DIR/ocr-spectacle.sh" "$BIN_DIR/ocr-spectacle.sh"
chmod +x "$BIN_DIR/ocr-spectacle.sh"
cp "$SCRIPT_DIR/ocr-clipboard.sh" "$BIN_DIR/ocr-clipboard"
chmod +x "$BIN_DIR/ocr-clipboard"
echo -e "${GREEN}✓${NC} Scripts installed:"
echo "  - $BIN_DIR/ocr-spectacle.sh (main script)"
echo -e "  - $BIN_DIR/ocr-clipboard (clipboard wrapper)\n"

# Install desktop files
echo "Installing desktop integration..."
cp "$SCRIPT_DIR/ocr-from-image-file.desktop" "$DESKTOP_DIR/ocr-from-image-file.desktop"
cp "$SCRIPT_DIR/ocr-from-clipboard.desktop" "$DESKTOP_DIR/ocr-from-clipboard.desktop"
echo -e "${GREEN}✓${NC} Desktop files installed:"
echo "  - ocr-from-image-file.desktop (Right-click on image files)"
echo -e "  - ocr-from-clipboard.desktop (For keyboard shortcut)\n"

# Update MIME database
echo "Updating MIME database..."
if command -v update-desktop-database &>/dev/null; then
    update-desktop-database "$DESKTOP_DIR"
    echo -e "${GREEN}✓${NC} MIME database updated\n"
else
    echo -e "${YELLOW}⚠${NC}  update-desktop-database not found, skipping...\n"
fi

# Check for language packs
echo "Checking Tesseract language packs..."
INSTALLED_LANGS=$(tesseract --list-langs 2>/dev/null | tail -n +2 | tr '\n' ' ')
echo "Installed languages: $INSTALLED_LANGS"
echo ""

# Language configuration
if [[ ! -f "$CONFIG_DIR/config" ]]; then
    echo "Configuring OCR language..."
    echo ""
    echo "Available common language packs:"
    echo "  30) tesseract-data-eng  - English"
    echo "  103) tesseract-data-spa - Spanish"
    echo "  40) tesseract-data-fra  - French"
    echo "  25) tesseract-data-deu  - German"
    echo "  92) tesseract-data-por  - Portuguese"
    echo "  58) tesseract-data-ita  - Italian"
    echo ""
    echo "Install language packs with:"
    echo "  sudo pacman -S tesseract-data-eng tesseract-data-spa"
    echo ""

    read -p "Enter OCR language code(s) [eng]: " USER_LANG
    USER_LANG="${USER_LANG:-eng}"

    echo "# Spectacle OCR Configuration" > "$CONFIG_DIR/config"
    echo "# Language codes for Tesseract OCR" >> "$CONFIG_DIR/config"
    echo "# Examples: eng, spa, eng+spa, eng+fra+deu" >> "$CONFIG_DIR/config"
    echo "OCR_LANG=\"$USER_LANG\"" >> "$CONFIG_DIR/config"

    echo -e "${GREEN}✓${NC} Configuration saved to $CONFIG_DIR/config\n"
else
    echo -e "${YELLOW}ℹ${NC}  Configuration file already exists at $CONFIG_DIR/config\n"
fi

echo -e "\n${GREEN}=== Installation Complete ===${NC}\n"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}📋 HOW TO USE${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${YELLOW}Method 1: From Clipboard with Keyboard Shortcut (RECOMMENDED)${NC}"
echo "  This is the fastest method for daily use!"
echo ""
echo "  1️⃣  Configure keyboard shortcut:"
echo "      • Open: System Settings → Shortcuts → Custom Shortcuts"
echo "      • Click: Edit → New → Global Shortcut → Command/URL"
echo "      • Name: OCR from Clipboard"
echo "      • Command: ocr-clipboard"
echo "      • Trigger: Assign your preferred key (e.g., Meta+Shift+T)"
echo ""
echo "  2️⃣  Daily workflow:"
echo "      • Take screenshot (Spectacle: Print Screen)"
echo "      • Press your shortcut key → Text copied to clipboard!"
echo "      • Paste anywhere (Ctrl+V)"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${YELLOW}Method 2: Right-Click on Image Files${NC}"
echo "  Use when you have an existing image file or screenshot"
echo ""
echo "  • Take screenshot with Spectacle (or any tool)"
echo "  • Right-click the image file → 'Extract Text (OCR)'"
echo "  • Text will be copied to clipboard"
echo "  • Works in any file manager (Dolphin, Nautilus, etc.)"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${YELLOW}Method 3: Command Line${NC}"
echo "  • From clipboard: ocr-clipboard"
echo "  • From file: ocr-spectacle.sh /path/to/image.png"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}⚙️  CONFIGURATION${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  Language configuration file: $CONFIG_DIR/config"
echo "  Current setting: $(grep OCR_LANG= $CONFIG_DIR/config 2>/dev/null || echo 'OCR_LANG="eng"')"
echo ""
echo "  To change OCR language:"
echo "    nano $CONFIG_DIR/config"
echo ""
echo "  Examples:"
echo "    OCR_LANG=\"eng\"          # English only"
echo "    OCR_LANG=\"spa\"          # Spanish only"
echo "    OCR_LANG=\"eng+spa\"      # English + Spanish"
echo ""
echo "  Install additional languages:"
echo "    sudo pacman -S tesseract-data-<lang>"
echo "    Available: eng spa fra deu por ita rus chi_sim jpn ara ..."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo -e "${GREEN}🧪 TESTING${NC}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  Test from command line:"
echo "    1. Take a screenshot (image will be in clipboard)"
echo "    2. Run: ocr-clipboard"
echo "    3. Paste the result: Ctrl+V"
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo -e "${GREEN}✨ Enjoy your new OCR superpower!${NC}"
echo ""