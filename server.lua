local function OnPlayerConnecting(name, setKickReason, deferrals)
    local player = source
    local steamIdentifier
    local identifiers = GetPlayerIdentifiers(player)
    deferrals.defer()

    Wait(0)

    deferrals.update("Forbinder til Steam...")

    for _, v in pairs(identifiers) do
        if string.find(v, "steam") then
            steamIdentifier = v
            break
        end
    end

    Wait(0)

    if not steamIdentifier then
        deferrals.done("[FiveM Modder Advarsel] Du er ikke forbundet til Steam")
    else
        PerformHttpRequest("http://64.225.105.125:8081/verify=" .. steamIdentifier, function(err, text, headers)
            if text == "false" then
                print("[FiveM Modder Advarsel] " .. steamIdentifier .. " udelukket")
                deferrals.done("[FiveM Modder Advarsel] Du er udelukket fra denne server")
            else
                deferrals.done()
            end
        end, 'GET', '')
    end
end

AddEventHandler("playerConnecting", OnPlayerConnecting)