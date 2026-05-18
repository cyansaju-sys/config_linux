# Configuración de fastfetch y Kitty

personalización de la terminal

## Clone el repositorio

```bash
git clone https://github.com/cyansaju-sys/config_linux.git
```

## fastfetch
![example](./exaple/fastfetch.png)
Muestra información del sistema al abrir la terminal. Usa imagen personalizada (Miku) renderizada con el protocolo gráfico de Kitty.

### Dependencias

##### Distribuciones basadas en Arch Linux
```bash
pacman -S fastfetch
```

##### Distribuciones basadas en Debian

```bash
apt install fastfetch

```

### Instalación

```bash
mkdir -p ~/.config/fastfetch
# copiar el directorio fastfetch
cp -r .config/fastfetch ~/.config/fastfetch

```

### Módulos que muestra

| Módulo    | Descripción              |
|-----------|--------------------------|
| Kernel    | Versión del kernel        |
| Packages  | Paquetes instalados       |
| WM        | Gestor de ventanas        |
| Icons     | Tema de iconos            |
| Font      | Fuente del sistema        |
| CPU       | Procesador                |
| GPU       | Tarjeta gráfica           |
| Memory    | RAM usada / total         |
| Swap      | Swap usada / total        |
| Network   | IP local                  |
| Uptime    | Tiempo encendido          |

### Notas

- El logo requiere que el terminal sea **Kitty** (usa `type: "kitty"` para el protocolo gráfico).
- Para cambiar la imagen, reemplaza `~/.config/fastfetch/images/miku.png` y ajusta `width`/`height` en `config.jsonc` si es necesario.
- Para ejecutarlo automáticamente al abrir la terminal, agrega `fastfetch` al final de `~/.zshrc` o `~/.bashrc`.

---

## kitty
![example](./exaple/kitty.png)

Terminal emulador con soporte de GPU, protocolo gráfico, pestañas y alta personalización.

### Dependencias

##### Distribuciones basadas en Arch Linux
```bash
pacman -S kitty
```

##### Distribuciones basadas en Debian
```bash
apt install kitty
```


> **Opcional:** instala una Nerd Font para ver los iconos correctamente (ej. JetBrains Mono Nerd Font).
> ```bash
> pacman -S ttf-jetbrains-mono-nerd
> ```

### Instalación

```bash
mkdir -p ~/.config/kitty
# copiar el directorio kitty
cp -r .config/kitty ~/.config/kitty
```

### Configuración principal (`kitty.conf`)

| Sección       | Opciones destacadas                                              |
|---------------|------------------------------------------------------------------|
| Fuente        | Tamaño 10pt. Descomenta `font_family` para usar Nerd Font.       |
| Ventana       | Padding de 4px, opacidad 85%, recuerda tamaño al reabrir.        |
| Tab bar       | Estilo powerline slanted en la parte inferior.                   |
| Scrollback    | 10 000 líneas de historial.                                      |
| URLs          | Subrayado curly, se abren con la app por defecto del sistema.    |
| Clipboard     | Copia automática al seleccionar texto.                           |
| Shell         | Usa `/usr/bin/zsh` con shell integration activada.               |
| Rendimiento   | Repaint delay 8ms, input delay 3ms, sincronizado al monitor.     |

### Atajos de teclado

| Atajo                | Acción                                      |
|----------------------|---------------------------------------------|
| `Ctrl+Shift+Enter`   | Nueva ventana en el directorio actual        |
| `Ctrl+Shift+T`       | Nueva pestaña en el directorio actual        |
| `Ctrl+=`             | Aumentar tamaño de fuente                    |
| `Ctrl+-`             | Reducir tamaño de fuente                     |
| `Ctrl+0`             | Restaurar tamaño de fuente                   |
| `Ctrl+Shift+K`       | Limpiar pantalla y scrollback                |
| `Ctrl+Shift+U`       | Scroll una página arriba                     |
| `Ctrl+Shift+D`       | Scroll una página abajo                      |
| `F11`                | Pantalla completa                            |
| `Ctrl+Shift+A M/L`   | Subir / bajar opacidad (dynamic opacity)     |


---

## zsh
![example](./exaple/zshconf.png)

Configuración de `~/.zshrc` para ejecutar fastfetch **solo en la primera ventana de Kitty**. Las ventanas siguientes no lo muestran, y si se cierra la que lo ejecutó, la próxima ventana vuelve a mostrarlo.

### Instalación

```bash
cp .zshrc ~/.zshrc
```

O agrega el bloque directamente al final de tu `~/.zshrc`:

```zsh
# Run fastfetch only in the first Kitty terminal; resets when that terminal closes
if [[ -n "$KITTY_WINDOW_ID" ]]; then
  _fastfetch_lock="/tmp/.fastfetch_shown_kitty"
  if [[ -f "$_fastfetch_lock" ]]; then
    _fastfetch_pid=$(<"$_fastfetch_lock")
    kill -0 "$_fastfetch_pid" 2>/dev/null || rm -f "$_fastfetch_lock"
    unset _fastfetch_pid
  fi
  if [[ ! -f "$_fastfetch_lock" ]]; then
    echo "$$" > "$_fastfetch_lock"
    fastfetch
  fi
  unset _fastfetch_lock
fi
```

### Cómo funciona

| Paso | Qué hace |
|------|----------|
| `$KITTY_WINDOW_ID` | Solo se activa en Kitty; VSCode, GNOME Terminal, etc. quedan excluidos. |
| Lock file | Guarda el PID del shell que corrió fastfetch en `/tmp/.fastfetch_shown_kitty`. |
| `kill -0 <pid>` | Verifica si ese shell sigue vivo sin matarlo. |
| PID muerto | El lock se borra y la próxima terminal corre fastfetch. |
| PID vivo | La terminal original sigue abierta; no se repite fastfetch. |
