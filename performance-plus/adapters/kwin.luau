local M = {}

local EFFECTS_TO_DISABLE = {
    "blur",
    "slide",
    "scale",
    "fade",
    "windowgeometry",
    "translucency",
    "sheet",
}

local function runKwinEffects(action, effects)
    local effectArgs = table.concat(effects, " ")
    local script = string.format([[
sh -c '
kwin_call() {
    if command -v qdbus6 >/dev/null 2>&1; then
        qdbus6 org.kde.KWin /Effects "$1" "$2" 2>/dev/null || true
    elif command -v qdbus >/dev/null 2>&1; then
        qdbus org.kde.KWin /Effects "$1" "$2" 2>/dev/null || true
    elif command -v busctl >/dev/null 2>&1; then
        busctl --user call org.kde.KWin /Effects org.kde.kwin.Effects "$1" s "$2" >/dev/null 2>&1 || true
    fi
}
for effect in %s; do
    kwin_call %s "$effect"
done
if [ "%s" = "loadEffect" ]; then
    if command -v qdbus6 >/dev/null 2>&1; then
        qdbus6 org.kde.KWin /KWin reconfigure 2>/dev/null || true
    elif command -v qdbus >/dev/null 2>&1; then
        qdbus org.kde.KWin /KWin reconfigure 2>/dev/null || true
    elif command -v busctl >/dev/null 2>&1; then
        busctl --user call org.kde.KWin /KWin org.kde.KWin reconfigure >/dev/null 2>&1 || true
    fi
fi
'
]], effectArgs, action, action)

    noctalia.runAsync(script)
end

function M.enable(opts)
    local effects = {}
    if opts.blur ~= false then
        table.insert(effects, "blur")
    end

    if opts.animations ~= false then
        for _, effect in ipairs(EFFECTS_TO_DISABLE) do
            if effect ~= "blur" then
                table.insert(effects, effect)
            end
        end
    end

    if #effects > 0 then
        runKwinEffects("unloadEffect", effects)
    end

    noctalia.log("[KWin] Performance mode enabled (blur & desktop effects unloaded)")
end

function M.disable(opts)
    local effects = {}
    if opts.blur ~= false then
        table.insert(effects, "blur")
    end

    if opts.animations ~= false then
        for _, effect in ipairs(EFFECTS_TO_DISABLE) do
            if effect ~= "blur" then
                table.insert(effects, effect)
            end
        end
    end

    if #effects > 0 then
        runKwinEffects("loadEffect", effects)
    end

    noctalia.log("[KWin] Performance mode disabled (restored desktop effects & reconfigured)")
end

return M
