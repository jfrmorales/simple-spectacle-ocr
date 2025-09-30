#!/usr/bin/env bash
#
# OCR from Clipboard
# Wrapper script that reads image from clipboard and performs OCR
#

# Call the main OCR script without arguments to read from clipboard
exec "$HOME/.local/bin/ocr-spectacle.sh"