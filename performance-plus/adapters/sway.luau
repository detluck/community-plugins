local M = {}

function M.enable(opts)
    local cmds = {}
    if opts.blur ~= false then
        table.insert(cmds, "swaymsg blur disable 2>/dev/null || true")
    end
    table.insert(cmds, "swaymsg shadows disable 2>/dev/null || true")
    table.insert(cmds, "swaymsg corner_radius 0 2>/dev/null || true")
    table.insert(cmds, "swaymsg default_dim_inactive 0.0 2>/dev/null || true")

    local script = table.concat(cmds, "; ")
    noctalia.runAsync(string.format("sh -c '%s'", script))
    noctalia.log("[Sway] Performance mode enabled (SwayFX effects disabled)")
end

function M.disable(opts)
    local cmds = {}
    if opts.blur ~= false then
        table.insert(cmds, "swaymsg blur enable 2>/dev/null || true")
    end
    table.insert(cmds, "swaymsg shadows enable 2>/dev/null || true")
    -- Reload Sway configuration to cleanly restore custom corner_radius, default_dim_inactive, and styles
    table.insert(cmds, "swaymsg reload 2>/dev/null || true")

    local script = table.concat(cmds, "; ")
    noctalia.runAsync(string.format("sh -c '%s'", script))
    noctalia.log("[Sway] Performance mode disabled (SwayFX effects & config restored)")
end

return M
