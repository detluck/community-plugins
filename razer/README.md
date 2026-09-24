# Razer Devices

Monitor and control Razer peripherals including DPI sensitivity, LED brightness, RGB lighting presets, theme synchronization, and wireless battery levels.

## Plugin

| Field   | Value                                                     |
| ------- | --------------------------------------------------------- |
| ID      | `detluck/razer`                                           |
| Entries | Bar widget: `battery`; panel: `panel`; service: `monitor` |

## Requirements

Install `openrazer-daemon` and ensure the OpenRazer driver is loaded:

- **Arch Linux**: `sudo pacman -S openrazer-daemon`
- Add your user to the `openrazer` group: `sudo gpasswd -a $USER openrazer` (or `plugdev` on Debian/Ubuntu)
- Enable and start the user service: `systemctl --user enable --now openrazer-daemon`

## Usage

Add the bar widget (`detluck/razer:battery`) in **Settings → Bar → Widgets** or by editing your bar configuration in `settings.toml`.

### Interactions

- **Left-Click Widget**: Toggle the Razer Control Center panel.
- **Right-Click Widget**: Instantly synchronize RGB lighting with the active desktop theme accent color.
- **CLI / Keybind**: Toggle the floating panel anytime via:

```sh
noctalia msg panel-toggle detluck/razer:panel
```

## Settings

| Setting                 | Type   | Default | Description                                                                                        |
| ----------------------- | ------ | ------- | -------------------------------------------------------------------------------------------------- |
| `sync_theme_color`      | `bool` | `false` | Automatically synchronize Razer Chroma RGB lighting with the desktop theme accent color on change. |
| `low_battery_threshold` | `int`  | `20`    | Battery percentage below which a desktop low-battery warning notification is sent.                 |
| `show_percentage`       | `bool` | `true`  | Display battery percentage number next to the mouse icon on the bar widget for wireless devices.   |

## IPC

Dispatch events to the background monitor service:

```sh
# Force immediate RGB sync with current desktop theme color:
noctalia msg plugin detluck/razer:monitor all sync_theme

# Force immediate device state poll & refresh:
noctalia msg plugin detluck/razer:monitor all refresh
```

## Notes

- **Communication**: Communicates entirely locally over the D-Bus session bus with `org.razer` (`openrazer-daemon`). No network requests are made.
- **Hardware Support**: Any Razer device supported by OpenRazer (120+ models including DeathAdder, Viper, Basilisk, Naga, BlackWidow, Huntsman, Kraken, Firefly).
- **Multiple Devices**: Displays stacked controls in a scrollable panel (`ui.scroll`) when multiple mice, keyboards, or headsets are connected simultaneously.
- **Hardware DPI Sync**: Detects hardware DPI changes (e.g. from physical mouse DPI buttons) in real-time.
