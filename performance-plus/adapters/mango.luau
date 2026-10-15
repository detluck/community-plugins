local M = {}

local home = noctalia.getenv("HOME") or ""
local xdgConfig = noctalia.getenv("XDG_CONFIG_HOME")
local configDir = (xdgConfig and xdgConfig ~= "") and xdgConfig or (home .. "/.config")

local PERF_CONFIG_PATH = "/tmp/noctalia-mango-perf.conf"
local BASE_CONFIG_PATH = configDir .. "/mango/config.conf"

function M.enable(opts)
    if opts.animations == false and opts.blur == false then
        return
    end

    local lines = {
        string.format("source=%s", BASE_CONFIG_PATH)
    }

    if opts.blur ~= false then
        table.insert(lines, "blur=0")
        table.insert(lines, "blur_layer=0")
    end

    if opts.animations ~= false then
        table.insert(lines, "animations=0")
        table.insert(lines, "layer_animations=0")
    end

    if opts.shadows ~= false then
      table.insert(lines, "shadows=0")
      table.insert(lines, "layer_shadows=0")
    end

    local content = table.concat(lines, "\n") .. "\n"

    -- Write temp override and hot-load it in Mango via mmsg dispatch load_config_file
    local cmd = string.format(
        "sh -c 'if [ -f \"%s\" ]; then cat << \"EOF\" > %s\n%sEOF\nmmsg dispatch load_config_file,%s; fi'",
        BASE_CONFIG_PATH, PERF_CONFIG_PATH, content, PERF_CONFIG_PATH
    )
    noctalia.runAsync(cmd)

    noctalia.log("[Mango] Performance mode enabled (effects disabled via load_config_file)")
end

function M.disable(opts)
    -- Reset to default config and clean up temp file
    local cmd = string.format("sh -c 'mmsg dispatch load_config_file,; mmsg dispatch reload_config 2>/dev/null; rm -f %s'", PERF_CONFIG_PATH)
    noctalia.runAsync(cmd)

    noctalia.log("[Mango] Performance mode disabled (restored default config)")
end

return M
