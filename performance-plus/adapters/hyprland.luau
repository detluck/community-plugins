local M = {}

local function apply(blur, animations, shadow)
    local decParts = {}
    local rootParts = {}
    local legacyCmds = {}

    if blur ~= nil then
        table.insert(decParts, string.format("blur = { enabled = %s }", tostring(blur)))
        table.insert(legacyCmds, string.format("hyprctl keyword decoration:blur:enabled %s", tostring(blur)))
    end

    if shadow ~= nil then
        table.insert(decParts, string.format("shadow = { enabled = %s }", tostring(shadow)))
        table.insert(legacyCmds, string.format("hyprctl keyword decoration:shadow:enabled %s", tostring(shadow)))
    end

    if #decParts > 0 then
        table.insert(rootParts, "decoration = { " .. table.concat(decParts, ", ") .. " }")
    end

    if animations ~= nil then
        table.insert(rootParts, string.format("animations = { enabled = %s }", tostring(animations)))
        table.insert(legacyCmds, string.format("hyprctl keyword animations:enabled %s", animations and "1" or "0"))
    end

    local luaConfig = "hl.config({ " .. table.concat(rootParts, ", ") .. " })"
    local legacyScript = table.concat(legacyCmds, "; ")

    -- Hybrid execution: try modern Hyprland Lua parser first (Hyprland 0.56+), fall back to legacy hyprctl keyword
    local cmd = string.format([[sh -c '
if hyprctl eval "%s" 2>&1 | grep -q "ok"; then
    exit 0
fi
%s
']], luaConfig, legacyScript)

    noctalia.runAsync(cmd)
end

function M.enable(opts)
    local disableBlur = (opts.blur == true) and false or nil
    local disableAnim = (opts.animations == true) and false or nil
    local disableShadows = (opts.shadows == true) and false or nil

    apply(disableBlur, disableAnim, disableShadows)
    noctalia.log("[Hyprland] Performance mode enabled (blur & animations disabled)")
end

function M.disable(opts)
    local restoreBlur = (opts.blur == true) and true or nil
    local restoreAnim = (opts.animations == true) and true or nil
    local restoreShadows = (opts.shadows == true) and true or nil

    apply(restoreBlur, restoreAnim, true)
    noctalia.log("[Hyprland] Performance mode disabled (blur & animations restored)")
end

return M
