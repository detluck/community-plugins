local M = {}

local home = noctalia.getenv("HOME") or ""
local xdgConfig = noctalia.getenv("XDG_CONFIG_HOME")
local configDir = (xdgConfig and xdgConfig ~= "") and xdgConfig or (home .. "/.config")

local PERF_CONFIG_PATH = "/tmp/noctalia-umbriel-perf.toml"
local BASE_CONFIG_PATH = configDir .. "/umbriel/config.toml"

function M.enable(opts)
    if opts.blur ~= false then
        noctalia.runAsync({"umbriel", "msg", "effect-screen-set:off"})
    end

    local toml = string.format([[
[include]
files = ["%s"]

[appearance.blur]
enabled = false

[[layer_rule]]
match.namespace = "^noctalia-"
blur = false

[[window_rule]]
blur = false
]], BASE_CONFIG_PATH)

    -- Write temp override and hot-replace config in Umbriel only if base config exists
    local cmd = string.format("sh -c 'if [ -f \"%s\" ]; then cat << \"EOF\" > %s\n%s\nEOF\numbriel config-replace %s; fi'", BASE_CONFIG_PATH, PERF_CONFIG_PATH, toml, PERF_CONFIG_PATH)
    noctalia.runAsync(cmd)

    noctalia.log("[Umbriel] Performance mode enabled (blur & screen effects disabled)")
end

function M.disable(opts)
    if opts.blur ~= false then
        noctalia.runAsync({"umbriel", "msg", "effect-screen-set:reset"})
    end

    local cmd = string.format("sh -c 'if [ -f \"%s\" ]; then umbriel config-replace %s; fi; rm -f %s'", BASE_CONFIG_PATH, BASE_CONFIG_PATH, PERF_CONFIG_PATH)
    noctalia.runAsync(cmd)

    noctalia.log("[Umbriel] Performance mode disabled (restored base config)")
end

return M
