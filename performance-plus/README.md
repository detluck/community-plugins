# Performance Plus for Noctalia

A high-performance gaming, rendering, and immersion plugin for the [Noctalia](https://github.com/noctalia-dev/noctalia) desktop shell.

## Features

### 1. Compositor Visual Effects (Universal Support)
Dynamically disables heavy compositor effects during gameplay/rendering and restores them when toggled off:
- **Hyprland:** Disables blur, shadows, and animations (supports both modern Hyprland Lua configurations via `hyprctl eval` and legacy `.conf` setups).
- **Niri:** Hot-swaps configuration via `niri msg action load-config-file` to turn off animations (`animations { off }`) and client background blur.
- **Umbriel:** Suppresses active shaders (`umbriel msg effect-screen-set:off`) and hot-swaps blur rules.
- **Sway / SwayFX:** Disables blur, shadows, corner radius, and dimming via `swaymsg`.
- **KWin:** Unloads compositor effects (`blur`, `slide`, `scale`, `fade`, `translucency`, `sheet`) via DBus.
- **Mango:** Hot-swaps configuration via `mmsg dispatch load_config_file` to turn off blur, animations, and shadows, then restores default config.
- **Labwc:** Triggers reconfigure without disrupting windows.

### 2. Desktop Shell Optimizations
- **Unmap Wallpapers:** Destroys layer-shell background surfaces completely to release GPU textures and VRAM.
- **Hide Desktop Widgets:** Tears down desktop widget instances to stop CPU/GPU ticking.
- **Do Not Disturb (DND):** Silences incoming notification toasts.
- **Dismiss Active Notifications:** Clears any currently floating notification popups immediately upon entering performance mode.
- **UPower Performance Governor:** Sets system power profile to `performance` (and restores to `balanced`).
- **Hide Status Bar & Dock:** Optionally unmaps Noctalia's top/bottom bars and dock for full screen immersion.
- **Disable OSD Popups:** Suppresses volume and brightness OSD overlays to prevent game frame drops and focus loss.
- **Pause Media:** Pauses active MPRIS audio/video playback when engaged.

### 3. Custom Shell Hooks
- **Shell Hooks:** Execute custom commands or shell scripts on enter (`hook_on_enter`) and exit (`hook_on_exit`).

---

## Usage

### 1. Control Center
Open Noctalia's Control Center and click the **Performance Plus** quick tile (rocket icon).

### 2. Status Bar Widget
Add the `detluck/performance-plus:indicator` widget to your Noctalia bar. Left-clicking toggles Performance Plus.

### 3. Keybindings & IPC
Bind a key combination in your compositor config:

#### Hyprland (`hyprland.conf` or `hyprland.lua`)
```ini
bind = $mainMod, F12, exec, noctalia msg plugin "detluck/performance-plus:service" all toggle
```

#### Niri (`config.kdl`)
```kdl
binds {
    Mod+F12 { spawn-sh "noctalia msg plugin 'detluck/performance-plus:service' all toggle"; }
}
```

#### Sway / Umbriel
```bash
noctalia msg plugin "detluck/performance-plus:service" all toggle
```

---

## Configuration

All features can be individually toggled in **Settings → Plugins → Performance Plus**:
- `disable_wallpaper` (default: `true`)
- `disable_blur` (default: `true`)
- `disable_animations` (default: `true`)
- `hide_widgets` (default: `true`)
- `enable_dnd` (default: `true`)
- `clear_notifications` (default: `true`)
- `set_power_profile` (default: `true`)
- `disable_osd` (default: `true`)
- `hide_bar` (default: `false`)
- `hide_dock` (default: `false`)
- `pause_media` (default: `false`)
- `hook_on_enter` (default: `""`)
- `hook_on_exit` (default: `""`)

---

## License

MIT License.
