# Simple Spectacle OCR

Simple bash scripts that add OCR (Optical Character Recognition) capabilities to your Linux workflow. Extract text from screenshots and clipboard images with a single command or keyboard shortcut.

**⚠️ Note:** This is a lightweight bash script solution. For a full-featured Qt application with GUI and advanced features, check out [spectacle-ocr-screenshot](https://github.com/funinkina/spectacle-ocr-screenshot/).

Basado en el artículo: https://kozlev.com/ocr-for-spectacle/

## Características

- 🚀 Extract text from clipboard with keyboard shortcut
- 📁 Right-click OCR on image files (works with any file manager)
- 🌍 Multi-language support via Tesseract
- ⚡ Lightweight bash scripts (no GUI)
- 🖥️ Compatible with Wayland and X11
- 🔔 Desktop notifications
- 🧹 Automatic cleanup of temporary files

## Requisitos

### Arch Linux - Instalación Completa

**IMPORTANTE**: Instala los paquetes de idioma PRIMERO para evitar preguntas interactivas de pacman.

```bash
# Paso 1: Instalar paquetes de idioma de Tesseract
# Elige los idiomas que necesites:

# Solo inglés
sudo pacman -S tesseract-data-eng

# Inglés + Español (recomendado)
sudo pacman -S tesseract-data-eng tesseract-data-spa

# Múltiples idiomas
sudo pacman -S tesseract-data-eng tesseract-data-spa tesseract-data-fra tesseract-data-deu

# Paso 2: Instalar tesseract y el resto de dependencias
sudo pacman -S tesseract imagemagick wl-clipboard libnotify
```

**¿Por qué en este orden?** Tesseract requiere al menos un paquete de idioma (dependencia `tessdata`). Si instalas los idiomas primero, pacman no preguntará qué idioma usar.

### Ubuntu/Debian - Instalación Completa

```bash
# Un solo comando - instala tesseract con idiomas y dependencias
# Solo inglés
sudo apt install tesseract-ocr tesseract-ocr-eng imagemagick wl-clipboard libnotify-bin

# Inglés + Español (recomendado)
sudo apt install tesseract-ocr tesseract-ocr-eng tesseract-ocr-spa imagemagick wl-clipboard libnotify-bin

# Múltiples idiomas
sudo apt install tesseract-ocr tesseract-ocr-eng tesseract-ocr-spa tesseract-ocr-fra imagemagick wl-clipboard libnotify-bin
```

### Idiomas Adicionales

**Arch Linux - Paquetes disponibles:**
- `tesseract-data-eng` - Inglés
- `tesseract-data-spa` - Español
- `tesseract-data-fra` - Francés
- `tesseract-data-deu` - Alemán
- `tesseract-data-por` - Portugués
- `tesseract-data-ita` - Italiano
- `tesseract-data-rus` - Ruso
- `tesseract-data-chi_sim` - Chino simplificado
- `tesseract-data-jpn` - Japonés
- `tesseract-data-ara` - Árabe

Para instalar idiomas adicionales después:
```bash
sudo pacman -S tesseract-data-<idioma>
```

**Ver todos los idiomas disponibles:**
```bash
pacman -Ss tesseract-data  # Arch Linux
apt search tesseract-ocr   # Ubuntu/Debian
```

## Instalación

1. Clonar el repositorio:
```bash
git clone <repository-url>
cd spectacle-ocr
```

2. Ejecutar el script de instalación:
```bash
chmod +x install.sh
./install.sh
```

El instalador:
- ✅ Verificará todas las dependencias
- ✅ Instalará `ocr-spectacle.sh` en `~/.local/bin/`
- ✅ Instalará `ocr-clipboard` en `~/.local/bin/`
- ✅ Instalará `ocr-from-image-file.desktop` (menú contextual para archivos de imagen)
- ✅ Instalará `ocr-from-clipboard.desktop` (para atajos de teclado)
- ✅ Creará archivo de configuración en `~/.config/spectacle-ocr/config`
- ✅ Te pedirá elegir el idioma OCR
- ✅ Actualizará la base de datos MIME
- ✅ Mostrará instrucciones detalladas de uso

## Uso

### Método 1: Desde Portapapeles (Recomendado) 🚀

**El método más rápido y conveniente:**

1. Tomar una captura de pantalla (Spectacle, Flameshot, o cualquier herramienta)
2. La imagen queda automáticamente en el portapapeles
3. Ejecutar: `ocr-clipboard`
4. El texto extraído será copiado al portapapeles

**Configurar atajo de teclado (KDE Plasma):**
1. Abrir Configuración del Sistema → Atajos
2. Crear nuevo atajo personalizado
3. Comando: `ocr-clipboard`
4. Asignar tecla (ej: `Meta+Shift+T`)

Ahora puedes hacer: **Captura → Hotkey → Texto en portapapeles** ⚡

### Método 2: Desde Archivo de Imagen (Menú Contextual)
1. Abrir cualquier gestor de archivos (Dolphin, Nautilus, etc.)
2. Navegar a un archivo de imagen (PNG, JPG, JPEG)
3. Hacer clic derecho → **"Extract Text (OCR)"**
4. El texto será copiado automáticamente al portapapeles

**Funciona con:** Capturas de pantalla guardadas, imágenes descargadas, fotos, etc.

### Método 3: Línea de comandos con archivo
```bash
~/.local/bin/ocr-spectacle.sh /path/to/image.png
```

### Método 4: Directamente desde portapapeles sin wrapper
```bash
~/.local/bin/ocr-spectacle.sh
```

## Configuración

### Sistema de Configuración

El script lee la configuración en el siguiente orden de prioridad:
1. **Archivo de configuración:** `~/.config/spectacle-ocr/config`
2. **Variable de entorno:** `OCR_LANG`
3. **Default:** `eng` (Inglés)

### Método 1: Archivo de configuración (Recomendado)

Edita el archivo de configuración:
```bash
nano ~/.config/spectacle-ocr/config
```

Cambia el idioma:
```bash
# Spectacle OCR Configuration
# Language codes for Tesseract OCR
# Examples: eng, spa, eng+spa, eng+fra+deu
OCR_LANG="eng+spa"
```

### Método 2: Variable de entorno

Temporal (solo para la sesión actual):
```bash
export OCR_LANG="eng+spa"
```

Permanente (agregar a `~/.bashrc` o `~/.zshrc`):
```bash
echo 'export OCR_LANG="eng+spa"' >> ~/.bashrc
source ~/.bashrc
```

### Códigos de idioma comunes:
- `eng` - Inglés
- `spa` - Español
- `fra` - Francés
- `deu` - Alemán
- `por` - Portugués
- `ita` - Italiano
- `rus` - Ruso
- `chi_sim` - Chino simplificado
- `jpn` - Japonés
- `ara` - Árabe

### Múltiples idiomas:
```bash
OCR_LANG="eng+spa"           # Inglés + Español
OCR_LANG="eng+fra+deu"       # Inglés + Francés + Alemán
OCR_LANG="spa+por"           # Español + Portugués
```

### Verificar idiomas instalados:
```bash
tesseract --list-langs
```

## Cómo funciona

### Modo Portapapeles (ocr-clipboard):
1. **Lee imagen**: Extrae imagen del portapapeles usando wl-paste (Wayland) o xclip (X11)
2. **Redimensionado**: ImageMagick aumenta el tamaño al 400% para mejor precisión
3. **OCR**: Tesseract procesa la imagen y extrae el texto
4. **Resultado**: Copia el texto al portapapeles
5. **Notificación**: Muestra notificación de éxito
6. **Limpieza**: Elimina archivos temporales automáticamente

### Modo Archivo (Spectacle integration):
1. **Captura**: Spectacle guarda la imagen temporalmente
2. **Redimensionado**: ImageMagick aumenta el tamaño al 400% para mejor precisión
3. **OCR**: Tesseract procesa la imagen y extrae el texto
4. **Portapapeles**: Copia el texto al portapapeles
5. **Notificación**: Muestra notificación de éxito
6. **Limpieza**: Elimina archivos temporales automáticamente

## Solución de problemas

### El texto no se copia al portapapeles
**Problema:** El script se ejecuta pero el texto no aparece en el portapapeles

**Soluciones:**
- Verificar que `wl-clipboard` (Wayland) o `xclip` (X11) estén instalados
- Probar manualmente:
  ```bash
  echo "test" | wl-copy && wl-paste    # Wayland
  echo "test" | xclip -selection clipboard && xclip -selection clipboard -o  # X11
  ```

### OCR no funciona correctamente / Texto incorrecto
**Problema:** El OCR no reconoce bien el texto

**Soluciones:**
- Verificar que el paquete de idioma esté instalado: `tesseract --list-langs`
- Instalar el paquete de idioma correcto: `sudo pacman -S tesseract-data-spa`
- Verificar configuración: `cat ~/.config/spectacle-ocr/config`
- Probar con imágenes de mayor calidad/resolución
- Ajustar el porcentaje de redimensionado en `~/.local/bin/ocr-spectacle.sh` (línea 41)

### No aparece la opción en Spectacle
**Problema:** No veo "Extract Text (OCR)" al hacer click derecho

**Soluciones:**
- Actualizar base de datos MIME:
  ```bash
  update-desktop-database ~/.local/share/applications/
  ```
- Reiniciar Spectacle completamente
- Verificar que el archivo `.desktop` esté correctamente instalado:
  ```bash
  ls -la ~/.local/share/applications/spectacle-ocr.desktop
  ```
- Verificar permisos del script:
  ```bash
  ls -la ~/.local/bin/ocr-spectacle.sh
  chmod +x ~/.local/bin/ocr-spectacle.sh  # Si es necesario
  ```

### Error "No image file received"
**Problema:** Aparece notificación de error al ejecutar

**Soluciones:**
- Verificar que Spectacle esté pasando correctamente el archivo
- Probar manualmente con una imagen:
  ```bash
  ~/.local/bin/ocr-spectacle.sh /path/to/image.png
  ```
- Verificar logs del sistema: `journalctl -f` (mientras ejecutas el script)

### Cambio de idioma no tiene efecto
**Problema:** Cambié la configuración pero sigue usando inglés

**Soluciones:**
- Verificar el contenido del archivo de configuración:
  ```bash
  cat ~/.config/spectacle-ocr/config
  ```
- Asegurarse de que el idioma esté instalado: `tesseract --list-langs`
- Probar directamente con variable de entorno:
  ```bash
  OCR_LANG="spa" ~/.local/bin/ocr-spectacle.sh /path/to/image.png
  ```

## Desinstalación

### Método 1: Script automático (Recomendado)

```bash
chmod +x uninstall.sh
./uninstall.sh
```

Para desinstalar sin confirmación:
```bash
./uninstall.sh -y
```

### Método 2: Manual

```bash
rm ~/.local/bin/ocr-spectacle.sh
rm ~/.local/bin/ocr-clipboard
rm ~/.local/share/applications/ocr-from-image-file.desktop
rm ~/.local/share/applications/ocr-from-clipboard.desktop
rm -rf ~/.config/spectacle-ocr
update-desktop-database ~/.local/share/applications/
```

## Créditos

- Idea original y artículo: [Kaloian Kozlev](https://kozlev.com/ocr-for-spectacle/)
- Implementación: Basada en el artículo anterior

## Licencia

MIT License