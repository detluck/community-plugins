local M = {}
local adapter = require("./adapters/init.luau")

local DEFAULTS = {
  disable_wallpaper = true,
  disable_blur = true,
  disable_animations = true,
  hide_widgets = true,
  enable_dnd = true,
  clear_notifications = true,
  set_power_profile = true,
  hide_bar = false,
  hide_dock = false,
  disable_osd = true,
  pause_media = false,
  hook_on_enter = "",
  hook_on_exit = "",
}

local function getSetting(key)
  local val = noctalia.getConfig(key)
  if val == nil then
    return DEFAULTS[key]
  end
  return val
end

local function setWallpapers(enabled)
  local outputs = noctalia.outputs()
  for _, out in ipairs(outputs) do
    noctalia.setWallpaperEnabled(out.name, enabled)
  end
end

local function setDesktopWidget(enabled)
  local action = enabled and "desktop-widgets-show" or "desktop-widgets-hide"
  noctalia.runAsync({"noctalia", "msg", action})
end

local function setDnd(enabled)
  noctalia.runAsync({"noctalia", "msg", "notification-dnd-set", enabled and "true" or "false"})
end

local function clearActiveNotifications()
  noctalia.runAsync({"noctalia", "msg", "notification-clear-active"})
end

local function setPerformancePowerMode(enabled)
  local mode = enabled and "performance" or "balanced"
  noctalia.runAsync({"noctalia", "msg", "power-set", mode})
end

local function setBarVisibility(show)
  noctalia.runAsync({"noctalia", "msg", show and "bar-show" or "bar-hide"})
end

local function setDockVisibility(show)
  noctalia.runAsync({"noctalia", "msg", show and "dock-show" or "dock-hide"})
end

local function setOsdEnabled(enabled)
  noctalia.runAsync({"noctalia", "msg", enabled and "osd-enable" or "osd-disable"})
end

local function pauseMediaPlayback()
  noctalia.runAsync({"noctalia", "msg", "media", "pause"})
end

local function runHook(cmd)
  if cmd and cmd ~= "" then
    noctalia.runAsync(cmd)
  end
end

function M.toggle(perfMode)
  -- 1. Wallpapers (release background textures & surfaces)
  if getSetting("disable_wallpaper") then
    setWallpapers(not perfMode)
  end

  -- 2. Desktop Widgets (stop rendering and compute)
  if getSetting("hide_widgets") then
    setDesktopWidget(not perfMode)
  end

  -- 3. Notifications Do Not Disturb
  if getSetting("enable_dnd") then
    setDnd(perfMode)
  end

  -- 4. Clear currently visible notification popups
  if perfMode and getSetting("clear_notifications") then
    clearActiveNotifications()
  end

  -- 5. Power Profile (UPower governor)
  if getSetting("set_power_profile") then
    setPerformancePowerMode(perfMode)
  end

  -- 6. Hide Status Bar (complete screen immersion)
  if getSetting("hide_bar") then
    setBarVisibility(not perfMode)
  end

  -- 7. Hide Dock
  if getSetting("hide_dock") then
    setDockVisibility(not perfMode)
  end

  -- 8. Disable OSD Popups (prevent game interruptions)
  if getSetting("disable_osd") then
    setOsdEnabled(not perfMode)
  end

  -- 9. Pause background media playback
  if perfMode and getSetting("pause_media") then
    pauseMediaPlayback()
  end

  -- 10. Custom Shell Hooks (v4 parity)
  if perfMode then
    runHook(getSetting("hook_on_enter"))
  else
    runHook(getSetting("hook_on_exit"))
  end

  -- 11. Compositor Visual Effects (Blur, Animations, Shadows)
  local opts = {
    blur = getSetting("disable_blur"),
    animations = getSetting("disable_animations"),
    shadows = getSetting("disable_shadows"),
  }

  if perfMode then
    adapter.enable(opts)
  else
    adapter.disable(opts)
  end
end

return M
