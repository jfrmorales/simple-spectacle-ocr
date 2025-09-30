#!/usr/bin/env bash
#
# Uninstallation script for Spectacle OCR
#

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Paths
BIN_DIR="$HOME/.local/bin"
DESKTOP_DIR="$HOME/.local/share/applications"
CONFIG_DIR="$HOME/.config/spectacle-ocr"

# Files to remove (including old versions)
FILES_TO_REMOVE=(
    "$BIN_DIR/ocr-spectacle.sh"
    "$BIN_DIR/ocr-clipboard"
    "$DESKTOP_DIR/ocr-from-image-file.desktop"
    "$DESKTOP_DIR/ocr-from-clipboard.desktop"
    # Old versions (backwards compatibility)
    "$DESKTOP_DIR/spectacle-ocr.desktop"
    "$DESKTOP_DIR/ocr-clipboard.desktop"
    "$DESKTOP_DIR/spectacle-ocr-integration.desktop"
    "$DESKTOP_DIR/net.local.ocr-clipboard.desktop"
)

echo -e "${YELLOW}=== Spectacle OCR Uninstaller ===${NC}\n"

# Check if running with -y or --yes flag
SKIP_CONFIRM=false
if [[ "${1:-}" == "-y" ]] || [[ "${1:-}" == "--yes" ]]; then
    SKIP_CONFIRM=true
fi

# List files that will be removed
echo "The following files will be removed:"
echo ""

FOUND_FILES=false
for file in "${FILES_TO_REMOVE[@]}"; do
    if [[ -f "$file" ]]; then
        echo -e "  ${RED}✗${NC} $file"
        FOUND_FILES=true
    fi
done

if [[ -d "$CONFIG_DIR" ]]; then
    echo -e "  ${RED}✗${NC} $CONFIG_DIR/ (configuration directory)"
    FOUND_FILES=true
fi

if [[ "$FOUND_FILES" == false ]]; then
    echo -e "${YELLOW}No Spectacle OCR files found.${NC}"
    echo "It looks like Spectacle OCR is not installed or already removed."
    exit 0
fi

echo ""

# Ask for confirmation unless -y flag is used
if [[ "$SKIP_CONFIRM" == false ]]; then
    read -p "Do you want to proceed with uninstallation? [y/N] " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo -e "${YELLOW}Uninstallation cancelled.${NC}"
        exit 0
    fi
    echo ""
fi

# Remove files
echo "Removing files..."

for file in "${FILES_TO_REMOVE[@]}"; do
    if [[ -f "$file" ]]; then
        rm -f "$file"
        echo -e "${GREEN}✓${NC} Removed: $file"
    fi
done

# Remove configuration directory
if [[ -d "$CONFIG_DIR" ]]; then
    rm -rf "$CONFIG_DIR"
    echo -e "${GREEN}✓${NC} Removed: $CONFIG_DIR/"
fi

echo ""

# Update MIME database
echo "Updating MIME database..."
if command -v update-desktop-database &>/dev/null; then
    update-desktop-database "$DESKTOP_DIR" 2>/dev/null || true
    echo -e "${GREEN}✓${NC} MIME database updated"
else
    echo -e "${YELLOW}⚠${NC}  update-desktop-database not found, skipping..."
fi

echo ""
echo -e "${GREEN}=== Uninstallation Complete ===${NC}"
echo ""
echo "Spectacle OCR has been successfully removed from your system."
echo ""
echo "If you want to reinstall, run: ./install.sh"
echo ""