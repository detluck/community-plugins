local M = {}

local home = noctalia.getenv("HOME") or ""
local xdgConfig = noctalia.getenv("XDG_CONFIG_HOME")
local configDir = (xdgConfig and xdgConfig ~= "") and xdgConfig or (home .. "/.config")

local PERF_CONFIG_PATH = "/tmp/noctalia-niri-perf.kdl"
local BASE_CONFIG_PATH = configDir .. "/niri/config.kdl"

function M.enable(opts)
    if opts.animations == false and opts.blur == false and opts.shadows == false then
        return
    end

    local kdl = string.format([[
include "%s"

animations {
    off
}

window-rule {
    background-effect {
        blur false
    }
}

layer-rule {
    match namespace="^noctalia-"
    background-effect {
        blur false
    }
}
]], BASE_CONFIG_PATH)

    -- Write temp override and load it in Niri only if base config exists
    local cmd = string.format("sh -c 'if [ -f \"%s\" ]; then cat << \"EOF\" > %s\n%s\nEOF\nniri msg action load-config-file --path %s; fi'", BASE_CONFIG_PATH, PERF_CONFIG_PATH, kdl, PERF_CONFIG_PATH)
    noctalia.runAsync(cmd)

    noctalia.log("[Niri] Performance mode enabled (animations & background-effects disabled)")
end

function M.disable(opts)
    -- Reload base config in Niri and cleanup temp override
    local cmd = string.format("sh -c 'niri msg action load-config-file; rm -f %s'", PERF_CONFIG_PATH)
    noctalia.runAsync(cmd)

    noctalia.log("[Niri] Performance mode disabled (restored base config)")
end

return M
