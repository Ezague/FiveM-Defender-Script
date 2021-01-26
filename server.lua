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
    deferrals.update("Finding identifiers...")

    for k,v in pairs(identifiers)do
        PerformHttpRequest("https://fivem.dk/defender/single/" .. v, function(err, text, headers)
            if text == '{"status":"found"}' then
                if not checkBypass(v) then
                    found = true
                    print("[FiveM Defender] " .. v .. " excluded due to confirmed modding.")
                    deferrals.done("[FiveM Defender] You are excluded from this server due to modding.")
                else
                    print('[FiveM Defender] ' .. v .. ' was a modder, but was allowed access to the server because you set them up in your bypass.')
                end
            end
        end, 'GET', '')
    end
    Wait(1000)
    if not found then deferrals.done() end
end

AddEventHandler("playerConnecting", OnPlayerConnecting)

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        PerformHttpRequest("https://fivem.dk/defender/version", function(err, text, headers)
            if text == '1.3' then
                print("[FiveM Defender] The script is up to date")
            else
                print("\27[31m [FiveM Defender] OUTDATED - Download newest version from: https://github.com/Ezague/FiveM-Defender-Script \27[0m")
            end
        end, 'GET', '')
    end
end)

function checkBypass(identifier)
    for k,v in pairs(Config.Bypass) do
        if v == identifier then
            return true
        end
    end
    return false
end
