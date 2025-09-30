#!/usr/bin/env bash
#
# OCR Script for Spectacle Screenshots
# Extracts text from images using Tesseract OCR
# Can read from file argument or clipboard
#

set -euo pipefail

CR=$(printf '\r')

# Configuration file path
CONFIG_DIR="$HOME/.config/spectacle-ocr"
CONFIG_FILE="$CONFIG_DIR/config"

# Read language configuration
# Priority: config file > environment variable > default
if [[ -f "$CONFIG_FILE" ]]; then
    source "$CONFIG_FILE"
    OCR_LANGUAGE="${OCR_LANG:-eng}"
elif [[ -n "${OCR_LANG:-}" ]]; then
    OCR_LANGUAGE="$OCR_LANG"
else
    OCR_LANGUAGE="eng"
fi

# Determine image source: file argument or clipboard
if [[ -n "${1:-}" ]]; then
    # Image provided as argument
    IMAGE="$1"
    DELETE_ORIGINAL=true

    if [[ ! -f "$IMAGE" ]]; then
        notify-send -i dialog-error "OCR Error" "No image file received"
        exit 1
    fi
else
    # Read image from clipboard
    IMAGE="/tmp/ocr_clipboard_$$.png"
    DELETE_ORIGINAL=true

    if command -v wl-paste &>/dev/null; then
        # Wayland
        if ! wl-paste --type image/png > "$IMAGE" 2>/dev/null; then
            notify-send -i dialog-error "OCR Error" "No image in clipboard"
            rm -f "$IMAGE"
            exit 1
        fi
    elif command -v xclip &>/dev/null; then
        # X11
        if ! xclip -selection clipboard -t image/png -o > "$IMAGE" 2>/dev/null; then
            notify-send -i dialog-error "OCR Error" "No image in clipboard"
            rm -f "$IMAGE"
            exit 1
        fi
    else
        notify-send -i dialog-error "OCR Error" "No clipboard tool found (wl-paste or xclip)"
        exit 1
    fi

    # Check if image was actually saved
    if [[ ! -s "$IMAGE" ]]; then
        notify-send -i dialog-error "OCR Error" "Clipboard does not contain an image"
        rm -f "$IMAGE"
        exit 1
    fi
fi

# Cleanup function to remove temp and original image
cleanup() {
    rm -f "$RESIZED"
    if [[ "$DELETE_ORIGINAL" == true ]]; then
        rm -f "$IMAGE"
    fi
}
trap cleanup EXIT

# Resize for better OCR accuracy
RESIZED="/tmp/ocr_resized_$$.png"
magick "$IMAGE" -resize 400% "$RESIZED"

# Perform OCR
OCR_OUTPUT=$(tesseract --psm 6 -l "$OCR_LANGUAGE" "$RESIZED" - 2>&1)
OCR_STATUS=$?

if [ $OCR_STATUS -ne 0 ]; then
    notify-send -i dialog-error "OCR Error" "Tesseract failed: $OCR_OUTPUT"
    exit 1
fi

# Normalize line endings
TEXT=$(echo "$OCR_OUTPUT" | sed "s/\$/${CR}/")

# Copy to clipboard (supports both Wayland and X11)
if command -v wl-copy &>/dev/null; then
    echo -n "$TEXT" | wl-copy
elif command -v xclip &>/dev/null; then
    echo -n "$TEXT" | xclip -selection clipboard
else
    notify-send -i dialog-error "OCR Error" "No clipboard tool found (wl-copy or xclip)"
    exit 1
fi

# Notify success
notify-send -i edit-paste "Text copied to clipboard"