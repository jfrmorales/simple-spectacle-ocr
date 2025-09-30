# Simple Spectacle OCR

[🇬🇧 English](README.md) | [🇪🇸 Español](README.es.md)

Simple bash scripts that add OCR (Optical Character Recognition) capabilities to your Linux workflow. Extract text from screenshots and clipboard images with a single command or keyboard shortcut.

**⚠️ Note:** This is a lightweight bash script solution. For a full-featured Qt application with GUI and advanced features, check out [spectacle-ocr-screenshot](https://github.com/funinkina/spectacle-ocr-screenshot/).

Based on the article: https://kozlev.com/ocr-for-spectacle/

## Features

- 🚀 Extract text from clipboard with keyboard shortcut
- 📁 Right-click OCR on image files (works with any file manager)
- 🌍 Multi-language support via Tesseract
- ⚡ Lightweight bash scripts (no GUI)
- 🖥️ Compatible with Wayland and X11
- 🔔 Desktop notifications
- 🧹 Automatic cleanup of temporary files

## Requirements

### Arch Linux - Complete Installation

**IMPORTANT**: Install language packs FIRST to avoid interactive prompts from pacman.

```bash
# Step 1: Install Tesseract language packs
# Choose the languages you need:

# English only
sudo pacman -S tesseract-data-eng

# English + Spanish (recommended)
sudo pacman -S tesseract-data-eng tesseract-data-spa

# Multiple languages
sudo pacman -S tesseract-data-eng tesseract-data-spa tesseract-data-fra tesseract-data-deu

# Step 2: Install tesseract and other dependencies
sudo pacman -S tesseract imagemagick wl-clipboard libnotify
```

**Why this order?** Tesseract requires at least one language pack (dependency `tessdata`). If you install language packs first, pacman won't ask which provider to use.

### Ubuntu/Debian - Complete Installation

```bash
# One command - install tesseract with languages and dependencies
# English only
sudo apt install tesseract-ocr tesseract-ocr-eng imagemagick wl-clipboard libnotify-bin

# English + Spanish (recommended)
sudo apt install tesseract-ocr tesseract-ocr-eng tesseract-ocr-spa imagemagick wl-clipboard libnotify-bin

# Multiple languages
sudo apt install tesseract-ocr tesseract-ocr-eng tesseract-ocr-spa tesseract-ocr-fra imagemagick wl-clipboard libnotify-bin
```

### Additional Languages

**Arch Linux - Available packages:**
- `tesseract-data-eng` - English
- `tesseract-data-spa` - Spanish
- `tesseract-data-fra` - French
- `tesseract-data-deu` - German
- `tesseract-data-por` - Portuguese
- `tesseract-data-ita` - Italian
- `tesseract-data-rus` - Russian
- `tesseract-data-chi_sim` - Simplified Chinese
- `tesseract-data-jpn` - Japanese
- `tesseract-data-ara` - Arabic

To install additional languages later:
```bash
sudo pacman -S tesseract-data-<lang>
```

**See all available languages:**
```bash
pacman -Ss tesseract-data  # Arch Linux
apt search tesseract-ocr   # Ubuntu/Debian
```

## Installation

1. Clone the repository:
```bash
git clone https://github.com/jfrmorales/simple-spectacle-ocr.git
cd simple-spectacle-ocr
```

2. Run the installation script:
```bash
chmod +x install.sh
./install.sh
```

The installer will:
- ✅ Verify all dependencies
- ✅ Install `ocr-spectacle.sh` to `~/.local/bin/`
- ✅ Install `ocr-clipboard` to `~/.local/bin/`
- ✅ Install `ocr-from-image-file.desktop` (context menu for image files)
- ✅ Install `ocr-from-clipboard.desktop` (for keyboard shortcuts)
- ✅ Create configuration file at `~/.config/spectacle-ocr/config`
- ✅ Ask you to choose OCR language
- ✅ Update MIME database
- ✅ Display detailed usage instructions

## Usage

### Method 1: From Clipboard (Recommended) 🚀

**The fastest method for daily use:**

1. Take a screenshot (Spectacle, Flameshot, or any tool)
2. The image is automatically in the clipboard
3. Run: `ocr-clipboard`
4. Extracted text will be copied to clipboard

**Configure keyboard shortcut (KDE Plasma):**
1. Open: System Settings → Shortcuts → Custom Shortcuts
2. Click: Edit → New → Global Shortcut → Command/URL
3. Name: OCR from Clipboard
4. Command: `ocr-clipboard`
5. Trigger: Assign your preferred key (e.g., `Meta+Shift+T`)

Now you can: **Screenshot → Hotkey → Text in clipboard** ⚡

### Method 2: From Image File (Context Menu)
1. Open any file manager (Dolphin, Nautilus, etc.)
2. Navigate to an image file (PNG, JPG, JPEG)
3. Right-click → **"Extract Text (OCR)"**
4. Text will be automatically copied to clipboard

**Works with:** Saved screenshots, downloaded images, photos, etc.

### Method 3: Command line with file
```bash
~/.local/bin/ocr-spectacle.sh /path/to/image.png
```

### Method 4: Directly from clipboard without wrapper
```bash
~/.local/bin/ocr-spectacle.sh
```

## Configuration

### Configuration System

The script reads configuration in the following priority order:
1. **Configuration file:** `~/.config/spectacle-ocr/config`
2. **Environment variable:** `OCR_LANG`
3. **Default:** `eng` (English)

### Method 1: Configuration file (Recommended)

Edit the configuration file:
```bash
nano ~/.config/spectacle-ocr/config
```

Change the language:
```bash
# Spectacle OCR Configuration
# Language codes for Tesseract OCR
# Examples: eng, spa, eng+spa, eng+fra+deu
OCR_LANG="eng+spa"
```

### Method 2: Environment variable

Temporary (current session only):
```bash
export OCR_LANG="eng+spa"
```

Permanent (add to `~/.bashrc` or `~/.zshrc`):
```bash
echo 'export OCR_LANG="eng+spa"' >> ~/.bashrc
source ~/.bashrc
```

### Common language codes:
- `eng` - English
- `spa` - Spanish
- `fra` - French
- `deu` - German
- `por` - Portuguese
- `ita` - Italian
- `rus` - Russian
- `chi_sim` - Simplified Chinese
- `jpn` - Japanese
- `ara` - Arabic

### Multiple languages:
```bash
OCR_LANG="eng+spa"           # English + Spanish
OCR_LANG="eng+fra+deu"       # English + French + German
OCR_LANG="spa+por"           # Spanish + Portuguese
```

### Check installed languages:
```bash
tesseract --list-langs
```

## How It Works

### Clipboard Mode (ocr-clipboard):
1. **Read image**: Extracts image from clipboard using wl-paste (Wayland) or xclip (X11)
2. **Resize**: ImageMagick increases size to 400% for better accuracy
3. **OCR**: Tesseract processes the image and extracts text
4. **Result**: Copies text to clipboard
5. **Notification**: Shows success notification
6. **Cleanup**: Automatically removes temporary files

### File Mode (Spectacle integration):
1. **Screenshot**: Spectacle saves the image temporarily
2. **Resize**: ImageMagick increases size to 400% for better accuracy
3. **OCR**: Tesseract processes the image and extracts text
4. **Clipboard**: Copies text to clipboard
5. **Notification**: Shows success notification
6. **Cleanup**: Automatically removes temporary files

## Troubleshooting

### Text is not copied to clipboard
**Problem:** Script runs but text doesn't appear in clipboard

**Solutions:**
- Verify `wl-clipboard` (Wayland) or `xclip` (X11) are installed
- Test manually:
  ```bash
  echo "test" | wl-copy && wl-paste    # Wayland
  echo "test" | xclip -selection clipboard && xclip -selection clipboard -o  # X11
  ```

### OCR not working correctly / Incorrect text
**Problem:** OCR doesn't recognize text properly

**Solutions:**
- Verify language pack is installed: `tesseract --list-langs`
- Install correct language pack: `sudo pacman -S tesseract-data-spa`
- Check configuration: `cat ~/.config/spectacle-ocr/config`
- Try with higher quality/resolution images
- Adjust resize percentage in `~/.local/bin/ocr-spectacle.sh` (line 41)

### Option doesn't appear in context menu
**Problem:** Don't see "Extract Text (OCR)" when right-clicking

**Solutions:**
- Update MIME database:
  ```bash
  update-desktop-database ~/.local/share/applications/
  ```
- Completely restart file manager
- Verify desktop file is correctly installed:
  ```bash
  ls -la ~/.local/share/applications/ocr-from-image-file.desktop
  ```
- Verify script permissions:
  ```bash
  ls -la ~/.local/bin/ocr-spectacle.sh
  chmod +x ~/.local/bin/ocr-spectacle.sh  # If needed
  ```

### Error "No image file received"
**Problem:** Error notification appears when executing

**Solutions:**
- Verify that the screenshot tool is passing the file correctly
- Test manually with an image:
  ```bash
  ~/.local/bin/ocr-spectacle.sh /path/to/image.png
  ```
- Check system logs: `journalctl -f` (while running the script)

### Language change has no effect
**Problem:** Changed configuration but still using English

**Solutions:**
- Verify configuration file content:
  ```bash
  cat ~/.config/spectacle-ocr/config
  ```
- Ensure language is installed: `tesseract --list-langs`
- Test directly with environment variable:
  ```bash
  OCR_LANG="spa" ~/.local/bin/ocr-spectacle.sh /path/to/image.png
  ```

## Uninstallation

### Method 1: Automatic script (Recommended)

```bash
chmod +x uninstall.sh
./uninstall.sh
```

To uninstall without confirmation:
```bash
./uninstall.sh -y
```

### Method 2: Manual

```bash
rm ~/.local/bin/ocr-spectacle.sh
rm ~/.local/bin/ocr-clipboard
rm ~/.local/share/applications/ocr-from-image-file.desktop
rm ~/.local/share/applications/ocr-from-clipboard.desktop
rm -rf ~/.config/spectacle-ocr
update-desktop-database ~/.local/share/applications/
```

## Credits

- Original idea and article: [Kaloian Kozlev](https://kozlev.com/ocr-for-spectacle/)
- Implementation: Based on the above article

## License

MIT License