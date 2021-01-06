local function OnPlayerConnecting(name, setKickReason, deferrals)
    local player = source
    local identifiers = GetPlayerIdentifiers(player)

    local steamid  = false
    local license  = false
    local discord  = false
    local xbl      = false
    local liveid   = false
    found          = false
    deferrals.defer()

    Wait(0)
    deferrals.update("Finder identifiers...")

    for k,v in pairs(identifiers)do
        PerformHttpRequest("https://fivem.dk/defender/single/" .. v, function(err, text, headers)
            if text == '{"status":"found"}' then
                found = true
                print("[FiveM Defender] " .. v .. " excluded due to confirmed modding.")
                deferrals.done("[FiveM Defender] You are excluded from this server due to modding.")
            end
        end, 'GET', '')
    end

    Wait(1000)
    if not found then deferrals.done() end
end

AddEventHandler("playerConnecting", OnPlayerConnecting)