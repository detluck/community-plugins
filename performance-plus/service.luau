local core = require("./core.luau")

function onIpc(event, payload)
    if event == "toggle" then
        local current = noctalia.state.get("performance") == true
        local newMode = not current
        noctalia.state.set("performance", newMode)
        core.toggle(newMode)
        noctalia.log(string.format("[Service] IPC toggled Performance Plus: %s", tostring(newMode)))
    elseif event == "enable" then
        noctalia.state.set("performance", true)
        core.toggle(true)
        noctalia.log("[Service] IPC enabled Performance Plus")
    elseif event == "disable" then
        noctalia.state.set("performance", false)
        core.toggle(false)
        noctalia.log("[Service] IPC disabled Performance Plus")
    end
end

function onExit(_signal, _reason)
    if noctalia.state.get("performance") == true then
        noctalia.state.set("performance", false)
        core.toggle(false)
    end
end
